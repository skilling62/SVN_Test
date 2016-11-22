function Spiral_Func()
%	z_v Still need to find


load('JetStream', 'C_nBeta_wt', 'EffFac_V', 'S_v', 'V_v', 'CL_Av', 'dSigmaBYdBeta', ...
    'S_w', 'b_w', 'I_z', 'S_w', 'b_w', 'I_x', 'I_z', 'l_v', 'z_v', 'U_0', ...
    'CL_Av', 'S_w', 'Gamma', 'CL_BetaByGam', 'CL_w')

Spiral_Data = xlsread('Spiral_GpA.xls');
Rho = Dens_Calc(358,Spiral_Data(1,3),18,1012);
Q = 0.5 * Rho * (U_0^2);

C_nBeta = C_nBeta_wt + (EffFac_V * V_v * CL_Av * (1 - dSigmaBYdBeta));
N_Beta = (Q * S_w * b_w * C_nBeta) / I_z
    
CL_Beta = CL_BetaByGam / Gamma; 
L_Beta = (Q * S_w * b_w * CL_Beta) / I_x

C_yBeta = -EffFac_V * (S_v / S_w) * CL_Av * (1 + dSigmaBYdBeta);
CL_r = (CL_w / 4) - (2 * (l_v/b_w) * (z_v/b_w) * C_yBeta); %CL_w causes the array of numbers
L_r = (Q * S_w * (b_w^2) * CL_r) / (2 * I_x * U_0)

C_nr = -(2 * EffFac_V * V_v * (l_v/b_w) * CL_Av);
N_r = (Q * S_w * (b_w^2) * C_nr) / (2 * I_x * U_0)

Spiral = -(((L_r * N_Beta) - (L_Beta * N_r)) / L_Beta)











end