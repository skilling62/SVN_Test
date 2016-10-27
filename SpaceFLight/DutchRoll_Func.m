function DutchRoll_Func ()

global S_v S_w b_w b_v V_v l_v m U_0 I_z Rho
global CL_AlphaV dSigmaBYdBeta C_nBeta_wt EffFac_V

addpath .\Cranfield_Flight_Test_Data;

%% Data Needed for Calculations

C_yBetaTail = CL_AlphaV * EffFac_V * (S_v / S_w);

C_yr = -2 * (-C_yBetaTail) * (l_v / b_v);

C_nr = -2 * EffFac_V * V_v * (l_v / b_v) * CL_AlphaV;

C_yBeta = -EffFac_V * (S_v / S_w) * CL_AlphaV * (1 + dSigmaBYdBeta);

C_nBeta = C_nBeta_wt + (EffFac_V * V_v * CL_AlphaV * (1 + dSigmaBYdBeta));

%% Calculations

Pg_data = xlsread('Phugoid_GpA.xls');
 
Dens_Calc(358,Pg_data(1,5),18,1012)

Q = 0.5 * Rho * (U_0)^2;

Y_beta = (Q * S_w * C_yBeta) / m

N_Beta = (C_nBeta * Q * S_w) / I_z

Y_r = (Q * S_w * b_w * C_yr) / (2 * m * U_0)

N_r = (Q * S_w * (b_w^2) * C_nr) / (2 * I_z * U_0)

end