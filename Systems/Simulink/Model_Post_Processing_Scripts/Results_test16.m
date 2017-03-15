% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% Test 16(LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','EHydrOut.time');
B = evalin ('base', 'EHydrOut.signals.values');

%% Test 16:   Emergency hydraulic system failure (Hydraulic pipe block )

% Define time range (15)
range = A(A<15);
f = range(length(range));
index = find(A == f);

assert(B(index) == 0);