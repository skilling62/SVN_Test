function SPeriod_Func()

clc
%%global U_0 Q m S Rho CD_0 I_y

addpath .\Cranfield_Flight_Test_Data;

%% Import data
SpData = xlsread('SPPO_GpB.xls');

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
[pk,lc] = findpeaks(PitchRate,time,'MinPeakDistance',1.8);
[troughs, lc1] = findpeaks(-PitchRate,time,'MinPeakDistance',1.8);
troughs = -troughs;
plot(time,ElvAngle, 'b', 'DisplayName', 'Elevator Angle (Degrees)')
grid on
hold on
plot(time,PitchRate, 'g',lc, pk, 'mo', lc1, troughs, 'ko', 'DisplayName', 'Pitch Rate (Degrees/s)');
ax.XTickLabelMode = 'auto';
legend(gca,'show')
hold off
xlabel ('Time (Seconds)')
%% Analyse the plot

% Damped natural frequency calculation

% Omit the trough at t = 0 in the group A plot
if lc1(1) < 0.5
   t1 = lc1(6);
   t2 = lc1(7);
   y1 = troughs(6);
else
    t1 = lc1(5);
    t2 = lc1(6);
    y1 = troughs(5);
end

% Calculate the time period
TPeriod = t2-t1;

% Calculate the damped natural frequency
Omeg_d = (2*pi/TPeriod)

%% Rescale the plot

time_ = time(time>=t1)-t1;


disp(length(time_));

index = length(time) - length(time_) + 1;

time(index);
PitchRate(index);

PitchRate_ = PitchRate((index):length(PitchRate))+abs(y1);

disp(length(PitchRate_));

% Determine the steady state value of the rescaled PitchRate vector 
y_ss = PitchRate_(length(PitchRate_));

%% Plot the rescaled response
%plot(time_,PitchRate_, 'LineWidth',1.5) 
grid minor

%%
OmegaN = 4;
hold all
for zeta = 0:0.1:1
y = y_ss*(1-exp(-zeta * OmegaN.*time_).*((zeta * (OmegaN/Omeg_d) * sin(Omeg_d.*time_)) + cos(Omeg_d.*time_)));
%plot(time_,y, 'DisplayName',num2str(zeta));
end
legend(gca,'show')
%ylabel('PitchRate')

%% Can use the logarithmic decrement to get Damping ratio


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

