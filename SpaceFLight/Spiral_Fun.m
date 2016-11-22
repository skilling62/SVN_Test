function Spiral_Fun ()


%	z_v Still need to find


C_nBeta = C_nBeat_wf + (EffFac_V * V_v * CL_Av * (1 - dSigBYdBeta))
N_Beta = (Q * S_w * b_w * C_nBeta) / I_z



CL_r = (CL / 4) - (2 * (l_v/b_w) * (z_v/b_w) * C_yBeta_v)
L_r = (Q * S_w * (b_w^2) * CL_r) / (2 * I_x * U_0)



C_nr = -(2 * EffFac_V * V_v * (l_v/b_w) * CL_Av)
N_r = (Q * S_w * (b_w^2) * C_nr) / (2 * I_x * U_0)

Spiral = -(((L_r * N_Beta) - (L_Beta * N_r)) / L_Beta)











end