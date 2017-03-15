% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% Test 2(LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','EHydrOut.time');
B = evalin ('base', 'EHydrOut.signals.values');

%% Test 2: emergency valve uncomanded On

% Define time range (15)
range = A(A<15);
midpoint = range(length(range)/2);
index = find(A == midpoint);

assert(B(index) == 1);
