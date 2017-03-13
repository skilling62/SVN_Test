% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% ShuttleValve (LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','DAHydrOut.time');
B = evalin ('base', 'DAHydrOut.signals.values');
C = evalin ('base','DUHydrOut.time');
D = evalin ('base','DUHydrOut.signals.values');
E = evalin ('base','LGAHydrOut.time');
F = evalin ('base', 'LGAHydrOut.signals.values');
G = evalin ('base','LGUHydrOut.time');
H = evalin ('base','LGUHydrOut.signals.values');

%% Test 1: Emergency Supply with no errors

% Define time range (15)
range = A(A<15);
midpoint = range(length(range)/2);
index = find(A == midpoint);

% Test output
assert(B(index) == 1);
assert(D(index) == 1);
assert(F(index) == 1);
assert(H(index) == 1);
%% Test 2: Emergency Supply - Jammed Centre
range = A(A>=15 & A<30);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 0);
assert(D(index) == 0);
assert(F(index) == 0);
assert(H(index) == 0);
%% Test 3: Emergency Supply - Jammed Normal
range = A(A>=30 & A<45);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 0);
assert(D(index) == 0);
assert(F(index) == 0);
assert(H(index) == 0);
%% Test 4: Normal Supply with no errors
range = A(A>=45 & A<60);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 1);
assert(D(index) == 1);
assert(F(index) == 1);
assert(H(index) == 1);
%% Test 5: Normal Supply - Jammed Centre
range = A(A>=60 & A<75);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 0);
assert(D(index) == 0);
assert(F(index) == 0);
assert(H(index) == 0);
%% Test 6: Normal Supply - Jammed Normal
range = A(A>=75 & A<90);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 1);
assert(D(index) == 1);
assert(F(index) == 1);
assert(H(index) == 1);
%% Test 7: Emergency and Normal with no errors
range = A(A>=90 & A<105);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 1);
assert(D(index) == 1);
assert(F(index) == 1);
assert(H(index) == 1);
%% Test 8: Emergency and Normal Jammed Centre
range = A(A>=105 & A<120);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 0);
assert(D(index) == 0);
assert(F(index) == 0);
assert(H(index) == 0);
%% Test 9: Emergency and Normal Jammed Normal
range = A(A>=120 & A<135);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 1);
assert(D(index) == 1);
assert(F(index) == 1);
assert(H(index) == 1);