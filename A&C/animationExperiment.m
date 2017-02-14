function [] = animationExperiment()
clc

x = (0:1000)';
y = (10:1010)';
z = (-1000:0)';

h = animatedline('Color','r','Linestyle','none','Marker','.','MarkerSize',3);

axis([0 1000 10 1010 -1000 0])

v = [x y z];

for k = 1:length(x)
    addpoints(h,v(k,1),v(k,2),v(k,3))
    drawnow
end 

end



