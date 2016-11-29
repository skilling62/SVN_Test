% This is the starting script. The five functions that
% correspond to each mode are run sequentially, and generate the required
% stability derivatives. For the Phugoid, Short Period and Dutch Roll modes
% the frequency and damping ratio can be determined using different
% methods, depending on the user input

clearvars;
clc;

addpath .\Linearised_Aircraft_Model

%% Set Reference Speed u0
[u0] = Initial_Speed();

%% Calculate Lateral Stability Derivatives

% Generate Derivatives from Roll Response
% Input '1' = Graphical approximation of Lp   Input '2' Lp approximation
% from aircraft data
[Lp] = Roll_Func(1);

% Generate Dervivatives from Dutch Roll Response
% Input '1' Damping and frequency only (logarithmic decrement) Input '2'
% Damping and frequency only (inspection)   Input '3' Derivatives, damping
% and frequency (aircraft data)
[Yv ,Yr, Nr] = DutchRoll_Func(3);

% Generate Derivatives from the Spiral Response
[Nv, Lv, Lr, Yp, Np] = Spiral_Func();

%% Calculate Longitudinal Stability Derivatives

% Generate derivates from the Phugoid Response
% Input '1' = Logarithmic Decrement  Input '2' = Bairstow approximation
% Input '3' = 3-Degrees-of-Freedom Approximation
[Xu, Zu] = Phugoid_Func(1);

% Generate Dervivates from Short Period. The input to the function is the method 
% Input '0' = inspection, Input '1' = Logarithmic Decrement, 
[Xw, Zw, Mw, Mw_dot, Mq] = SPeriod_Func(1);

%% Run the Simulink Model
Longitudinal_Example_V5