classdef Mobile_Robot3D
    %MOBILE_ROBOT3D Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        numID;        % num robot 
        position;     %[x;y;z]
        velocity=1;   % velocidad
        pry=1;        %priority
        lvl=10;       %level
        prev_position=[];  %[x;y;z]
        end_point;    %[x;y;z]
        path = [];    %[x1, y1, z1; x2, y2, z2... ]
        W=[];         %[xx,yy,zz] double map, first potential.
        Wf=[]; 
        D=[];         %[xx,yy,zz] double map, second potential.     
        path_done=[]; %[x1, y1, z1; x2, y2, z2... ].  
        path_time=[]; %[t_pt1, t_pt2,... ]
        path_speed=[]; %[s_pt1, s_pt2,... ]
        path_energy=[]; %[e_pt1, e_pt2,... ]
        start_time=[]; %[st_mission1, st_mission2, ...]
        end_time=[]; %[et_mission1, et_mission2, ...]
    end
    
    
    methods
                       
        function mr = Mobile_Robot3D(position, W)
            mr.position = position;
            mr.prev_position = position;
            mr.W = W;
            Wt = rescale(double(W));
            sat=0.75; % antes 0.45
            Wt = min (Wt, sat);
            mr.Wf = Wt;
        end %Mobile_Robot
        
        function mr = setTime(time)
            mr.start_time(end)=time;
        end %Mobile_Robot     
             

        function mr = findPath(mr, endpoint, options)
            mr.end_point = endpoint;
            [mr.D,~] = perform_fast_marching(mr.W, mr.end_point, options);
            gpath = compute_geodesic(mr.D,mr.position);
            [nfp,ncp]=size(gpath);
            if nfp==3 && ncp>1
               mr.path = gpath;
            else % no hay path
               mr.path = mr.position;
            end
        end %calculate_path
        
        
        function mr = findPathLuis(mr, endpoint, options)
            mr.end_point = endpoint;
            [mr.D,~] = perform_fast_marching(mr.W, mr.end_point, options);
            gpath = compute_geodesic_Luis(mr.D,mr.position);
            [nfp,ncp]=size(gpath);
            if nfp==3 && ncp>1
               mr.path = gpath;
            else % no hay path
               mr.path = mr.position;
            end
        end %calculate_path
        
        
        function mr = move(mr, steps)
            mr.prev_position = [mr.prev_position mr.position];
            steps = min(round(mr.velocity*steps), length(mr.path(1,:))); % luis 
            if steps > 0
              mr.position = mr.path(:,steps);   %luis
            end  
            mr.path_done = [mr.path_done mr.position];
            
            path=mr.path(:,steps+1:end);
            [nfp,ncp]=size(path);
            if nfp==3 && ncp>1
               mr.path = path;
            else % no hay path
               mr.path = mr.position;
            end      
        end %move    
        
        
        function mr = moveAt(mr, pos)
            mr.prev_position = [mr.prev_position mr.position];
            mr.position = pos;
        end %move
       
            
        function plotLeader(mr, aux)   
            %For some extrange reason, the map is drawn with the axis
            %X and Y changed.
            if nargin > 1
            	plot3(mr.position(2), mr.position(1), mr.position(3), aux, 'LineWidth', 2);
            else
%                 text(mr.end_point(2), mr.end_point(1), mr.end_point(3), num2str(mr.numID));
%                 plot3(mr.end_point(2), mr.end_point(1), mr.end_point(3), 'y.', 'LineWidth', 2); % 'ro'         
                plot3(mr.position(2), mr.position(1), mr.position(3), 'r.', 'LineWidth', 2);  % 'gd'

%                 if ~isempty(mr.path)
%                     plot3(mr.path(2,:),mr.path(1,:),mr.path(3,:), 'b-', 'LineWidth', 1);
%                 end
                if ~isempty(mr.path_done)
                    plot3(mr.path_done(2,:),mr.path_done(1,:),mr.path_done(3,:), 'r-', 'LineWidth', 2);
                end
            end %else
        end %plot
        
        
    end %functions
end % Class