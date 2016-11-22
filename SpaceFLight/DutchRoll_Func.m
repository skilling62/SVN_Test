function DutchRoll_Func()
 
clc

addpath .\Cranfield_Flight_Test_Data;

%% Determine the Damping Ratio and Natural Frequency from the response

% Import Data
DR_data = xlsread('Dutch-Roll_GpB.xls');
time = DR_data(:,1);
delta_rudder = DR_data(:,2);
r = DR_data(:,4);
GroupName = DR_data(1,10);

% Plot Roll Rate Response
subplot(2,1,1)
plot(time,r,'DisplayName','Yaw Rate (Degrees/s)')
[pk,locs] = findpeaks(r,time,'MinPeakDistance',2.5);
[troughs, lc1] = findpeaks(-r,time,'MinPeakDistance',2.5);
troughs = -troughs;
hold on
plot(locs,pk,'mo',lc1, troughs, 'ko','HandleVisibility','off')
plot (time, delta_rudder,'DisplayName','Rudder Deflection Angle (Degrees)');
grid minor
axis tight
xlabel('Time (Seconds)')
ylabel('State Variable')
legend(gca,'show')
hold off

% Rescale the response
if GroupName == 1
    t1 = lc1(13);
    t2 = lc1(14);
    y1 = troughs(13);
elseif GroupName == 2
    t1 = lc1(7);
    t2 = lc1(8);
    y1 = troughs(7);
end

% New time Vector whose domain is scaled down
time_ = time(time>=t1)-t1;

% Determine the index of the starting point in the original time vector
index = length(time) - length(time(time>=t1)) + 1;

% Find the end position in the original pitch vector
Pfindex = (index + length(time_)) -1 ;

% New Pitch Rate vector
r_ = r(index:Pfindex) + abs(y1);

% Determine the steady state value of the rescaled PitchRate vector 
y_ss = r_(length(r_));

% Plot the rescaled response
subplot(2,1,2)
plot(time_,r_,'k', 'LineWidth',1.5,'DisplayName','System Response') 
grid minor





%% Determine the stability Coefficients, zeta and omega from aircraft parameters

load('JetStream' , 'U_0', 'S_v', 'S_w', 'b_w', 'b_v', 'V_v', 'l_v', ...
    'm', 'I_z', 'CL_Av', 'C_nBeta_wt', 'EffFac_V', 'dSigmaBYdBeta')

Rho = Dens_Calc(358,DR_data(1,5),18,1012);

Q = 0.5 * Rho * (U_0)^2;

C_yBetaTail = CL_Av * EffFac_V * (S_v / S_w);

C_yr = -2 * (-C_yBetaTail) * (l_v / b_v);

C_nr = -2 * EffFac_V * V_v * (l_v / b_v) * CL_Av;

C_yBeta = -EffFac_V * (S_v / S_w) * CL_Av * (1 + dSigmaBYdBeta);

C_nBeta = C_nBeta_wt + (EffFac_V * V_v * CL_Av * (1 + dSigmaBYdBeta));

%% Calculations

Y_Beta = (Q * S_w * C_yBeta) / m;

N_Beta = (C_nBeta * Q * S_w) / I_z;

Y_r = (Q * S_w * b_w * C_yr) / (2 * m * U_0);

N_r = (Q * S_w * (b_w^2) * C_nr) / (2 * I_z * U_0);

Omeg_nDR = sqrt(((Y_Beta * N_r) - (N_Beta * Y_r) + (U_0 * N_Beta)) / U_0);
Zeta_DR = -(1 / (2 * Omeg_nDR)) * ((Y_Beta + (U_0 * N_r)) / U_0); 
end