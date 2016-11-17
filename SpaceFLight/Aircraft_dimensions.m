

xm = 4.67; % Distances from the datum to the CG m
lf = 13.446; % length of the fuselage m
h1f = 1.992; % height of the fuselage at 1/4 length m
h2f = h1f/2; % height of the fuselage at 3/4 length m
wf = 1.981;  % max body width m
Sf = 18.51;  % body side area m^2
vis = 1.694; % N.s/m^2, Assumed constant at 3000m Ref: http://www.engineeringtoolbox.com/standard-atmosphere-d_604.html
S_w = 25.083;
b_w = 15.85;

KN_Factor1 = xm / lf
KN_Factor2 = (lf^2) / Sf
KN_Factor3 = sqrt(h1f / h2f)
KN_Factor4 = h1f / wf

Kn = 0.0015

V_lf = (Sf * lf) / (S_w * b_w);

R_lf = (V_lf * vis)*10^-6

K_Rl = 1.2;





