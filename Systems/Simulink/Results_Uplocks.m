% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% DoorUplock (LGCF and Tester)
% LandinggearUplock (LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','DUPos.time');
B = evalin ('base', 'DUPos.signals.values');
C = evalin ('base','LGUPos.time');
D = evalin ('base','LGUPos.signals.values');
