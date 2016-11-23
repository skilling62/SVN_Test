% This is the starting script. The five functions that
% correspond to each mode are run sequentially, and generate the required
% stability derivatives. For the Phugoid, Short Period and Dutch Roll modes
% the frequency and damping ratio can be determined using different
% methods, depending on the user input

clearvars;
clc;

addpath .\Linearised_Aircraft_Model

%% Calculate Longitudinal Stability Derivatives

% Generate derivates from the Phugoid Response
% Input '1' = Logarithmic Decrement  Input '2' = Bairstow approximation
% Input '3' = 3-Degrees-of-Freedom Approximation
[Xu, Zu] = Phugoid_Func(1);

% Generate Dervivates from Short Period. The input to the function is the method 
% Input '0' = inspection, Input '1' = Logarithmic Decrement
[Xw, Zw, Mw, Mw_dot, Mq] = SPeriod_Func(0);

%% Calculate Lateral Stability Derivatives

% Generate Derivatives from Roll Response
[Lp] = Roll_Fun();

%%
Longitudinal_Example_V2