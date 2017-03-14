%% Landing Gear and Door Uplock Shuttle Valve Tester Script
% Test ID:
% Test chart (I/O):
% The inputs to the selector valve:
% Input: Valve Down
% Input: Valve Up
% Input: Selector Valve Error Injection
% To control the selector valve, normal hydraulic supply is always made
% available (On and no error)
%%
% Run tests in blocks of 15 seconds

% Test 1: Selector Position = Neutral, no error (Regular Operation Off)
if time < 15
 iv_open = On; 
 sv_down = Off;
 sv_up = Off;
%  Test 2: Selector Position = Neutral, error (Uncommanded Down)
elseif time >= 15 && time < 30
 iv_open = On;
 sv_down = Off;
 sv_up = Off;
% Test 3: Selector Position = Up, no error (Regular Operation Retraction)
elseif time >= 30 && time < 45
 iv_open = On;
 sv_down = Off;
 sv_up = On; 
% Test 4: Selector Position = Up, error (Uncommanded Down)
elseif time >= 45 && time < 60
 iv_open = On;
 sv_down = Off;
 sv_up = On;
% Test 5: Selector Position = Down, no error (Regular Operation Extension)
elseif time >= 60 && time <75 
 iv_open = On;
 sv_down = On;
 sv_up = Off;
% Test 6: Selector Position = Down, error (Fails to move to the down position)
elseif time >= 75 && time <90 
 iv_open = On;
 sv_down = On;
 sv_up = Off;
% Test 7: Selector Position = Down and Up, no error (Conflicting LGC Commands)
elseif time >= 90 && time <105 
 iv_open = On;
 sv_down = On;
 sv_up = On;
% Test 8: Selector  Position = Down and Up, error (Conflicting LGC Commands)
elseif time >= 105 && time <120 
 iv_open = On;
 sv_down = On;
 sv_up = On;
end 