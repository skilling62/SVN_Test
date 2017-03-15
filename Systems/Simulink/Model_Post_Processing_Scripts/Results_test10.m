% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% Test 10(LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','HydrOut.time');
B = evalin ('base', 'HydrOut.signals.values');

%% Test 10:  Hydraulic system failure (isolation failiure)

% Define time range (15)
range = A(A<15);
f = range(length(range));
index = find(A == f);

assert(B(index) == 0);