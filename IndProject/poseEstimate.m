function poseEstimate( filename )

% Function to plot the AR.Drone 2.0 x,y,z position in inertial frame using 
% Body velocity measurements
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

% Time (seconds)    Use stopwatch elapsed time or timestamp?
time = (M(:,1))/1000;

% Yaw Angle (Radians)
psi = M(:,4);

% Pitch Angle (Radians)
theta = M(:,3);

% Roll Angle (Radians)
phi = M(:,2);

eul = [psi theta phi];

% Body Frame Velocities (m/s)
u = M(:,5);
v = M(:,6);
w = M(:,7);

% Altitude (m)
alt = M(:,11)/100;

% Write velocities to a vector with three rows
velb = [u v w]';

% Position in inertial frame
pos = zeros(size(eul));

% Velocity in inertial frame (vector with three rows)
velin = zeros(size(eul))';

%% Co-ordinate frame conversion
% Convert Euler Angles to 3x3 Rotation Matrix
for t = 1:length(time)
    RotZYX = [cos(theta(t))*cos(psi(t)) sin(phi(t))*sin(theta(t))*cos(psi(t))-cos(phi(t))*sin(psi(t)) ... 
          cos(phi(t))*sin(theta(t))*cos(psi(t))+sin(phi(t))*sin(psi(t));
          cos(theta(t))*sin(psi(t)) sin(phi(t))*sin(theta(t))*sin(psi(t)) + cos(phi(t))*cos(psi(t)) ...
          cos(phi(t))*sin(theta(t))*sin(psi(t)) - sin(phi(t))*cos(psi(t));
          -sin(theta(t)) sin(phi(t))*cos(theta(t)) cos(phi(t))*cos(theta(t))];
      
    % Calculate velocities in the inertial frame (3x1 vector)
      velin(:,t) = RotZYX*velb(:,t);
end

%% Position Calculation

% Transpose to a vector of 3 columns for ease of calculation and formatting
velin = (velin)';

for t = 2:length(time)
    pos(t,:) = pos(t-1,:) + velin (t-1,:) * (time(t) - time(t-1));
end

%% Body Orientation Plot
psi_d = psi*(180/pi);
theta_d = theta*(180/pi);
phi_d = phi*(180/pi);
figure
hold on
yyaxis left
plot(time,psi_d,'-k')
plot(time,theta_d,'-')
plot(time,phi_d,'-g')
xlabel('Time(s)')
ylabel('Attitude (degrees)')
yyaxis right
plot(time,alt,'-')
ylabel('Altitude(m)')
legend('Yaw(deg)', 'Pitch(deg)', 'Roll(deg)', 'Altitude(m)')
grid minor
title('Plot of AR.Drone Attitude and Altitude')
hold off
%%
% %%  XY pos plot
% figure;
% plot(pos(:,2), pos(:,1))
% xlabel('Y Position(m)');
% ylabel('X Position(m)');

%%
% %% 3D Plot
% figure;
% stem3(pos(:,1), pos(:,2), pos(:,3),'Marker','x','MarkerEdgeColor','k');
% xlabel('X Position(m)');
% ylabel('Y Position(m)');
% zlabel('Z Position(m)');
% title('3D Position Plot over a 20 Second Period')
% view(82,30);