% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% Test 19(LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','LGUHydrOut.time');
B = evalin ('base', 'LGUHydrOut.signals.values');

%% Test 19:  Loss of hydraulic control system ( Shuttle valve fail )

% Define time range (15)
range = A(A<15);
f = range(length(range));
index = find(A == f);

assert(B(index) == 0);