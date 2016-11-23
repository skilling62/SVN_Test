clc;

close all;

format long g

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

u0 = 0.7*ac_coeff.VaBnd( length(ac_coeff.VaBnd) );    % m/s
Altitude = 500;

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

rho = interp1(Table_Altitude, Table_Density, Altitude, 'linear', 'extrap');
Q = 0.5*rho*(u0^2);
% =========================================================================
% =========================================================================


% =========================================================================
% Aircraft plant Derivatives
% =========================================================================

% u derivatives
CD0 = ac_coeff.CDmin;
CDu = 0;       % approximated for jet aircraft - page 111 of Nelson
CTu = -CD0;    % page 111 of Nelson (dC_T/(d(u/u0))
CXu = -( CDu + 2*CD0 ) + CTu;
Xu = ( CXu*Q*ac_coeff.S )/( u0*ac_coeff.m ); % /s

CZu = -( (ac_coeff.M^2)/(1 - ac_coeff.M^2) )*ac_coeff.CL0 - 2*ac_coeff.CL0;
Zu = ( CZu*Q*ac_coeff.S )/( u0*ac_coeff.m ); % /s

Mu = 0;         % Assumed for low speed flight - p126 of Nelson

% w derivatives
CDa = 0;            % not a linear relationship - for low angles of attack assumed to be 0
CXw = -( CDa - ac_coeff.CL0 );
Xw = ( CXw*Q*ac_coeff.S )/( u0*ac_coeff.m ); % /s

CZw = -( ac_coeff.CLa + CD0 );
Zw = ( CZw*Q*ac_coeff.S )/( u0*ac_coeff.m ); % /s

% Iy = Jgross(2);

xcg = ac_coeff.CGgross(1);
xac = ac_coeff.rAC(1);
CMaw = ac_coeff.CLa*( (xcg/ac_coeff.MAC) - (xac/ac_coeff.MAC) );
eta = 0.9;                  % realistic guess
VH = ( ac_coeff.lt*ac_coeff.St )/( ac_coeff.S*ac_coeff.MAC );
ARw = (ac_coeff.b^2)/ac_coeff.S;
CLat = 0.8*ac_coeff.CLa;             % guess for the time being.
deps = ( 2*ac_coeff.CLa )/( pi*ARw );
CMat = -eta*VH*CLat*(1 - deps);
CMa = CMaw + CMat;
CMa = ac_coeff.Cma;

Mw = CMa*( ( Q*ac_coeff.S*ac_coeff.MAC )/( u0*ac_coeff.Iy ) ); % 1/m.s

% q derivatives
Cmq = -2*eta*CLat*VH*( ac_coeff.lt/ac_coeff.MAC );
Mq = Cmq*( ac_coeff.MAC/( 2*u0 ) )*( ( Q*ac_coeff.S*ac_coeff.MAC )/ac_coeff.Iy );

% w_dot derivates
Xw_dot = 0;
Zw_dot = 0;
Mw_dot = -0.0051; % 1/ft

% q derivatives
Xq = 0;
Zq = 0;

% =========================================================================
% Aircraft model
% =========================================================================

% State space aircraft model

% xdot = Ax + Bu
% where x = [Delta_u, Delta_w, Delta_q, Delta_theta]



% =========================================================================
% Example of short period for the flight simulator 
% =========================================================================

% A_SP = [Zw,                u0; ...
%         Mw + (Mw_dot*Zw),   Mq + Mw_dot*u0,]
% 
%     B_SP = [1; 1]
%     
%     C_SP = [1, 1]
%     
%     D_SP = 0
%     
%     X0_SP  = [0, 1]
%     
% damp(A_SP)    
    
    
A_Lon = [Xu,               Xw,               0,              -g;...
     Zu,               Zw,               u0,              0;...
     Mu + (Mw_dot*Zu), Mw + (Mw_dot*Zw), Mq + Mw_dot*u0,  0;...
     0,                0,                1,               0]

% No control input (free response) 
 
% B = zeros(4,2)

B_Lon = [0 0; 0 0; 0 0; 0 0]

% all sensor outputs are visible 
C_Lon = eye(4)

% No disturbances
D_Lon = zeros(4,2)

Ac_Model = ss(A_Lon, B_Lon, C_Lon, D_Lon)

% =========================================================================
% =========================================================================


% =========================================================================
% =========================================================================

% visualise free response

% disturbance of 10 deg in pitch
x0_Lon = [0 0 0 0];
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

initial = [u0; 0; 0; 0; 0; 0; 0; 0];

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

