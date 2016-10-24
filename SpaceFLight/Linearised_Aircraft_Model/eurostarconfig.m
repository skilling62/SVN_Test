%%% AIRCRAFT CONFIGURATION SCRIPT %%%
%%% Navion GA airplane - sample model from AeroSim Library %%%

%   Copyright 2002 Alexander Pantry Dynamics, ALP

% Clear workspace
clear all;

% Name of the MAT-file that will be generated
cfgmatfile = 'eurostar';

%%% AERODYNAMICS %%%
% Aerodynamic force application point (usually the aerodynamic center)[x y z]
rAC = [0.43434 0 0]; % m

%%% Aerodynamic parameter bounds %%%
% Airspeed bounds
VaBnd = [30 55]; % m/s
% Angle of attack bounds
AlphaBnd = [-0.1 0.5]; % rad

%%% Aerodynamic reference parameters %%%
% Mean aerodynamic chord
MAC = 1.406386702; % m
% Wind span
b = 9.144263304; % m
% Wing area
S = 9.84; % m^2
% Length (of the internets)
L = 7.25;    % m
% moment arm (just a guess based on length)
lt_arm = 4.36;     % m
% Tail area
St = 2.267;  % m^2
Se = 14.1*0.3048^2;  % m^2


% ALL aerodynamics derivatives are per radian:
%%% Lift coefficient %%%
% Zero-alpha lift
CL0 = 0.3;
% alpha derivative
CLa = 3.9274;
% Lift control (flap) derivative
CLdf = 0;
% Pitch control (elevator) derivative
CLde = 0.355;
% alpha-dot derivative
CLalphadot = 0;
% Pitch rate derivative
CLq = 3.8;
% Mach number derivative
CLM = 0;

%%% Drag coefficient %%%
% Lift at minimum drag
CLmind = 0.3;
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
CYbeta = -0.554906;
% Roll control derivative
CYda = 0;
% Yaw control derivative
CYdr = 0.1688;
% Roll rate derivative
CYp = 0;
% Yaw rate derivative
CYr = 0;

%%% Pitch moment coefficient %%%
% Zero-alpha pitch
Cm0 = 0;
% alpha derivative
Cma = -0.5736;
% Lift control derivative
Cmdf = 0;
% Pitch control derivative
Cmde = -0.05366;
% alpha_dot derivative
Cmalphadot = -1.4842;
% Pitch rate derivative
Cmq = -3.31865;
% Mach number derivative
CmM = 0;

%%% Roll moment coefficient %%%
% Sideslip derivative
Clbeta = -0.0708;
% Roll control derivative
Clda = -0.137136;
% Yaw control derivative
Cldr = 0.1035;
% Roll rate derivative
Clp = -0.5996;
% Yaw rate derivative
Clr = 0.1079237;

%%% Yaw moment coefficient %%%
% Sideslip derivative
Cnbeta = 0.05;
% Roll control derivative
Cnda = -0.0044;
% Yaw control derivative
Cndr = -0.0749;
% Roll rate derivative
Cnp = -0.04909;
% Yaw rate derivative
Cnr = -0.1296;

%%% INERTIA %%%
% Empty aircraft mass (zero-fuel)
mempty = 544; % kg
% Gross aircraft mass (full fuel tank)
mgross = 996; % kg
% Empty CG location [x y z]
CGempty = [-0.04*MAC 0 -0.25]; % m
% Gross CG location [x y z]
CGgross = [-0.045*MAC 0 -0.2]; % m
rAC = CGgross; % m
% Empty moments of inertia [Jx Jy Jz Jxz]
Jempty = [1040 2900 3500 100]*14.594*0.3048^2; % kg*m^2
% Gross moments of inertia [Jx Jy Jz Jxz]
Jgross = [1048 3000 3530 110]*14.594*0.3048^2; % kg*m^2


%%% OTHER SIMULATION PARAMETERS %%%
% WMM-2000 date [day month year]
dmy = [13 05 2002];

% Save workspace variables to MAT file
save(cfgmatfile);

% Output a message to the screen
fprintf(strcat('\n Aircraft configuration saved as:\t', strcat(cfgmatfile),'.mat'));
fprintf('\n');

