function [M] = plotPosition( filename )

clc

% Function to plot the AR.Drone x,y,z position based on accelerometer readings

%% Create an Array containing the odometry data
% Import Array
addpath  .\Odometry_CSVs;
M = csvread(filename, 1);

% Adjust array so that there is only one instance of t = 0 (initial
% conditions). Arbitrary variable rem
rem = M(:,1);

for j = 5:-1:2
    initSum = rem(j) + rem(j-1);
    if initSum == 0
        index = j;
    end
end
M = M(index:size(M,1),:);

%% Declare Variables

% Time 
time = M(:,1);

% Position (to be calculated)
S = [x y z];

end

