% test HydrOut

% preconditions (shared variables)
A = evalin ('base','HydrOut.time');
B = evalin ('base', 'HydrOut.signals.values');
%% Test 1: Time at t=0
assert(A(1) == 0, 'time at t=0 is not 0')

%% Test 2: Value at t=0
assert(B(1) == 5,'invalid value for HydrOut')