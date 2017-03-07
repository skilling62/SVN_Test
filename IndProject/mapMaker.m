close all;
clearvars;
clc;
%% Create empty map
x = -10:0.1:10;
y = x;
axis([min(x) max(x) min(x) max(x)]);
axis square;
set(gca, 'XTick', (-10:10), 'YTick', (-10:10));
grid on;
title('Feature Map')
xlabel('x coordinates (m)')
ylabel('y coordinates (m)')
hold on

%% Convert World Units to map units (cell sixe = 0.1m)
pos = [8.4225 2.367; 3.214 4.537; 0.514, 8.223];
descriptor = [4 9; 1.2 5; 7.3 6];
posMap = round(pos,1);

%% Create a Features struct that contains the features and their descriptors
features = struct ('mPos', zeros(length(x),length(x),3));
% Get the index of a feature point
for k = 1:size(pos,1)
    xIndex = find(abs(x - posMap(k,1)) < 0.001);
    yIndex = find(abs(y - posMap(k,2)) < 0.001);
% Add it to the empty feature matrix along with it's descriptor and plot
    if features.mPos(yIndex,xIndex,1) == 0
       features.mPos(yIndex,xIndex,:) = [1 descriptor(k,:)];
       scatter (pos(k,1),pos(k,2),'x','k')
    end
end

