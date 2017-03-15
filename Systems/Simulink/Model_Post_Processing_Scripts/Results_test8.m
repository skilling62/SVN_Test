% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% Test 8(LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','LGAPos.time');
B = evalin ('base', 'LGAPos.signals.values');

%% Test 8: Critical actuator uplock fault (uplock fails to unlock)

% Define time range (15)
range = A(A<15);
f = range(length(range));
index = find(A == f);

assert(B(index) == 0);