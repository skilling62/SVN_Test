%%% AIRCRAFT CONFIGURATION SCRIPT %%%
%%% Eurostar airplane - sample model from AeroSim Library %%%

%   Copyright 2002 Alexander Pantry Dynamics, ALP
%   Edited by Group 19
%   Clear workspace
clear all;

% Name of the MAT-file that will be generated
cfgmatfile = 'eurostar';
Phugoid_stuff
Aircraft_Lateral_Model

%%% AERODYNAMICS %%%
% Aerodynamic force application point (usually the aerodynamic center)[x y z]
% rAC = [0.43434 0 0]; % m

%%% Aerodynamic parameter bounds %%%
% Airspeed bounds
VaBnd = [30 55]; % m/s
% Angle of attack bounds
AlphaBnd = [-0.1 0.5]; % rad

%%% Aerodynamic reference parameters %%%
% Mean aerodynamic chord
MAC = 1.25; % m
% Wind span
b = 8.1; % m
% Wing area
S = 9.84; % m^2
% Length (of the internets)
L = 5.98;    % m
% moment arm (just a guess based on length)
lt_arm = 1.35;     % m
% Tail area
St = 1.95;  % m^2
Se = 0.8;  % m^2
stv = 1;
str = 0.4;
eta =0.9;
CSR = Se/St;
tau = 0.63;
d = 1.24;
theta0 = 0.8;
ARw = (b^2)/S;
%zv = 0.56;
zw = -1.865519931766702;

eta_v = 0.724+(3.06*((stv/St)/2))+(0.4*(zeta_dr/d))+(0.009*ARw);
% Yaw rate derivative
Vv = (lt_arm*stv)/(b*S);
% ALL aerodynamics derivatives are per radian:
%%% Lift coefficient %%%
% Zero-alpha lift
CL0 = CL0_New;
% alpha derivative
CLa = 4.24;
% Lift control (flap) derivative
CLdf = 0;
% Pitch control (elevator) derivative
CLat = 0.8*CLa;
CL_deltae = (CLat*tau);
CZ_deltae=-CLat*tau*eta*(St/S);
% alpha-dot derivative
CLalphadot = 0;
% Pitch rate derivative
CLq = 3.8;
% Mach number derivative
CLM = 0;

%%% Drag coefficient %%%
% Lift at minimum drag
CLmind = 0.3;
CD0 = CD0_New;
% Minimum drag
CDmin = 0.04;
% Lift control (flap) derivative
CDdf = 0;
% Pitch control (elevator) derivative
CDde = 0;
% Roll control (aileron) derivative
CDda = 0;
% Yaw control (rudder) derivative
CDdr = 0;
% Mach number derivative
CDM = 0;
% Oswald's coefficient
osw = 0.75;

%%% Side force coefficient %%%
% Sideslip derivative
CLav = 0.1151;
CYbeta = -eta*(stv/S)*CLav;
CYbetat = -CLav*eta_v*(stv/S);
% Roll control derivative
CYda = 0;
% Yaw control derivative
Clbeta = -0.0708;
Lbeta = (Clbeta*693.3689*S*b)/408;
Lv = Lbeta/u0_Mean;
CYr = -2*(Lv/b)*CYbetat;
% Roll rate derivative
CYp = 0;
% Yaw rate derivative
CYr = 0;

%%% Pitch moment coefficient %%%
% Zero-alpha pitch
Cm0 = 0;
% alpha derivative
Cma = -0.388869404214273;
% Lift control derivative
Cmdf = 0;
% Pitch control derivative
Cmde = -0.05366;
% alpha_dot derivative
Cmalphadot = -4;
% Pitch rate derivative
Cmq = -3.31865;
% Mach number derivative
CmM = 0;

%%% Roll moment coefficient %%%
% Sideslip derivative
Clbeta = -0.0708;
% Roll control derivative
Clda = -(2*CLa*tau)/(S*b);
% Yaw control derivative
Cldr = (stv/S)*(zeta_dr/b)*tau*CLav;
% Roll rate derivative
Clp = -(2*CLa)/12;
% Yaw rate derivative
Clr = (CL0_New/4)-(2*(Lv/b)*(zeta_dr/b))*CYbetat;
K = -1.85; 
%%% Yaw moment coefficient %%%
% Sideslip derivative
Cnbeta = 0.05;
% Roll control derivative
Cnda = 2*K*CL0_New*Clda;
% Yaw control derivative
Cndr = -(Vv*eta_v*tau*CLav);
% Roll rate derivative
Cnp = -(CL0_New/8);
% Yaw rate derivative
Cnr = -(2*eta_v*Vv*(Lv/b))*CLav;

%%% INERTIA %%%
% Empty aircraft mass (zero-fuel)
mempty = 268; % kg
% Gross aircraft mass (full fuel tank)
mgross = Weight_Mean; % kg
% Empty CG location [x y z]
CGempty = [-0.18*MAC 0 -0.25]; % m
% Gross CG location [x y z]
CGgross = [-0.34*MAC 0 -0.2]; % m
rAC = CGgross; % m
% Empty moments of inertia [Jx Jy Jz Jxz]
Jempty = [617 318 941 94]; % kg*m^2
% Gross moments of inertia [Jx Jy Jz Jxz]
Jgross = [408 820 453.7 101]; % kg*m^2



% Save workspace variables to MAT file
save(cfgmatfile);

% Output a message to the screen
fprintf(strcat('\n Aircraft configuration saved as:\t', strcat(cfgmatfile),'.mat'));
fprintf('\n');