function SPeriod_Func()

global U_0 Q m S Rho CD_0 I_y

addpath .\Cranfield_Flight_Test_Data;
%% Creating Data to use in calulations

data = xlsread('SPPO_GpA.xls');

 t = data(:,1);
 q = data(:,5);
 theta = data(:,2);
 
 figure(1)
 hold on
 subplot(2,1,1)
 plot(t,q)
 subplot(2,1,2)
 plot(t,theta)
 hold off
 
 %% Calculations
 
Pg_data = xlsread('Phugoid_GpA.xls');
 
Dens_Calc(358,Pg_data(1,5),18,1012)

Q = 0.5 * Rho * (U_0)^2;


cbar = 1.717;

Cmalpha = 1; %!!!!!!CHANGE!!!!!!!!!!!!

Clalpha = -0.1715; %!!!!!!CHANGE!!!!!!!!!!!!

Cm_q = 1; %!!!!!!CHANGE!!!!!!!!!!!!

Malphadot = 1; %!!!!!!CHANGE!!!!!!!!!!!!

 M_w = (Cmalpha * Q * S * cbar) / (U_0 * I_y);
 Z_w = -(((Clalpha + CD_0 ) * (Q * S) ) / (U_0 * m));
 Malpha = U_0 * M_w;
 Zalpha = U_0 * Z_w;
 M_q = (Cm_q * ((cbar / 2) * U_0) * Q * S * cbar) / (U_0 * I_y);
 
 Omeg_nsp = sqrt((Zalpha * M_q / U_0) - Malpha);
 Zeta_sp = -((M_q + Malphadot + (Zalpha / U_0))/(2 * Omeg_nsp));
  

end

