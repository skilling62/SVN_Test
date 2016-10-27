%% Phugoid Function


function Phugoid_Func()

global U_0 Q m S_w g Rho CD_0 CL_0 Mach CL_u

addpath .\Cranfield_Flight_Test_Data;
%% Creating Data to use in calulations

Pg_data = xlsread('Phugoid_GpA.xls');

kts2ms = 0.51444; % kts to m/s 1 = 0.51444

time = Pg_data(:,1);
speed = Pg_data(:,4) * kts2ms; 

[pk,lc] = findpeaks(speed,time);
[troughs, lc1] = findpeaks(-speed,time);
troughs = -troughs;
plot(time,speed, 'g',lc, pk, 'mo', lc1, troughs, 'ko');
ax.XTickLabelMode = 'auto';
grid minor;

t1 = lc(1,:); 
t2 = lc1(1,:); 
t3 = lc(2,:); 
t4 = lc1(2,:); 
t5 = lc(3,:); 
t6 = lc1(3,:); 

r1 = pk(1,:); 
r2 = troughs(1,:); 
r3 = pk(2,:); 
r4 = troughs(2,:); 
r5 = pk(3,:); 
r6 = troughs(3,:);

%% Calculations

Omeg_d = 2*(pi)/ (t3 - t1);
lil_delta = -log((abs(r3 - r1))/ (abs(r2 - r3)));
Zeta = lil_delta / (sqrt((pi^2) + (lil_delta^2)));
Omeg_n = Omeg_d / (sqrt(1 - (Zeta^2)));

Dens_Calc(358,Pg_data(1,5),18,1012)

Q = 0.5 * Rho * (U_0)^2;


Z_u = - ( U_0 * (Omeg_n^2)) / g
CZ_u = (m * U_0 * Z_u) / (Q * S_w);
X_u = 2 * Zeta * Omeg_n
CX_u = (m * U_0 * X_u) / (Q * S_w);

CL_0 = -(CZ_u) / 2
CD_0 = -(CX_u) / 3
CL_u = ((Mach)^2 / (1 - (Mach)^2)) * CL_0

end
