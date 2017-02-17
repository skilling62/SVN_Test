% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% IsolationValveLGCF.m 
% IsolationValveTesterF

% preconditions (shared variables)
A = evalin ('base','HydrOut.time');
B = evalin ('base', 'HydrOut.signals.values');
%% Test 1: No Supply

% Define time range (15)
range = A(A<15);
midpoint = range(length(range)/2);
index = find(A == midpoint);

% Test output
assert(B(index) == 0);

%% Test 2: Uncommanded On
range = A(A>=15 & A<30);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 1,'Valve not passing supply');

%% Test 3: Normal Operation On
range = A(A>=30 & A<45);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 1);

%% Test 4: Uncommanded Off
range = A(A>=45 & A<60);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 0);