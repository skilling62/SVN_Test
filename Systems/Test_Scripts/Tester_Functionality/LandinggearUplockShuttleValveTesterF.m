%% Landing gear Uplock shuttle valve Tester script
% Test ID:
% Test chart (I/O):
% The inputs to the uplock shuttle valves:
% Input 1: Normal hydraulic supply (down)
% Input 2: Emergency hydraulic supply
% Input 3: Shuttle Valve Error Injection
% To control the shuttle valve, the isolation and selector valves must be
% manipulated, as well as the emergency valve
%%
% Run tests in blocks of 15 seconds

% Test 1: Emergency Supply with no errors
if time < 15
   lgusv_err = double(Errors.NoError);
% Test 2: Emergency Supply - Jammed Centre
elseif time >= 15 && time < 30
   lgusv_err = double(Errors.JammedCentre);
% Test 3: Emergency Supply - Jammed Normal
elseif time >= 30 && time < 45
   lgusv_err = double(Errors.JammedNormal);
% Test 4: Normal Supply with no errors
elseif time >= 45 && time < 60
   lgusv_err = double(Errors.NoError);
% Test 5: Normal Supply - Jammed Centre
elseif time >= 60 && time < 75
   lgusv_err = double(Errors.JammedCentre);  
% Test 6: Normal Supply - Jammed Normal
elseif time >= 75 && time < 90
   lgusv_err = double(Errors.JammedNormal);
% Test 7: Emergency and Normal with no errors
elseif time >= 90 && time < 105
   lgusv_err = double(Errors.NoError);
% Test 8: Emergency and Normal Jammed Centre
elseif time >= 105 && time < 120
   lgusv_err = double(Errors.JammedCentre);
% Test 9: Emergency and Normal Jammed Normal
elseif time >= 120 && time < 135
   lgusv_err = double(Errors.JammedNormal);
end 

