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
tolerance = 0.005;
frame = 1;
t = 2;
while t <=length(time)
    pos(t,:) = pos(t-1,:) + velin (t-1,:) * (time(t) - time(t-1));
    
    if abs(time(t) - s(frame).timestamp) <= tolerance
        % pos(t,:) = mapSURF(pos(t,:),psi(t),theta(t),phi(t))
        frame = frame + 1;
    end
    t = t + 1;
end

%% Testing Section
i = 2:200;
deltaT = zeros(length(i),1);

for k = i
    deltaT(k-1) = abs(time(k) - s(frame).timestamp);
    if abs(deltaT(k-1))<=tolerance
        frame = frame + 1;
    end
end

figure
plot(i,deltaT)
hold on
toleranceVector = linspace(tolerance, tolerance, length(i));
plot(i,toleranceVector,'k')
grid minor
hold off

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
figure;
stem3(pos(:,1), pos(:,2), pos(:,3),'Marker','x','MarkerEdgeColor','k');
xlabel('X Position(m)');
ylabel('Y Position(m)');
zlabel('Z Position(m)');
title('3D Position Plot')
view(82,30);