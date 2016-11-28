 function [Nv, Lv, Lr, Nr, Yp, Np] = Spiral_Func()

clc

addpath .\Cranfield_Flight_Test_Data

%% Load relevant variables from the .mat file
load('JetStream', 'EffFac_V', 'S_v', 'V_v', 'CL_Av', 'dSigmaBYdBeta', ...
    'S_w', 'b_w', 'I_z', 'S_w', 'b_w', 'I_x', 'I_z', 'l_v', 'U_0', ...
    'CL_Av', 'S_w', 'Gamma', 'CL_BetaByGam', 'CL_0w', 'K_n', 'K_Rl', 'Sf', ...
    'lf', 'Swept_Angle', 'AR_w', 'm', 'z_u')

%% Import Data 
Spiral_Data = xlsread('Spiral_GpA.xls');
time = Spiral_Data(:,1);
phi = Spiral_Data(:,2);
aileron = Spiral_Data(:,5);

%% Plot data
plot(time,phi,'DisplayName', 'Bank Angle (Degrees)')
hold on
plot(time,aileron,'DisplayName', 'Aileron Deflection Angle (Degrees)')
grid minor
hold off
xlabel('Time (Seconds)')
ylabel('State Variable')
legend(gca,'show')
%%
Rho = Dens_Calc(358,Spiral_Data(1,3),18,1012);

Q = 0.5 * Rho * (U_0^2);

% Calculate Wing fuesulage contribution to CnBeta (p75)
C_nBeta_wf = -(K_n) * K_Rl * ((Sf * lf)/(S_w * b_w));

% Calculate Nbeta abd Nv
C_nBeta = C_nBeta_wf + (EffFac_V * V_v * CL_Av * (1 + dSigmaBYdBeta));

NBeta = (Q * S_w * b_w * C_nBeta) / I_z

Nv = NBeta/U_0;

% Calculate CL_Beta Used graph to find CL_Beta. L_Beta is the dihedral
% effect p122
CL_Beta = (CL_BetaByGam * Gamma) - 0.0002; 

LBeta = (Q * S_w * b_w * CL_Beta) / I_x;

Lv = LBeta/U_0;

% Calculate Lr (the roll moment due to yaw rate)
C_yBeta_tail = - (CL_Av * EffFac_V * (S_v / S_w));

CL_r = (CL_0w / 4) - (2 * (l_v/b_w) * (z_u/b_w) * C_yBeta_tail);

Lr = (Q * S_w * (b_w^2) * CL_r) / (2 * I_x * U_0);

% N_r is the yaw rate damping
C_nr = -(2 * EffFac_V * V_v * (l_v/b_w) * CL_Av);

Nr = (Q * S_w * (b_w^2) * C_nr) / (2 * I_x * U_0);

% Caclulate Yp

C_yp = CL_0w * ((AR_w + cos(Swept_Angle)) / (AR_w + (4 * cos(Swept_Angle)))) * (tan(Swept_Angle));

Yp = (Q * S_w * b_w * C_yp) / (2 * m * U_0);

C_np = - (CL_0w / 8);

Np = (Q * S_w * (b_w^2) * C_np) / (2 * I_x * U_0);

Spiral = -(((Lr * NBeta) - (LBeta * Nr)) / LBeta);

%% Determine whether the aircraft meets the stable spiral criteria (p197)
(LBeta*Nr) > (NBeta*Lr);

end