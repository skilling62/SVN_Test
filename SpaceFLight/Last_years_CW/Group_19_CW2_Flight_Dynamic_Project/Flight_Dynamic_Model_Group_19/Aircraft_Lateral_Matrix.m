% Aircraft Lateral Matrix 
% Group 19

% clc;
% clear all;
% close all;

format long g
Phugoid_Data

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

%u0 = 0.7*ac_coeff.VaBnd( length(ac_coeff.VaBnd) );    % m/s
Altitude = Altitude_Mean;

% Aircraft velocity (needs to be updated with each time step)
%u0 = VaBnd( length(VaBnd) );    % m/s
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
g = 9.81;   % m/s^2
ac_coeff.W = ac_coeff.m*g;
rho = interp1(Table_Altitude, Table_Density, Altitude, 'linear');

% Initial State Vector
atmos = [g, ac_coeff.m, rho];

% ap = ac_performance(ac_coeff, atmos);

% =========================================================================
% Atmospheric Values
% rho = interp1( abs( Altitude - Table_Altitude ) )

rho = interp1(Table_Altitude, Table_Density, Altitude, 'linear', 'extrap');
Q = 0.5*rho*(u0_Mean^2);
% =========================================================================
% =========================================================================


% =========================================================================
% Aircraft plant Derivatives
% =========================================================================

% u derivatives
CD0 = CD0_New;
CDu = 0;       % approximated for jet aircraft - page 111 of Nelson

% Iy = Jgross(2);

xcg = ac_coeff.CGgross(1);
xac = ac_coeff.rAC(1);
eta = 0.9;                  % realistic guess
VH = ( ac_coeff.lt*ac_coeff.St )/( ac_coeff.S*ac_coeff.MAC );
ARw = (ac_coeff.b^2)/ac_coeff.S;

% q derivatives
% =========================================================================
% Aircraft model
% =========================================================================
%deltab = deltav/u0_Mean;
%% Y coefficients
Yp = (ac_coeff.CYp*Q*ac_coeff.S*ac_coeff.b)/(2*ac_coeff.m*u0_Mean);
Yr = (ac_coeff.CYr*Q*ac_coeff.S*ac_coeff.b)/(2*ac_coeff.m*u0_Mean);
Ybeta = (ac_coeff.CYbeta*Q*ac_coeff.S)/ac_coeff.m;
Yv = Ybeta/u0_Mean;
theta0 = 0.8;
%% L Coefficients
Lp =(ac_coeff.Clp*Q*ac_coeff.S*(ac_coeff.b^2))/(2*ac_coeff.Ix*u0_Mean);
Lr =(ac_coeff.Clr*Q*ac_coeff.S*(ac_coeff.b^2))/(2*ac_coeff.Ix*u0_Mean);
Lbeta = (ac_coeff.Clbeta*Q*ac_coeff.S*ac_coeff.b)/ac_coeff.Ix;
Lv = Lbeta/u0_Mean;
%% N Coefficients
Np = (ac_coeff.Cnp*Q*ac_coeff.S*(ac_coeff.b^2))/(2*ac_coeff.Iz*u0_Mean);
Nr = (ac_coeff.Cnr*Q*ac_coeff.S*(ac_coeff.b^2))/(2*ac_coeff.Iz*u0_Mean);
Nbeta = (ac_coeff.Cnbeta*Q*ac_coeff.S*ac_coeff.b)/ac_coeff.Iz;
Nv = -(ac_coeff.lt*Yv);%Nbeta/u0_Mean;
%% B-Matrix info
Lda = (ac_coeff.Clda*Q*ac_coeff.S*ac_coeff.b)/(ac_coeff.Ix);
Ldr = (Q*ac_coeff.S*ac_coeff.b*ac_coeff.Cldr)/ac_coeff.Ix;
Nda = (ac_coeff.Cnda*Q*ac_coeff.S*ac_coeff.b)/ac_coeff.Iz;
Ndr = (ac_coeff.Cndr*Q*ac_coeff.S*ac_coeff.b)/ac_coeff.Iz;
Ydr = (Q*ac_coeff.S*ac_coeff.CYdr)/ac_coeff.m;
%% Yaw control damping
wn_ydTEMP =((Ybeta*Nr-Nbeta*Yr+u0_Mean*Nbeta)/u0_Mean);
wn_yd = sqrt(wn_ydTEMP);
zeta_yd = -(1/(2*wn_yd))*((Ybeta+u0_Mean*Nr)/u0_Mean);
%% Dutch roll damping
wn_dr = sqrt(Nbeta);
zeta_dr = -Nr/(2*wn_dr);
%% State space aircraft model


% xdot = Ax + Bu
% where x = [Delta_u, Delta_v, Delta_q, Delta_theta]

A_Lat = [Yv,               Yp,               -(u0_Mean - Yr),              -g*cos(theta0);...
        Lv,               Lp,                            Lr,               0;...
      Nv,               Np,                            Nr,               0;...
     0,                 1,                             0,               0]
%A_Lat = [Ybeta/u0_Mean, Yp/u0_Mean, -(1-(Yr/u0_Mean)), ((g*cos(theta0))/u0_Mean);...
                %ac_coeff.Lbeta,         Lp,                Lr,                         0;...
                %Nbeta,         Np,                Nr,                         0;...
                   % 0,          1,                 0,                         0] 
% No control input (free response) 
 
% B = zeros(4,2)

B_Lat = [0          (Ydr/u0_Mean);...
        Lda                  Ldr;...
        Nda                  Ndr;...
        0                      0]

% all sensor outputs are visible 
C_Lat = eye(4)

% No disturbances
D_Lat = zeros(4,2)

%AC_Model = ss(A_Lat, B_Lat, C_Lat, D_Lat)

% =========================================================================
% =========================================================================


% =========================================================================
% =========================================================================

% visualise free response
x_Lat = [0 0 0 0];
initial = [0; 0; 0; 0; 0; 0; 0; 0];
% disturbance of 10 deg in pitch
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