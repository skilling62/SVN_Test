% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% Test 15(LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','EHydrOut.time');
B = evalin ('base', 'EHydrOut.signals.values');

%% Test 15:    Emergency hydraulic system failure (Hydraulic pump 2 fail )

% Define time range (15)
range = A(A<15);
f = range(length(range));
index = find(A == f);

assert(B(index) == 0);