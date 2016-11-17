function DutchRoll_Func ()

global S_v S_w b_w b_v V_v l_v m I_z 
global CL_Av dEpsBYdAlpha C_nBeta_wt EffFac_V

addpath .\Cranfield_Flight_Test_Data;

%% Data Needed for Calculations

C_yBetaTail = CL_Av * EffFac_V * (S_v / S_w);

C_yr = -2 * (-C_yBetaTail) * (l_v / b_v);

C_nr = -2 * EffFac_V * V_v * (l_v / b_v) * CL_Av;

C_yBeta = -EffFac_V * (S_v / S_w) * CL_Av * (1 + dEpsBYdAlpha);

C_nBeta = C_nBeta_wt + (EffFac_V * V_v * CL_Av * (1 + dEpsBYdAlpha));

%% Calculations

Pg_data = xlsread('Phugoid_GpA.xls');

Rho = Dens_Calc(358,Pg_data(1,5),18,1012);

U_0 = Initial_Speed();

Q = 0.5 * Rho * (U_0)^2;

Y_beta = (Q * S_w * C_yBeta) / m

N_Beta = (C_nBeta * Q * S_w) / I_z

Y_r = (Q * S_w * b_w * C_yr) / (2 * m * U_0)

N_r = (Q * S_w * (b_w^2) * C_nr) / (2 * I_z * U_0)

end