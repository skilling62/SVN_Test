% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% DoorActuatorShuttleValve
% DoorUplockShuttleValve
% LandinggearActuatorShuttleValve
% LandinggearUplockShuttleValve

% preconditions (shared variables)
A = evalin ('base','DAHydrOut.time');
B = evalin ('base', 'DAHydrOut.signals.values');
C = evalin ('base','DUHydrOut.time');
D = evalin ('base','DUHydrOut.signals.values');
E = evalin ('base','LGAHydrOut.time');
F = evalin ('base', 'LGAHydrOut.signals.values');
G = evalin ('base','LGUHydrOut.time');
H = evalin ('base','LGUHydrOut.signals.values');

%% Test 1: Supply = Off, Error = Off

% Define time range (15)
range = A(A<15);
midpoint = range(length(range)/2);
index = find(A == midpoint);

% Test output
assert(B(index) == 0);
assert(D(index) == 0);
assert(F(index) == 0);
assert(H(index) == 0);
%% Test 2: Supply = Off, Error = On
range = A(A>=15 & A<30);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 0);
assert(D(index) == 0);
assert(F(index) == 0);
assert(H(index) == 0);
%% Test 3: Supply = On, Error = Off
range = A(A>=30 & A<45);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 1);
assert(D(index) == 1);
assert(F(index) == 1);
assert(H(index) == 1);
%% Test 4: Supply = On, Error = Off
range = A(A>=45 & A<60);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 1);
assert(D(index) == 1);
assert(F(index) == 1);
assert(H(index) == 1);
%% Test 5: Supply = On, Error = Off
range = A(A>=60 & A<75);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 1);
assert(D(index) == 1);
assert(F(index) == 1);
assert(H(index) == 1);
%% Test 6: Supply = On, Error = On
range = A(A>=75 & A<90);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 0);
assert(D(index) == 0);
assert(F(index) == 0);
assert(H(index) == 0);
%% Test 7: Supply = On, Error = On
range = A(A>=90 & A<105);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 0);
assert(D(index) == 0);
assert(F(index) == 0);
assert(H(index) == 0);
%% Test 8: Supply = On, Error = On
range = A(A>=105 & A<120);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 0);
assert(D(index) == 0);
assert(F(index) == 0);
assert(H(index) == 0);