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
    tloga1 = locs(14);
    tloga3 = locs (15);
    r1 = pk(14);
    r2 = troughs(14);
    r3 = pk(15)
    t2 = lc1(14);
    y1 = troughs(13);
elseif GroupName == 2
    t1 = lc1(7);
    tloga1 = locs(8);
    tloga3 = locs(9);
    r1 = pk(8);
    r2 = troughs(7);
    r3 = pk(9);
    t2 = lc1(8);
    y1 = troughs(7);
end

%% Logarithmic Decrement
% Calculation of the logarithmic decrement
lil_delta = -log(abs((r3 - r2)/(r2 - r1)));

% Calculation of damping ratio
zeta_ = lil_delta / (sqrt((pi^2) + (lil_delta^2)))

% Calculation of Damped natural frequency
Omeg_dloga = 2*(pi)/ (tloga3 - tloga1);

% Calculation of Natural Frequency
Omeg_nloga = Omeg_dloga / (sqrt(1 - (zeta_^2)));

%% Inspection Method
% Calculate the time period
TPeriod = t2-t1;

% Calculate the damped natural frequency
Omeg_d = (2*pi/TPeriod);

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

% Plot the rescaled response and standard second order responses
subplot(2,1,2)
plot(time_,r_,'k', 'LineWidth',1.5,'DisplayName','System Response') 
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


%% Determine the stability Coefficients, zeta and omega from aircraft parameters

load('JetStream' , 'U_0', 'S_v', 'S_w', 'b_w', 'b_v', 'V_v', 'l_v', ...
    'm', 'I_z', 'CL_Av', 'C_nBeta_wt', 'EffFac_V', 'EffFac_W', ...
    'dSigmaBYdBeta', 'K_n', 'K_Rl', 'Sf', 'lf')

Rho = Dens_Calc(358,DR_data(1,5),18,1012);

Q = 0.5 * Rho * (U_0)^2;

C_yr = 2 * CL_Av * EffFac_V *((S_v / S_w) * (l_v / b_w));

C_nr = -2 * EffFac_V * V_v * (l_v / b_w) * CL_Av;

C_yBeta = -EffFac_W * (S_v / S_w) * CL_Av * (1 + dSigmaBYdBeta);

C_nBeta_wt = -(K_n) * K_Rl * ((Sf * lf)/(S_w * b_w));

C_nBeta = C_nBeta_wt + (EffFac_V * V_v * CL_Av * (1 + dSigmaBYdBeta));

%% Calculations
% Nelson p199

Y_Beta = (Q * S_w * C_yBeta) / m

N_Beta = (C_nBeta * Q * S_w) / I_z

Y_r = (Q * S_w * b_w * C_yr) / (2 * m * U_0)

N_r = (Q * S_w * (b_w^2) * C_nr) / (2 * I_z * U_0)

% Y_Beta = -45.72
% Y_r = 0
% N_Beta = 4.49
% N_r = -0.76
% U_0 = 176

Omeg_nDR = sqrt(((Y_Beta * N_r) - (N_Beta * Y_r) + (U_0 * N_Beta)) / U_0)
Zeta_DR = -(1 / (2 * Omeg_nDR)) * ((Y_Beta + (U_0 * N_r)) / U_0);
end