% clc;
% clear all;
% close all;
% 
% format long g

% =========================================================================
% Load aircraft and atmospheric data
% =========================================================================

% Store navion stability information into a structure titled ac_coeff
ac_coeff = load('navioncfg.mat');

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

%  u0 = 0.7*ac_coeff.VaBnd( length(ac_coeff.VaBnd) )    % m/s
% u0 = 35;
% Altitude = 500;

% Aircraft velocity (needs to be updated with each time step)
%u0 = VaBnd( length(VaBnd) );    % m/s
ac_coeff.Mach1 = 340;                     % m/s
ac_coeff.M = u0/ac_coeff.Mach1;
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

% rho = interp1(Table_Altitude, Table_Density, Altitude, 'linear', 'extrap');
% Q = 0.5*rho*(u0^2);
% =========================================================================
% =========================================================================


% =========================================================================
% Aircraft plant Derivatives
% =========================================================================

% Y derivatives
% YBeta = (Q*ac_coeff.S*ac_coeff.CYbeta)/ac_coeff.m;
% Yv = YBeta/u0;
% Yp = (Q*ac_coeff.S*ac_coeff.b*ac_coeff.CYp)/(2*ac_coeff.m*u0);
% Yr = (Q*ac_coeff.S*ac_coeff.b*ac_coeff.CYr)/(2*ac_coeff.m*u0);
theta0 = 0;

% L derivatives
% LBeta = (Q*ac_coeff.S*ac_coeff.b*ac_coeff.Clbeta)/ac_coeff.Ix;
% Lv = LBeta/u0;
% Lp = (Q*ac_coeff.S*(ac_coeff.b^2)*ac_coeff.Clp)/(2*ac_coeff.Ix*u0);
% Lr = (Q*ac_coeff.S*(ac_coeff.b^2)*ac_coeff.Clr)/(2*ac_coeff.Ix*u0);

% N derivatives
% NBeta = (Q*ac_coeff.S*ac_coeff.b*ac_coeff.Cnbeta)/ac_coeff.Iz;
% Nv = NBeta/u0;
% Np = (Q*ac_coeff.S*(ac_coeff.b^2)*ac_coeff.Cnp)/(2*ac_coeff.Iz*u0);
% Nr = (Q*ac_coeff.S*(ac_coeff.b^2)*ac_coeff.Cnr)/(2*ac_coeff.Iz*u0);

% =========================================================================
% Aircraft model
% =========================================================================

% State space aircraft model

% xdot = Ax + Bu
% where x = [Delta_v, Delta_p, Delta_r, Delta_phi]

A_Lat = [Yv,               Yp,               -(u0 - Yr),              g;...
         Lv,               Lp,               Lr,                      0;...
         Nv,               Np,               Nr,                      0;...
         0,                1,                0,                       0]

% No control input (free response) 
 
B_Lat = zeros(4,2)

%B_Lat = [1 1; 1 1; 1 1; 1 1]

% all sensor outputs are visible 
C_Lat = eye(4)

% No disturbances
D_Lat = zeros(4,2)

Ac_Model = ss(A_Lat, B_Lat, C_Lat, D_Lat)

% =========================================================================
% =========================================================================


% =========================================================================
% =========================================================================

% visualise free response

% disturbance of 20 degree roll rate
x0_Lat = [0 0 0 0];


% =========================================================================
% =========================================================================

% initial = [u0; 0; 0; 0];


