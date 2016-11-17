function SPeriod_Func(MethodNumber)

clc
%%global U_0 Q m S Rho CD_0 I_y

addpath .\Cranfield_Flight_Test_Data;

kts2ms = 0.51444; % kts to m/s 1 = 0.51444

%% Import data
SpData = xlsread('SPPO_GpA.xls');

% Assign variables to columns
time = SpData(:,1);
ElvAngle = SpData(:,2);
% Angle of attack - a principal value for short period
Alpha = SpData(:,3);
% Pitch = theta
Pitch = SpData(:,4);
% Pitch rate = q. A principal value for short period
PitchRate = SpData(:,5);
% Initial Velocity
u0 = SpData(1,7) * kts2ms;
% Initial Altitude
alt0 = SpData(1,8);

%% Plot angle of attack vs speed to determine response
[pk,lc] = findpeaks(PitchRate,time,'MinPeakDistance',1.8);
[troughs, lc1] = findpeaks(-PitchRate,time,'MinPeakDistance',1.8);
troughs = -troughs;
plot(time,ElvAngle, 'b', 'DisplayName', 'Elevator Deflection Angle (Degrees)')
grid on
hold on
plot(lc, pk, 'mo', lc1, troughs, 'ko','HandleVisibility','off');
plot(time,PitchRate, 'g','DisplayName', 'Pitch Rate')
ax.XTickLabelMode = 'auto';
hold off
legend(gca,'show')
set(legend,'FontSize',14)
xlabel ('Time (Seconds)','FontSize', 14)
ylabel('State Variable','FontSize',14)


%% Analyse the plot

switch MethodNumber
    case 0
%% Determine the Damping Ratio and Natural Frequency By Inspection
% Omit the trough at t = 0 in the group A plot
if lc1(1) < 0.5
   t1 = lc1(4);
   t2 = lc1(5);
   t3 = lc1(6) - 0.5;
   y1 = troughs(4);
else
    t1 = lc1(3);
    t2 = lc1(4);
    t3 = lc1(5) - 0.5;
    y1 = troughs(3);
end

% Calculate the time period
TPeriod = t2-t1;

% Calculate the damped natural frequency
Omeg_d = (2*pi/TPeriod);

%% Rescale the plot

% New time Vector whose domain is scaled down
time_ = time(time>=t1 & time<t3)-t1;

% Determine the index of the starting point in the original time vector
index = length(time) - length(time(time>=t1)) + 1;

% Find the end position in the original pitch vector
Pfindex = (index + length(time_)) -1 ;

% New Pitch Rate vector
PitchRate_ = PitchRate(index:Pfindex) + abs(y1);

% Determine the steady state value of the rescaled PitchRate vector 
y_ss = PitchRate_(length(PitchRate_));

%% Plot the rescaled response and Standard Second Order Responses
plot(time_,PitchRate_,'k', 'LineWidth',1.5,'DisplayName','System Response') 
grid minor

hold all
for zeta = 0:0.1:1
    % Use a range of Natural frequencies
    OmegaN = (Omeg_d/sqrt(1 - zeta^2));
    y = y_ss*(1-exp(-zeta * OmegaN.*time_).*((zeta * (OmegaN/Omeg_d) * sin(Omeg_d.*time_)) + cos(Omeg_d.*time_)));
    plot(time_,y, 'DisplayName',num2str(zeta));
end
legend(gca,'show')
ylabel('PitchRate (degrees/s)')
xlabel('Time (s)')

hold off
% Manually input a value of zeta 
zeta_ = 0.5;
Omeg_n = (Omeg_d/sqrt(1-zeta_^2));

    case 1
%% Use the logarithmic decrement Method
   
if lc1(1) < 0.5
   r1 = pk(4);
   r2 = troughs(5);
   r3 = pk(5);
   t3 = lc(5);
   t1 = lc(4);
else 
    r1 = pk(4)
    r2 = troughs(4)
    r3 = pk(5)
    t3 = lc(5)
    t1 = lc(4)
end

r3-r2
r2-r1
% Calculation of the logarithmic decrement
lil_delta = -log((r3 - r2)/(r2 - r1));

% Calculation of damping ratio
zeta_ = lil_delta / (sqrt((pi^2) + (lil_delta^2)))

% % Calculation of Damped natural frequency
% Omeg_d = 2*(pi)/ (t3 - t1)
% 
% % Calculation of Natural Frequency
% Omeg_n = zeta_ / (sqrt(1 - (zeta_^2)))
end

%disp(Omeg_n)

%% Calculations
% From the natural frequency, the aim is to calculate Mq, for this Malpha, Z alpha and u0 are needed

load('JetStream.mat','m','CL_Aw','S_w','Cbar','CD_0w','m','I_y','CM_Aw')

% Calculate the density at test conditions
Rho = Dens_Calc(358,alt0,18,1012);

% Calculate Dynamic Pressure
Q = 0.5*Rho*(u0^2);

% Calculate Zw and Zalpha

Zw = -(CL_Aw + CD_0w)*Q*S_w/(u0*m);
Zalpha = u0*Zw;

% Calculate Mw and Malpha

Mw = (CM_Aw * Q * S_w * Cbar)/(u0 * I_y);
Malpha = u0*Mw;

% Calculate Mq

%Mq = (u0*(Omeg_n^2 * Malpha))/zalpha

% 
% Cm_q = 1; %!!!!!!CHANGE!!!!!!!!!!!!
% 
% Malphadot = 1; %!!!!!!CHANGE!!!!!!!!!!!!
% 
%  M_w = (Cmalpha * Q * S * cbar) / (U_0 * I_y);
%  Z_w = -(((Clalpha + CD_0 ) * (Q * S) ) / (U_0 * m));
%  Malpha = U_0 * M_w;
%  Zalpha = U_0 * Z_w;
%  M_q = (Cm_q * ((cbar / 2) * U_0) * Q * S * cbar) / (U_0 * I_y);
%  
%  Omeg_nsp = sqrt((Zalpha * M_q / U_0) - Malpha);
%  Zeta_sp = -((M_q + Malphadot + (Zalpha / U_0))/(2 * Omeg_nsp));
  
end

