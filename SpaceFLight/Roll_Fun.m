function [L_Sig_Al] = Roll_Fun()

clc

% global S_w b_w I_z CL_Aw g W Y1 Y2 Cr Lan

addpath .\Cranfield_Flight_Test_Data;

%% Import the Data (Time vector and roll rate) and plot
% Import Data
Roll_data = xlsread('Roll_GpA.xls');
time = Roll_data(:,1);
p = Roll_data(:,4);
delta_a = Roll_data(:,2);
phi = Roll_data(:,3);
GroupName = Roll_data(1,8);

% Plot
subplot(2,1,1)
plot(time,p,'DisplayName','Pitch Rate (Degrees/s)')
[pk,locs] = findpeaks(p,time,'MinPeakDistance',1.8);
[troughs, lc1] = findpeaks(-p,time,'MinPeakDistance',1.5);
troughs = -troughs;
hold on
plot(locs,pk,'mo',lc1, troughs, 'ko','HandleVisibility','off')
plot (time, delta_a,'DisplayName','Aileron Deflection Angle (Degrees)');
grid minor
xlabel('Time (Seconds)')
ylabel('State Variable')
legend(gca,'show')
hold off
%% Determine the TIme Constant

% Rescale the plot
t1 = lc1(3);
t2 = lc1(4);
y1 = troughs(3);
time_ = time(time>=t1 & time<t2)-t1;
index = length(time) - length(time(time>=t1)) + 1;
pfindex = (index + length(time_)) -1 ;
RollRate_ = p(index:pfindex) - abs(y1);

% Find the steady state
if GroupName == 1
    p_ss = pk(4) - abs(y1);
elseif GroupName == 2
    p_ss = pk(3) - abs(y1);
end

% Find 63.2% of the final value
t_ss = 0.632*p_ss;
Vp_ss = linspace(p_ss,p_ss,length(time_));
Vt_ss = linspace(t_ss,t_ss,length(time_));

subplot(2,1,2)
plot(time_,RollRate_)
hold on
plot(time_,Vp_ss)
plot(time_,Vt_ss,'--k')
hold off


    
% Rho = Dens_Calc(358,Roll_data(1,5),18,1012);
% 
%     U_0 = Initial_Speed();
% 
%     Q = 0.5 * Rho * (U_0)^2;
%     
%% Equations

%     T_Con = 2 * (W / S_w)/ (CL_Aw * Rho * U_0 * g); % Time Constant
% 
%     CL_Sig_Al = ((2 * CL_Aw * T_Con * Cr) / (S_w * b_w)) ...
%         * (((Y2/2)^2 + ((Lan - 1)/(b_w / 2))*(Y2/3)^3)) - (((Y1/2)^2 ...
%         + ((Lan - 1)/(b_w / 2))*(Y1/3)^3));
%    
%     L_Sig_Al = (Q * S_w * b_w * CL_Sig_Al) / I_z
%     
%     CL_p = 1;
%     
%     L_p = 1;
% 
% 







end