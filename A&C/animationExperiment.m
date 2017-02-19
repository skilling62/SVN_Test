function [] = animationExperiment()
clc

x = (0:1000)';
y = (10:1010)';
z = (-1000:0)';

h = animatedline('Color','r','Linestyle','none','Marker','.','MarkerSize',3);

axis([0 1000 10 1010 -1000 0])

v = [x y z];

% for k = 1:length(x)
%     addpoints(h,v(k,1),v(k,2),v(k,3))
%     drawnow
% end 

j = linspace(0,4*pi,100); 
axis tight
set(gca,'nextplot','replacechildren');
% Record the movie
for k = 1:20 
    plot(sin(2*pi*j/20))
    F(k) = getframe;
end
% Play the movie twenty times
movie(F,20) 

end



