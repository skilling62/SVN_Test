% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% Test 9(LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','LGAPos.time');
B = evalin ('base', 'LGAPos.signals.values');

%% Test 9: Critical actuator uplock fault (uplock leak)

% Define time range (15)
range = A(A<15);
f = range(length(range));
index = find(A == f);

assert(B(index) == 0);