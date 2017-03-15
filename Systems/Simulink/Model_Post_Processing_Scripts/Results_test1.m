% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% Test 1(LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','HydrOut.time');
B = evalin ('base', 'HydrOut.signals.values');

%% Test 1: Isolation and selector valve uncomanded On

% Define time range (15)
range = A(A<15);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 1);
