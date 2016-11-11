% clc;
% clear all;
% close all;

format long g
Phugoid_Data
Aircraft_Lateral_Matrix
% =========================================================================
% Load aircraft and atmospheric data
% =========================================================================

% Store navion stability information into a structure titled ac_coeff
ac_coeff = load('eurostar.mat');

ac_coeff.lt = ac_coeff.lt_arm;


% =========================================================================
% =========================================================================

% standard atmosphere data
load('stdatm.mat')

Table_Altitude = stdatm(:,1);   % m
Table_Temp = stdatm(:,2);       % K
Table_Pressure = stdatm(:,3);   % Pascals
Table_Density = stdatm(:,4);    % Kg/m^3
% =========================================================================
% =========================================================================


% =========================================================================
% Constants
% =========================================================================
%u0 = 0.7*ac_coeff.VaBnd(length(ac_coeff.VaBnd));    % m/s
Altitude = Altitude_Mean;

% Aircraft velocity (needs to be updated with each time step)    % m/s
ac_coeff.Mach1 = 340;                     % m/s
ac_coeff.M = u0_Mean/ac_coeff.Mach1;
%Altitude = 500;

% This value needs to be updated as the aircraft flies to better represent
% fuel use.
ac_coeff.m = ac_coeff.mgross;

ac_coeff.Ix = ac_coeff.Jgross(1);
ac_coeff.Iy = ac_coeff.Jgross(2);
ac_coeff.Iz = ac_coeff.Jgross(3);

% Constants
g = 9.81;   % ft/s^2
ac_coeff.W = ac_coeff.m*g;
rho = interp1(Table_Altitude, Table_Density, Altitude, 'linear');

% Initial State Vector
atmos = [g, ac_coeff.m, rho];

% ap = ac_performance(ac_coeff, atmos);

% =========================================================================
% Atmospheric Values
% rho = interp1( abs( Altitude - Table_Altitude ) )

rho = rho_Mean;%interp1(Table_Altitude, Table_Density, Altitude, 'linear', 'extrap');
Q = 0.5*rho*(u0_Mean)^2;
% =========================================================================
% =========================================================================


