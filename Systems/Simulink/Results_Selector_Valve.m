% This function evaluates the simulation results acheived from running the 
% following test script: 
% SelectorValve (LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','HydrOutDown.time');
B = evalin ('base', 'HydrOutDown.signals.values');
C = evalin ('base','HydrOutUp.time');
D = evalin ('base','HydrOutUp.signals.values');