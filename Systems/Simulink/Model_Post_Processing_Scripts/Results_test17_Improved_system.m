% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% Test 17 improved system(LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','LGAPos.time');
B = evalin ('base', 'LGAPos.signals.values');

%% Test 17 improved system:   Emergency hydraulic system failure (Shuttle valve jammed )

% Define time range (15)
range = A(A<=15);
f = range(length(range));
index = find(A == f);

assert(B(index) == 100);