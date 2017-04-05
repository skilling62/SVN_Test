function poseEstimate( M )

% Function to plot the AR.Drone 2.0 x,y,z position in inertial frame using 
% Body velocity measurements
clc

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
alt = M(:,11);
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
t = 2;
while t <=length(time)
    pos(t,1:2) = pos(t-1,1:2) + velin (t,1:2) * (time(t) - time(t-1));
    pos(t,3) = M(t,11);
    t = t + 1;
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
xlabel('Time(s)','FontSize',20)
ylabel('Attitude (degrees)','FontSize',20)
yyaxis right
plot(time,alt,'-')
ylabel('Altitude(m)','FontSize',20)
legend({'Yaw(deg)', 'Pitch(deg)', 'Roll(deg)', 'Altitude(m)'},'FontSize',20)
grid minor
title('Drone Attitude and Altitude Over a Short Flight','FontSize',20)
hold off

%% 3D Plot
% Skip entries in the pos array for ease of visualisation
pos_ = pos(1:25:length(pos),:);
figure;
stem3(pos_(:,1), pos_(:,2), pos_(:,3),'Marker','x','MarkerEdgeColor','k');
xlabel('X Position(m)');
ylabel('Y Position(m)');
zlabel('Z Position(m)');
title('3D Position Plot')
set(gca,'YDir','Reverse')