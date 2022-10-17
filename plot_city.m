function [drawing] = plot_city(Wo)

% Refraccion -> velocidad
W=bwdist(Wo);


tic
% ----------------------------------------
% Plot ciudad
% draw the city
map=Wo;

[nn mm ll]=size(map);
W1=ones(nn, mm ,ll);
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
