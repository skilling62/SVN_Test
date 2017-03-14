% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% LGUplockDoorUplock(LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','DUPos.time');
B = evalin ('base', 'DUPos.signals.values');
C = evalin ('base','LGUPos.time');
D = evalin ('base','LGUPos.signals.values');

%% Test 1: Supply = Off, Error = Off (Regular Operation Off)

% Define time range (15)
range = A(A<15);
midpoint = range(length(range)/2);
index = find(A == midpoint);

% Test output
assert(B(index) == 0);
assert(D(index) == 0);
%% Test 2: Supply = Off, Error = On (Lock Unlocks)
range = A(A>=15 & A<30);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 1);
assert(D(index) == 1);
%% Test 3: Supply = On, Error = Off (Regular Operation On)
range = A(A>=30 & A<45);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 1);
assert(D(index) == 1);
%% Test 4: Supply = On, Error = On (Fails to Unlock/Major Leakage)
range = A(A>=45 & A<60);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 0);
assert(D(index) == 0);
