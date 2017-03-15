% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% Test 21(LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','LGAPos.time');
B = evalin ('base', 'LGAPos.signals.values');

%% Test 21:   Extension mode failure (Loss of hydraulic system)

% Define time range (15)
range = A(A<15);
f = range(length(range));
index = find(A == f);

assert(B(index) == 0);