% =========================================================================
% Aircraft plant Derivatives
% ========================================================================= %random wing span
% u derivatives
CD0 = CD0_New;
CDu = 0;       % approximated for jet aircraft - page 111 of Nelson
CTu = -CD0;    % page 111 of Nelson (dC_T/(d(u/u0))
CXu = -( CDu + 2*CD0 ) + CTu;
Xu = ( CXu*Q*ac_coeff.S )/( u0_Mean*ac_coeff.m ); % /s
CL0 = CL0_New
CLu = 0;
CZu = -( (ac_coeff.M^2)/(1 - ac_coeff.M^2) )*CL0 - 2*CL0;
Zu= ( CZu*Q*ac_coeff.S )/( u0_Mean*ac_coeff.m ); % /s

Mu = 0;         % Assumed for low speed flight - p126 of Nelson

% w derivatives
CDa = 0;            % not a linear relationship - for low angles of attack assumed to be 0
CXw = -(CDa - CL0);
Xw = (CXw*Q*ac_coeff.S)/(u0_Mean*ac_coeff.m ); % /s

CZw = -(ac_coeff.CLa + CD0);
Zw = ( CZw*Q*ac_coeff.S )/( u0_Mean*ac_coeff.m ); % /s

%Iy = Jgross(2);
Iy = 820
xcg = ac_coeff.CGgross(1);
xac = ac_coeff.rAC(1);
CMaw = ac_coeff.CLa*( (xcg/ac_coeff.MAC) - (xac/ac_coeff.MAC) );
eta = 0.9;                  % realistic guess
VH = ( ac_coeff.lt*ac_coeff.St )/( ac_coeff.S*ac_coeff.MAC );
ARw = (ac_coeff.b^2)/ac_coeff.S;
e = 2/(2-ARw+((4+ARw^2))^0.5);
CLat = 0.8*ac_coeff.CLa;             % guess for the time being.
deps = ( 2*ac_coeff.CLa )/( pi*ARw );
CMat = -eta*VH*CLat*(1 - deps);
%CMa = CMaw + CMat; Produces value from eurostar config
CMa = ac_coeff.Cma;
Mw = CMa*( ( Q*ac_coeff.S*ac_coeff.MAC )/( u0_Mean*Iy ) ); % 1/m.s
% q derivatives
Cmq = -2*eta*CLat*VH*( ac_coeff.lt/ac_coeff.MAC );
Mq = Cmq*( ac_coeff.MAC/(2*u0_Mean) )*( ( Q*ac_coeff.S*ac_coeff.MAC )/Iy );
Xq = 0;
Zq = 0;
% w_dot derivates;
Xw_dot = 0;
Zw_dot = 0;
CLaw = ac_coeff.CLa/(1+(ac_coeff.CLa/(pi*e*ARw)));
de_da =(2/(pi*ARw))*CLaw;
Cmalpha_dot = ac_coeff.Cmalphadot;
Mw_dot = Cmalpha_dot*(ac_coeff.MAC/(2*u0_Mean))*((Q*ac_coeff.S*ac_coeff.MAC)/(u0_Mean*Iy));


% =========================================================================
% Aircraft model
% =========================================================================
% State space aircraft model
Xdt = 0.419;
Cm_deltae = -1.50401;
M_deltae= (Cm_deltae*(Q*ac_coeff.St*ac_coeff.MAC))/Iy; %Cm_deltae*((Q*ac_coeff.S*ac_coeff.MAC)/ac_coeff.Iy)
M_deltat = 0; 
Z_deltae = (ac_coeff.CZ_deltae*Q*ac_coeff.S)/ac_coeff.m
Z_deltat= 0;

% xdot = Ax + Bu
% where x = [Delta_u, Delta_v, Delta_q, Delta_theta]

A_AC = [Xu_Mean,                 Xw,             0,                     -g;...
     Zu_Mean,                    Zw,               u0_Mean,              0;...
     Mu + (Mw_dot*Zu_Mean), Mw + (Mw_dot*Zw), Mq + (Mw_dot*u0_Mean*26.5),       0;...
     0,                     0,                1,                         0];

% No control input (free response) 
 
% B = zeros(4,2)

B_AC = [0               Xdt;...
        Z_deltae            0; ...
        M_deltae+Mw_dot*Z_deltae     M_deltat+Mw_dot*Z_deltat;...
        0            0]

% all sensor outputs are visible 
C_AC = eye(4)

% No disturbances
D_AC = zeros(4,2)

Ac_Model = ss(A_AC, B_AC, C_AC, D_AC)

% =========================================================================
% =========================================================================


% =========================================================================
% =========================================================================

% visualise free response

% disturbance of 10 deg in pitch
x0 = [10 0 0 10*(pi/180)];
% % [y, t, x] = initial(Ac_Model, x0);
% % y = transpose(y);
% % plot(t,y)
% % xlabel('time (s)')
% % legend('u (ft/s)', 'v (ft/s)', 'q (rads/s)', 'theta (rads)')

% % m = 4;      % num inputs
% % 
% % Nt = 1000;   % 1000 samples
% % t_end = 10;  % simulate for 10 seconds
% % t = linspace(0, t_end, Nt);
% % 
% % u = ones(m, Nt);      % a step input on all inputs 
% % 
% lsim(Ac_Model,y,t)

% =========================================================================
% =========================================================================

initial = [u0_Mean; 0; 0; 0; 0; 0; 0; 0];

% Laplace = conv(A)

% % Roots = eig(A);
% % 
% % % Short Period Roots
% % SP_Roots = Roots(1);
% % SP_Eta = real(SP_Roots);
% % SP_wd = imag(SP_Roots);
% % SP_Period = (2*pi)/SP_wd
% % 
% % % Phugoid Roots
% % LP_Roots = Roots(3);
% % LP_Eta = real(LP_Roots);
% % LP_wd = imag(LP_Roots);
% % LP_Period = (2*pi)/LP_wd

