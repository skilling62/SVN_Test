function [L_Sig_Al] = Roll_Fun()

global S_w b_w I_z CL_Aw g W Y1 Y2 Cr Lan


    addpath .\Cranfield_Flight_Test_Data;

    Pg_data = xlsread('Phugoid_GpA.xls');
    
    Rho = Dens_Calc(358,Pg_data(1,5),18,1012);

    U_0 = Initial_Speed();

    Q = 0.5 * Rho * (U_0)^2;
    
%% Equations

    T_Con = 2 * (W / S_w)/ (CL_Aw * Rho * U_0 * g); % Time Constant

    CL_Sig_Al = ((2 * CL_Aw * T_Con * Cr) / (S_w * b_w)) ...
        * (((Y2/2)^2 + ((Lan - 1)/(b_w / 2))*(Y2/3)^3)) - (((Y1/2)^2 ...
        + ((Lan - 1)/(b_w / 2))*(Y1/3)^3));
   
    L_Sig_Al = (Q * S_w * b_w * CL_Sig_Al) / I_z
    
    CL_p = 1
    
    L_p = 1









end