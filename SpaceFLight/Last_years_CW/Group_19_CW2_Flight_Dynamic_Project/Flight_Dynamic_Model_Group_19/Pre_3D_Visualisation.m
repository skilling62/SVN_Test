% This script pre loads and scales the aircraft code before the simulink
% applicaiton begins

opengl hardware
load 83plane;

scale_factor = 0.01;

V=[-V(:,2) V(:,1) V(:,3)];
V(:,1)=V(:,1)-round(sum(V(:,1))/size(V,1));
V(:,2)=V(:,2)-round(sum(V(:,2))/size(V,1));
V(:,3)=V(:,3)-round(sum(V(:,3))/size(V,1));

correction=max(abs(V(:,1)));
V=V./(scale_factor*correction);

H = figure(1)
% hold on
xlabel('X');
ylabel('Y');
zlabel('Z');
view(0, 0);
% view(-37.5, 30);
lighting phong;
grid on;
axis([0 4500 -1 1 200 700])
axis equal