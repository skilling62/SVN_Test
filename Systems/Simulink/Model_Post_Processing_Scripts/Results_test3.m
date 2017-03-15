% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% Test 3(LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','LGAPos.time');
B = evalin ('base', 'LGAPos.signals.values');

%% Test 3: Extension to due to inadvertent control input (test 1)

% Define time range (15)
range = A(A<15);
f = range(length(range));
index = find(A == f);

assert(B(index) == 100);
