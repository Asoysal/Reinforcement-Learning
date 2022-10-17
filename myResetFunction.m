function [InitialObservation,LoggedSignals] = myResetFunction()
 

                goal_point = [6;27;4];

%      start =load('train_adj.mat').train_adj;
%     start =load('test.mat').test;
%     start =load('train.mat').train;
        start =load('test.mat').test;
%            start =  load('start_posint_test.mat').startpoint_test  ;
%              endp =  load('endpoint_test.mat').endpoint_test;
             

             loop1 =1;
             while loop1
                 index =   randi([1 length(start)],1,1);       
             if index ~= 0 && index <=length(start)-1
                 loop1= 0;
             end
             end
             start_point = start(:,index);
 
%              start_point = [15;9;7];
%              Wo = load('Wo.mat').Wo;
             Wt = load('Wt.mat').Wt;
             W = load('W.mat').W;
             options.nb_iter_max = Inf;
             options.Tmax = sum(size(W));
             
             f1(1) = Mobile_Robot3D(start_point,Wt);
             f1(1) = f1(1).findPath(goal_point, options);
             
             cor_fol1 = normalisation(f1(1).path, 100);
             
            LoggedSignals.State = cor_fol1;

            InitialObservation = LoggedSignals.State;

             


end







