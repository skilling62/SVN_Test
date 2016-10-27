%% Phugoid Function


function [Z_u, X_u] = Phugoid_Func()

global U_0 Q m S g

addpath .\Cranfield_Flight_Test_Data;
%% Creating 
data = xlsread('Phugoid_GpA.xls');

kts2ms = 0.51444; % kts to m/s 1 = 0.51444

time = data(:,1);
speed = data(:,4) * kts2ms; 

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

Z_u = -(U_0 * (Omeg_n^2)) / g
CZ_u = (m * U_0 * Z_u) / (Q * S);
X_u = 2 * Zeta * Omeg_n
CX_u = (m * U_0 * X_u) / (Q * S);

CL_0 = -(CZ_u) / 2
CD_0 = -(CX_u) / 3


end
