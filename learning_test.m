


ObservationInfo = rlNumericSpec( [3 100] );




%               ObservationInfo  = rlNumericSpec( [3 200] );
% ActionInfo = rlFiniteSetSpec({[1 45],[1 25],[1 -45],[1 -25],[1 0],[2 45],[2 25],[2 -45],[2 -25],[2 0]});
% ActionInfo = rlFiniteSetSpec({[1 45],[1 25],[1 15],[1 65],[1 75],...
%     [1 -45],[1 -25],[1 0],[1 -15],[1 -65],[1 -75],...
%     [2 45],[2 25],[2 15],[2 65],[2 75],...
%     [2 -45],[2 -25],[2 0],[2 -15],[2 -65],[2 -75]});
% sayac = 1;
% suc_rate = 0;
%  n= 0;
% while sayac

% ActionInfo = rlFiniteSetSpec({[1 45],[1 25],[1 -45],[1 -25],[1 0],[2 45],[2 25],[2 -45],[2 -25],[2 0]});


ActionInfo = rlFiniteSetSpec([45 25  0 -45 -25 ]);

env2 = rlFunctionEnv(ObservationInfo,ActionInfo,'myStepFunction','myResetFunction');
opt = rlSimulationOptions('MaxSteps',600);
experience = sim(env2,agent,opt);
a = experience.Reward.Data;
nor_UAVfol2 =  load('main_path.mat').main_path;
% 
%  if experience.Reward (end,:) == 6
%      suc_rate = suc_rate + 1;
%  end
%  n = n+1;
%  disp(n);
% if n == 978
%     sayac = 0;
%     
% end
% end






% goal_point = [7;64;2];
         goal_point = [6;27;4]; % deneme 1
test_path_AI_3d= experience.Observation.obs1.Data;
number_of_step = size(test_path_AI_3d);
test_path_AI = zeros(3,100);
for i=1:1:100
    for j = 1:1:3
        test_path_AI(j,i) = test_path_AI_3d (j,i,number_of_step(1,3));
    end
end


Wo = load('Wo.mat').Wo;
Wt = load('Wt.mat').Wt;
W = load('W.mat').W;
options.nb_iter_max = Inf;
options.Tmax = sum(size(W));

first_ob = experience.Observation.obs1.Data;

number_of_step = size(first_ob);
first_ob_ai = zeros(3,100);
for i=1:1:100
    for j = 1:1:3
        first_ob_ai(j,i) = test_path_AI_3d (j,i,1);
    end
end



start_point = first_ob(:,1);          %             [17;12;5];
end_points = first_ob(:,100);         %               [5;15;3];

%   end_points = [ 50;14;2];
%      start_point = [ 16;52;5];
%    dis_goal = norm(start_point(:,1)'- end_points(:,1)');
f1(1) = Mobile_Robot3D(start_point,Wt);
f1(1) = f1(1).findPath(end_points, options);

cor_fol1 = normalisation(f1(1).path, 100);


%-----------------------------------------------------------------


 plot_city(Wo);



a = cor_fol1 ;


b1 =test_path_AI;

order = 3;
framelen = 11;
sgf = sgolayfilt(test_path_AI',order,framelen);
b2 = sgf';

size_cor_fol_1 = length(b2);

if size_cor_fol_1 >= length(nor_UAVfol2)
    low_size = length(nor_UAVfol2);
else
    low_size = size_cor_fol_1;
end%if

Distance_matrix= zeros(100,low_size);
for i=1:1:low_size
    for j=1:1:100
        Distance_matrix(j,i) = norm(b2(:,i)'- nor_UAVfol2(:,j)');
    end %for
    
end % for


[main_po,candidate_po]= find(Distance_matrix<= 2,1);



% 
plot3(b1(2,:),b1(1,:),b1(3,:), 'r-', 'LineWidth', 1);
hold on
plot3(b2(2,:),b2(1,:),b2(3,:), 'r-', 'LineWidth', 1);
hold on

plot3(a(2,:),a(1,:),a(3,:), 'g-', 'LineWidth', 1);
hold on

plot3(main_path(2,:),main_path(1,:),main_path(3,:), 'b-', 'LineWidth', 1);
hold on

% r(1) = Mobile_Robot3D(test_path_AI(:,1),Wt);
% r(1).path = test_path_AI;
% % r(2) = Mobile_Robot3D(main_path(:,1),Wt);
% % r(2).path = main_path;
% % loop
% iteration =0;
% while norm(goal_point(1:3)-r(1).position(1:3)) > 0.6 %Distance to the goal criterium && norm(main_path(1:3)-r(2).position(1:3)) > 0.6  
%     % movimiento entre visualizaciones------------------------------------
%     steps=1;
%     r(1) = r(1).move(steps);
% %         r(2) = r(2).move(steps);
%     figure(1)
%     r(1).plotLeader;
% %      r(2).plotLeader;
%     %hold on;
%     msteps = min(steps, length(r(1).path(1,:))); 
% %         msteps = min(steps, length(r(2).path(1,:)));
%     
%     %To avoid errors at the end.
%     %To use as index in the Fernet trihedron -------------------------
%     %     if length(total_steps) > 0
%     %         total_steps = [total_steps, total_steps(end)+msteps];
%     %     else
%     %         total_steps = msteps;
%     %     end
%     
%     r(1).plotLeader;
% %       r(2).plotLeader;
%     pause(0.1)
%     
%     iteration = iteration+1;
%     if iteration> 220
%         break
%     end
% end %while
% 
% 
% 
% 
% %%


% [row,col] = find(test_path_AI-cor_fol1);
% 
% 
% range_first=col(1,1)-3;
% range_last=col(end,1)+3;
% 
% if col(1,1) < 4
%     range_first = 1;
% end
%     
% if col(end,1)>197
%     range_last = 197;
% end
%     
% 
% xyz =test_path_AI (:,range_first:1:range_last);
% x = xyz (1,:);
% y= xyz (2,:);
% z= xyz (3,:);
% 
% xyz_n = interparc(length(xyz),x,y,z,'spline');
% xyz_n = xyz_n';
% % 
% % x = xyz_n (1,:);
% % y= xyz_n (2,:);
% % z= xyz_n (3,:);
% % 
% % xyz_n_2 = interparc(length(xyz_n),x,y,z,'linear');
% % xyz_n_2 = xyz_n_2';
% 
% 
% 
% 
% 
% ite = 0;
% smot_test_path_AI =test_path_AI;
% ite = 1;
% for i = col(1,1)-3:1:col(end,1)+3
%     smot_test_path_AI(:,i) = xyz_n(:,ite);
%     ite = ite+1;
% end
% 
% b2 =smot_test_path_AI ;
% 
% plot3(b2(2,:),b2(1,:),b2(3,:), 'r-', 'LineWidth', 1);
% hold on


% 
% A =test_path_AI(:,177) ;
% B = test_path_AI(:,178) ;
% Angle = subspace(A',B');

% B = smoothdata(test_path_AI);
% 
% b2 



