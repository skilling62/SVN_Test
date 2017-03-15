% This function evaluates the simulation results acheived from running the 
% following test scripts: 
% LandingGearActuatorTesterF,DoorActuatorTesterF, LandingGearActuatorLGCF, DoorActuatorLGCF

% preconditions (shared variables)
A = evalin ('base','LGAPos.time');
B = evalin ('base', 'LGAPos.signals.values');
C = evalin ('base','DAPos.time');
D = evalin ('base','DAPos.signals.values');
%% Test 1: Actuator supply =Off 

% Define time range (15)
range = A(A<15);
midpoint = range(length(range)/2);
index = find(A == midpoint);

% Test output
assert(B(index) == 0);
assert(D(index) == 0);
%% Test 2: Actuator supply =Off Error =ON
range = A(A>=15 & A<30);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 0);
assert(D(index) == 0);
%% Test 3: Actuator Extend = On Error = Off (normal operation) 
range = A(A>=30 & A<45);
f = range(length(range));
index = find(A == f);
assert(B(index) == 100);
assert(D(index) == 100);
%% Test 4: Actuator Retract=On Error ON  (major leakage)
range = A(A>=45 & A<60);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 100);
assert(D(index) == 100);
%% Test 5: Actuator Retract = ON Error =On (up lock failiure & actuator major leakge )
range = A(A>=60 & A<75);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 100);
assert(D(index) == 100);
%% Test 6: Actuator Retract=On Error Off 
range = A(A>=75 & A<175);
f = range(length(range))+0.1;
index = find(A == f);
assert(B(index + 10) == 0);
assert(D(index + 10) == 0);
%% Test 7: Actuator Extend = On error =Off (uplock fault)
range = A(A>=175 & A<190);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 0);
assert(D(index) == 0);
%% Test 8: Actuator supply =Off Error =On (uplock failiure & Actuator jammed) 
range = A(A>=190 & A<205);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 0);
assert(D(index) == 0);
%% Test 9: Actuator Extend = On error =ON (uplock error and jamed actuator )
range = A(A>=205 & A<220);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 0);
assert(D(index) == 0);
%% Test 10: Actuator Extend and Retract = On Error =Off (conflicted)
range = A(A>=220 & A<235);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 0);
assert(D(index) == 0);
%% Test 11: Actuator Extend and Retract = On Error =On (conflicted)
range = A(A>=235 & A<250);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 0);
assert(D(index) == 0);
%% Test 12: Actuator Extend =On Error =On (Actuator jammed) 
range = A(A>=250 & A<265);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 0);
assert(D(index) == 0);
%% Test 13: Actuator Retract =On Error = Off (uplock error) 
range = A(A>=265 & A<280);
f = range(length(range));
index = find(A == f);
assert(B(index) == 100);
assert(D(index) == 100);
%% Test 14: Actuator Supply = Off Error = Off (uplock error)
range = A(A>=280 & A<295);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 100);
assert(D(index) == 100);
%% Test 15: Actuator Extend and Retract = On Error =Off (conflicted)
range = A(A>=295 & A<310);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 100);
assert(D(index) == 100);
%% Test 16: Actuator Extend and Retract = On Error =ON (conflicted)
range = A(A>=310 & A<325);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 100);
assert(D(index) == 100);