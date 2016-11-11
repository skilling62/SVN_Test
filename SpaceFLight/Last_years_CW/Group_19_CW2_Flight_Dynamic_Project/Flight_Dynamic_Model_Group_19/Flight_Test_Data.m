% =========================================================================
% =========================================================================

% Calculating CD0 (Coefficient of Drag at zero angle of attack) 
% and CL0 (Coefficient of Lift at zero angle of attack) from phugoid flight
% test data.

% written by: Dr Pritesh Narayan (UWE) - September 2015
% Edited by Group 19

clear all
close all
clc

% =========================================================================
% =========================================================================

% Using dataset in PDF extract damping ratio and natural frequency
% information

%% Import the data
[~, ~, raw] = xlsread('C:\Users\brendan\Documents\MATLAB\Initial_Model_Flight_1102015\PhugoidValues.xlsx','Sheet1','B4:J43');
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
PhugoidValues = reshape([raw{:}],size(raw));

%% Clear temporary variables
clearvars raw R;



delta = -log( ( (abs(r(3)-r(1)))/(abs(r(2)-r(1))) ) )
zeta = delta/sqrt( (pi^2+delta^2) )     % Damping ratio

wd = (2*pi)/(t3_t1)                     % Damped natural frequency
wn = wd/( sqrt(1-zeta^2) )              % Natural frequency

% =========================================================================

% Using the characteristic equation of the second order state space model
% calculate CL0

g = 9.81
airspeed = mean(r)          % in mph
mph_to_mps = 0.44704
u0 = airspeed*mph_to_mps    % m/s
m = 450                     % Kg - Use empty weight, pilots and fuel in your calculation

% Change in Vertical force with respect to forward velocity
Zu = (-wn^2*u0)/g

S = 9.84                    % m^2 (in POH)
Altitude_ft = 1800          % ft (after climb test)
ft_to_m = 0.3048
Altitude_m = Altitude_ft*ft_to_m    % m
rho = stdatmo(Altitude_m)
Q = 0.5*rho*u0^2            % Dynamic Pressure

CZu = (m*u0*Zu)/(Q*S)     
CL0 = -CZu/2

% =========================================================================

% Using the characteristic equation of the second order state space model
% calculate CL0

Xu = -2*zeta*wn
CXu = (m*u0*Xu)/(Q*S)     

CD0 = -CXu/3