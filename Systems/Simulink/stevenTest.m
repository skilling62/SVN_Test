% test HydrOut

% preconditions (shared variables)
A = HydrOut.time;
B = HydrOut.signals.values;
%% Test 1: Off No Error
A_ = HydrOut.time(HydrOut.time<14);
B_ = HydrOut.signals.values(1:length(A));
assert(B_(length(B_)) == 0);