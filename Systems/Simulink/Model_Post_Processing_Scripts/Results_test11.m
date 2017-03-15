% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% Test 11(LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','HydrOutDown.time');
B = evalin ('base', 'HydrOutDown.signals.values');

%% Test 11:   Hydraulic system failure (Selector valve fail )

% Define time range (15)
range = A(A<15);
f = range(length(range));
index = find(A == f);

assert(B(index) == 0);