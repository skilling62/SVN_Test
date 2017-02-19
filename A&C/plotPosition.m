function plotPosition( filename )

% Function to plot the AR.Drone x,y,z position (in body frame) based on integration of accelerometer readings
clc
%% Create an Array containing the odometry data

% Import Data
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
time = time/1000;

% Body Frame Accelerations
accX = M(:,8);
accY = M(:,9);
accZ = M(:,10);

acc = [accX accY accZ];

% Convert to SI units (m/s^2)
acc = (acc/1000) * 9.81;

% Body Frame Velocities
vel = zeros(size(acc));

% Body Frame Position
pos = zeros(size(vel));

%% Calculate translational velocity

% Remove gravity from the z axis accelerometer reading
acc(:,3) = acc(:,3) + 9.81;

% Integrate Acceleration to provide body fixed velocity
for t = 2:length(time)
  vel(t,:) = vel(t-1,:) + acc(t-1,:) * (time(t)-time(t-1));
end

%% Calculate position
for t = 2:length(time)
    pos(t,:) = pos(t-1,:) + vel(t,:) * (time(t) - time(t-1));
end

%% Plot translational velocity
% plot(time,vel(:,1))
% hold on
% plot(time,vel(:,2))
% plot(time,vel(:,3))
% grid minor
% xlabel('Time(s)')
% ylabel('Velocity(m/s)')
% legend ('x', 'y', 'z')
% title('Body Frame Velocity Plot')
% hold off

%% Plot position
figure('Position', [9 39 900 600]);
hold on
plot(time, pos(:,1), 'r');
plot(time, pos(:,2), 'g');
plot(time, pos(:,3), 'b');
title('Position Error over a 20 Second Period');
xlabel('Time (s)');
ylabel('Position (m)');
legend('X', 'Y', 'Z');
grid minor
hold off;

%% 3D Plot
figure;
stem3(pos(:,1), pos(:,2), pos(:,3),'Marker','x','MarkerEdgeColor','k');
xlabel('X Position(m)');
ylabel('Y Position(m)');
zlabel('Z Position(m)');
title('3D Position Plot over a 20 Second Period')
view(82,30);
    

