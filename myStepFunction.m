function [NextObs,Reward,IsDone,LoggedSignals] = myStepFunction(Action,LoggedSignals)

% define enviroments constant
col_cell_size =2;
% start_point2 =[2;8;2];  %[4;37;2];
% end_points2 =[49;64;5];       %  [20;13;10];
nor_UAVfol2 =  load('main_path.mat').main_path;
Wo = load('Wo.mat').Wo;

% Wt = load('Wt.mat').Wt;
% W = load('W.mat').W;
% MaxForce = 1;
% goal_point = [7;64;2];
% options.nb_iter_max = Inf;
% options.Tmax = sum(size(W));

linear_speed = 1;
hav_coll = 0;
out_lim = 0 ;

% total_col = 0;



% Get action
Movement = Action;


% Unpack state vector
State = LoggedSignals.State;

cor_fol1 = State;
%             %calculate distance matrix
%             Distance_matrix =  Find_Distance(this,cor_fol1);

size_cor_fol_1 = length(cor_fol1);

if size_cor_fol_1 >= length(nor_UAVfol2)
    low_size = length(nor_UAVfol2);
else
    low_size = size_cor_fol_1;
end%if

Distance_matrix= zeros(100,low_size);
for i=1:1:low_size
    for j=1:1:100
        Distance_matrix(j,i) = norm(cor_fol1(:,i)'- nor_UAVfol2(:,j)');
    end %for
    
end % for

[main_po,candidate_po]= find(Distance_matrix<= 2,1);
[main_po_all,candidate_po_all]= find(Distance_matrix<= 2);

% for reward last collision point
candidate_po_all = unique(candidate_po_all);
last_col_point = candidate_po_all(end);

can_cor_fol1 = cor_fol1(:,candidate_po);
main_cor = nor_UAVfol2(:,main_po);
angular_speed = Movement;



%% do action
can_cor_fol1(3,1)=  can_cor_fol1(3,1) + (linear_speed * sind(angular_speed)) ;
    



% check the boundary

if can_cor_fol1(1,1) > 30
    out_lim = 1;
elseif can_cor_fol1(2,1) > 30
    out_lim = 1;
elseif can_cor_fol1(3,1) > 15
    out_lim = 1;
elseif can_cor_fol1(1,1) < 3
    out_lim = 1;
elseif can_cor_fol1(2,1) < 3
    out_lim = 1;
elseif can_cor_fol1(3,1) < 3
    out_lim = 1;
end

         cor_fol1(:,candidate_po) = can_cor_fol1;
            
         
         
         
         if out_lim == 0
             % check the distance after action
             Distance_After_1_point = norm(cor_fol1(:,candidate_po)'-main_cor(:,1)');
             %chech the obstacles
             nu_obs_col = find(Wo(round(cor_fol1(1,candidate_po)),round(cor_fol1(2,candidate_po)),round(cor_fol1(3,candidate_po))) == 1, 1);
             
%              disp(Distance_After_1_point);
             if Distance_After_1_point <= col_cell_size || isempty(nu_obs_col) == 0
                 hav_coll = 1;
             else
                 hav_coll = 0;
             end
         end%if
         
         
         
         
size_cor_fol_1 = length(cor_fol1);

if size_cor_fol_1 >= length(nor_UAVfol2)
    low_size = length(nor_UAVfol2);
else
    low_size = size_cor_fol_1;
end%if

distance_matrix_total= zeros(100,low_size);
for i=1:1:low_size
    for j=1:1:100
        distance_matrix_total(j,i) = norm(cor_fol1(:,i)'- nor_UAVfol2(:,j)');
    end %for
    
end % for
         
    
         
         
         
         
         
         
            [nu_main, nu_can] = find(distance_matrix_total<= col_cell_size,1);
            nu_total_col = [nu_main, nu_can];
            total_col = isempty(nu_total_col);



distance_total =  norm(can_cor_fol1(:,1)'-cor_fol1(:,last_col_point)');

State = cor_fol1;

LoggedSignals.State =State;

NextObs = LoggedSignals.State;

IsDone = hav_coll == 1 ||  out_lim == 1 ||total_col == 1   ;



Reward= (1-(distance_total /44)^0.4) + (150 * total_col) - (100*hav_coll)- (100*out_lim)  ;
if total_col == 1
    disp('reach the goal');
end




end