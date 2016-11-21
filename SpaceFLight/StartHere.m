% This is the script that should be run first

clearvars;
clc;

addpath .\Linearised_Aircraft_Model

%% Calculate Longitudinal Stability Derivatives

% Generate derivates from the Phugoid Response


% Generate Dervivates from Short Period. The input to the function is the method 
% number: 0 = inspection, 1 = logarithmic decrement
[Xw, Zw, Mw, Mw_dot, Mq] = SPeriod_Func(0);

%% Calculate Lateral Stability Derivatives



%%
% Lateral_Example_V2