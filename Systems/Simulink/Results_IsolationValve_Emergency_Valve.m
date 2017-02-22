% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% IsolationValve
% EmergencyValve

% preconditions (shared variables)
A = evalin ('base','HydrOut.time');
B = evalin ('base', 'HydrOut.signals.values');
C = evalin ('base','EHydrOut.time');
D = evalin ('base','EHydrOut.signals.values');
%% Test 1: Supply = Off, Error = Off

% Define time range (15)
range = A(A<15);
midpoint = range(length(range)/2);
index = find(A == midpoint);

% Test output
assert(B(index) == 0);
assert(D(index) == 0);
%% Test 2: Supply = Off, Error = On
range = A(A>=15 & A<30);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 1,'Valve not passing supply');
assert(D(index) == 1);
%% Test 3: Supply = On, Error = Off
range = A(A>=30 & A<45);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 1);
assert(D(index) == 1);
%% Test 4: Supply = On, Error = On
range = A(A>=45 & A<60);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 0);
assert(D(index) == 0);