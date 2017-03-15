% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% Test 18(LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','LGAHydrOut.time');
B = evalin ('base', 'LGAHydrOut.signals.values');

%% Test 18:   Loss of control system ( normal and hydraulic system fail)

% Define time range (15)
range = A(A<15);
f = range(length(range));
index = find(A == f);

assert(B(index) == 0);