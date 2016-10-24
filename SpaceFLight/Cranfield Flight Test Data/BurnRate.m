%% Gravity 

data = xlsread('Phugoid_GpA.xls');

time = data(:,1);

In_Fuel = 6348;

End_Fuel = 5704;

Fuel_Used = In_Fuel - End_Fuel;

Burn_Rate = Fuel_Used / (40 * 60); % kg/s

Fuel_Con = (In_Fuel./ time)  - Burn_Rate; Fuel_Con_A = 5.643; Fuel_Con_Mo = Fuel_Con * Fuel_Con_A; 

AC_W = 4949; AC_A = 5.569; AC_Mo = AC_W * AC_A;
StRow3_W = 60; StRow3_A = 5.400; StRow3_Mo = StRow3_W * StRow3_A;
StRow4_W = 207; StRow4_A = 6.370; StRow4_Mo = StRow4_W * StRow4_A;
StRow5_W = 149; StRow5_A = 7.130; StRow5_Mo = StRow5_W * StRow5_A;
StRow6_W = 239; StRow6_A = 7.890; StRow6_Mo = StRow6_W * StRow6_A;
CO_W = 85; CO_A = 8.550; CO_Mo = CO_W * CO_A;

SUM_Mass = (AC_W + Fuel_Con + StRow3_W + StRow4_W + StRow5_W + StRow6_W + CO_W);
SUM_Mom = (AC_Mo + Fuel_Con_A + StRow3_Mo + StRow4_Mo + StRow5_Mo + StRow6_Mo + CO_Mo);

CG = ((-(SUM_Mom/SUM_Mass)-5.149));


plot(SUM_Mass, CG)


