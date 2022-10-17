% 3D Multirobot formation fast marching path planning
% The point here is that the formation changes it shape depending on the
% change of the gray level.
%% Initializing, loading the map and creating the first potential with FM.
clear all;
close all;

% solo se representa cada 10 veces
% it is only represented 10 times
steps = 4; %4;
total_steps = [];

sat = 0.99; %0.99;

iteration = 0;

%% Map generation
Wo=zeros(30,30,10);
[nn mm ll]=size(Wo); 

%%Plot ciudad  ----------------------------------------------------
% dibujo transparente simple
% figure(1)
% axis vis3d;
% view(3);

% Obstaculos para cerrar el espacio
% obstacles is to close to space
Wo(1,:,:)=1;
Wo(nn,:,:)=1;
Wo(:,1,:)=1;
Wo(:,mm,:)=1;
Wo(:,:,1)=1;
Wo(:,:,ll)=1;


% Obstaculos a superar
% edificios de la ciudad y dibujo

%building of the city and drawing 

%
            Wo(3:5,3:6,1:6)=1; 
            Wo(12:15,3:6,1:8)=1; 
            Wo(22:26,3:6,1:5)=1; 
            
            Wo(3:6,12:16,1:8)=1; 
            Wo(15:18,12:16,1:7)=1;  
%                Wo(10:12,12:16,1:4)=1;    
            Wo(23:26,12:16,1:8)=1;  
            
            Wo(3:5,22:26,1:6)=1; 
            Wo(9:12,22:26,1:8)=1; 
            Wo(18:20,22:26,1:5)=1; 
              Wo(25:27,22:26,1:7)=1; 
%             

           
     






%-----------------------------------------------------------------
W1=ones(nn, mm ,ll);

% Refraccion -> velocidad
W=bwdist(Wo);

   
tic
% ----------------------------------------
% Plot ciudad
% draw the city
map=Wo;
[nn mm ll]=size(map);
% Woo=map(2:nn-1,2:mm-1,1:ll-1);
% F = isosurface(Wo, 0.5 );
% p = patch(F);
% isonormals( Wo,p ); 
% % plot_map3d(Woo, 0.1, 1);
% hold on;

figure(1)
isosurface(Wo(2:nn-1,2:mm-1,1:ll-1),0.5) % para quitar techo y paredes % for remove the roof and walls
daspect([1 1 1])
view(3);
axis tight
camlight ('left')
lighting gouraud
hold on;

% -----------------------------------------
toc


%% Creating leader robot and finding the leader's path.
   start_point2 =[6;2;2];
     end_points2 =[26;27;4];
%         end_points2 =[6;27;4];
options.nb_iter_max = Inf;
options.Tmax = sum(size(W));
% options.end_points=end_points2;
% 




%%----------------------
%% Refraccion --> energia
M=0.5;

Es=0.10; % nivel de agresividad en el nivel, cuanto menor Es menor es la agresividad
         % the level of the aggressiveness level . 
% ref navigational level low
zref=10;

for k=1:ll
    krel=((abs(zref-k))*0.005+0.01)^Es;
    We10(1:nn,1:mm,k)=1/(M*krel);
end
Wt= W.*We10;

Wt = rescale(double(Wt));
Wt = min (Wt, sat);


% r(1) = Mobile_Robot3D(start_point, Wt,Wo);
% tic
% r(1) = r(1).findPath(end_points, options);
% toc
% r(1).plotLeader();

r(1) = Mobile_Robot3D(start_point2 , Wt,Wo);
tic
r(1) = r(1).findPath(end_points2, options);
toc
r(1).plotLeader();     
normalized_mat1 = r(1).path;
% normalized_mat2 = r(2).path;

 main_path=normalisation(main_path,100);
%  c =normalisation(r(2).path,100);
%  nor_UAVfol2 = c;
%  cor_fol1 =load('Aı_test_path.mat');
%  cor_fol1 = cor_fol1.b  ;

cor_fol1 =a;
  Distance_matrix= rand(100,1);
            for i=1:1:100
               Distance_matrix(i,1) =sqrt((nor_UAVfol2(1,i)-cor_fol1(1,i))^2 + (nor_UAVfol2(2,i)-cor_fol1(2,i))^2 + (nor_UAVfol2(3,i)-cor_fol1(3,i))^2);
        
            end

 
 


