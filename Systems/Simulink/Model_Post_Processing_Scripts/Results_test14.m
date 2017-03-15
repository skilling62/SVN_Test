% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% Test 14(LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','EHydrOut.time');
B = evalin ('base', 'EHydrOut.signals.values');

%% Test 14:    Emergency hydraulic system failure (Emergency valve fail )

% Define time range (15)
range = A(A<15);
f = range(length(range));
index = find(A == f);

assert(B(index) == 0);