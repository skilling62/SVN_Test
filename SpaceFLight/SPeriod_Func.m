function SPeriod_Func()

clc
%%global U_0 Q m S Rho CD_0 I_y

addpath .\Cranfield_Flight_Test_Data;

%% Import data
SpData = xlsread('SPPO_GpA.xls');

% Density Calculation

% Assign variables to columns
time = SpData(:,1);
ElvAngle = SpData(:,2);
% Angle of attack - a principal value for short period
Alpha = SpData(:,3);
% Pitch = theta
Pitch = SpData(:,4);
% Pitch rate = q. A principal value for short period
PitchRate = SpData(:,5);

%% Plot angle of attack vs speed to determine response
plot(time, PitchRate)
grid minor
[pk,lc] = findpeaks(PitchRate,time,'MinPeakDistance',1.8);
[troughs, lc1] = findpeaks(-PitchRate,time,'MinPeakDistance',2.0);
troughs = -troughs;
plot(time,PitchRate, 'g',lc, pk, 'mo', lc1, troughs, 'ko');
ax.XTickLabelMode = 'auto';
grid minor;

%% Analyse the plot

% Damped natural frequency calculation (Inspection of troughs 3 and 4)

% Omit the trough at t = 0 in the group A plot
if lc1(1) < 0.5
   t1 = lc1(4);
   t2 = lc1(5);
else
    t1 = lc1(3);
    t2 = lc1(4);
end

% Calculate the time period
TPeriod = t2-t1;

% Calculate the damped natural frequency
Omeg_d = (2*pi/TPeriod)

%% Calculations
 
% Pg_data = xlsread('Phugoid_GpA.xls');
%  
% Dens_Calc(358,Pg_data(1,5),18,1012)
% 
% Q = 0.5 * Rho * (U_0)^2;
% 
% 
% cbar = 1.717;
% 
% Cmalpha = 1; %!!!!!!CHANGE!!!!!!!!!!!!
% 
% Clalpha = -0.1715; %!!!!!!CHANGE!!!!!!!!!!!!
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

