% This function evaluates the simulation results acheived from running the 
% following test script: 
% SelectorValve (LGCF and Tester)

% preconditions (shared variables)
A = evalin ('base','HydrOutDown.time');
B = evalin ('base', 'HydrOutDown.signals.values');
C = evalin ('base','HydrOutUp.time');
D = evalin ('base','HydrOutUp.signals.values');

%% Test 1: Selector Position = Neutral, Hydraulic Supply = On, (Regular Operation Off)

% Define time range (15)
range = A(A<15);
midpoint = range(length(range)/2);
index = find(A == midpoint);

% Test output
assert(B(index) == 0);
assert(D(index) == 0);

%% Test 2: Selector Position = Neutral(+Error), Hydraulic Supply = On, (Uncommanded Down)
range = A(A>=15 & A<30);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 1);
assert(D(index) == 0);

%% Test 3: Selector Position = Up, Hydraulic Supply = On, (Regular Operation Retraction)
range = A(A>=30 & A<45);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 0);
assert(D(index) == 1);

%% Test 4: Selector Position = Up(+Error), Hydraulic Supply = On, (Extension Error)
range = A(A>=45 & A<60);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 0);
assert(D(index) == 0);

%% Test 5: Selector Position = Down, Hydraulic Supply = On, (Regular Operation Extension)
range = A(A>=60 &A<75);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 1);
assert(D(index) == 0);

%% Test 6: Selector Position = Down(+Error), Hydraulic Supply = On, (Fails to move to the down position)
range = A(A>=75 & A<90);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 0);
assert(D(index) == 0);
%% Test 7: Selector Position = Down and Up, Hydraulic Supply = On, (Conflicting LGC Commands)
range = A(A>=90 & A<105);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 0);
assert(D(index) == 0);

%% Test 8: Selector Position = Down and Up (+Error), Hydraulic Supply = On, (Conflicting LGC Commands)
range = A(A>=105 & A<120);
midpoint = range(length(range)/2);
index = find(A == midpoint);
assert(B(index) == 0);
assert(D(index) == 0);
