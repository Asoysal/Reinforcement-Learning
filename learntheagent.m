clear all
clc



ObservationInfo = rlNumericSpec( [3 100] );




%               ObservationInfo  = rlNumericSpec( [3 200] );
% ActionInfo = rlFiniteSetSpec({[1 45],[1 25],[1 15],[1 65],[1 75],...
%     [1 -45],[1 -25],[1 0],[1 -15],[1 -65],[1 -75],...
%     [2 45],[2 25],[2 15],[2 65],[2 75],...
%     [2 -45],[2 -25],[2 0],[2 -15],[2 -65],[2 -75]});
% ActionInfo = rlFiniteSetSpec({[1 45],[1 25],[1 -45],[1 -25],[1 0],[2 45],[2 25],[2 -45],[2 -25],[2 0]});

ActionInfo = rlFiniteSetSpec([45 25  0 -45 -25 ]);

env = rlFunctionEnv(ObservationInfo,ActionInfo,'myStepFunction','myResetFunction');


max_size_path = 50;
obsInfo = getObservationInfo(env);
numObservations = obsInfo.Dimension(1);
actInfo = getActionInfo(env);
actDimension = actInfo.Dimension;
numAct = actInfo.Dimension(1);
rng(0)

statePath = [
 imageInputLayer([3 100 1],'Normalization','none','Name','state')
 fullyConnectedLayer(84,'Name','CriticStateFC1')
 reluLayer('Name','CriticRelu1')
 fullyConnectedLayer(32,'Name','CriticStateFC2')];

actionPath = [
 imageInputLayer([numAct 1 1],'Normalization','none','Name','action')
 fullyConnectedLayer(32,'Name','CriticActionFC1','BiasLearnRateFactor',0)];

commonPath = [
 additionLayer(2,'Name','add')
 reluLayer('Name','CriticCommonRelu')
 fullyConnectedLayer(1,'Name','output')];
criticNetwork = layerGraph();
criticNetwork = addLayers(criticNetwork,statePath);
criticNetwork = addLayers(criticNetwork,actionPath);
criticNetwork = addLayers(criticNetwork,commonPath);
criticNetwork = connectLayers(criticNetwork,'CriticStateFC2','add/in1');
criticNetwork = connectLayers(criticNetwork,'CriticActionFC1','add/in2');

criticOptions = rlRepresentationOptions('LearnRate',0.001,'GradientThreshold',1);

critic = rlQValueRepresentation(criticNetwork,obsInfo,actInfo,...
 'Observation',{'state'},'Action',{'action'},criticOptions);

plot(criticNetwork)

agentOptions = rlDQNAgentOptions(...
  'TargetSmoothFactor',1e-3,...
 'ExperienceBufferLength',1e6,...
 'UseDoubleDQN',true,...
 'DiscountFactor',0.95,...
 'MiniBatchSize',32);
% 
agentOptions.EpsilonGreedyExploration.Epsilon=1;
agentOptions.EpsilonGreedyExploration.EpsilonDecay=0.005;
agentOptions.EpsilonGreedyExploration.EpsilonMin=0.05;


agent = rlDQNAgent(critic,agentOptions);

% trainingOptions = rlTrainingOptions(...
%  'MaxEpisodes',2500,...
%  'MaxStepsPerEpisode',500,...
%  'Verbose',true...
%  'StopTrainingCriteria',"AverageReward",...
%  'StopTrainingValue';100;...
%  'ScoreAveragingWindowLength';5);
% 


trainingOptions = rlTrainingOptions(...
 'MaxEpisodes',3000,...
 'MaxStepsPerEpisode',600,...
 'Verbose',false);











% 
% trainingOptions = rlTrainingOptions(...
%  'MaxEpisodes',10000,...
%  'MaxStepsPerEpisode',500,...
%  'Verbose',true,...
%   'StopTrainingCriteria','AverageReward',...
%  'StopTrainingValue',100,...
%   'ScoreAveragingWindowLength',5,...
%  'SaveAgentDirectory',"C:\Users\Alper Soysal\Desktop\master i4.0\TFM\TFM Alsper\Agents",...
%  'plots',"training-progress");


%  'StopTrainingCriteria','AverageReward',...
%  'StopTrainingValue',194); 




trainingStats = train(agent,env,trainingOptions);



