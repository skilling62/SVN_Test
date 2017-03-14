%% Landing Gear and Door Uplock Shuttle Valve LGCF Script
% Test ID:
% Test chart (I/O):
% The inputs to the Landing Gear Uplock:
% Input: Hydraulic Supply (normal or emergency)
% Input: Uplock Error injection
% To control the Uplock, the isolation and selector valves must be 
% configured to control the hyrdraulic suppy. If no commands are sent to 
% the shuttle valve, it will default to no error
%%
% Run tests in blocks of 15 seconds

% Test 1: Supply = Off, Error = Off (Regular Operation Off) 
if time < 15
   lgu_err = NoError;
   du_err = NoError;
% Test 2: Supply = Off, Error = On (Lock Unlocks) 
elseif time >= 15 && time < 30
   lgu_err = Error;
   du_err = Error;
% Test 3: Supply = On, Error = Off (Regular Operation On)
elseif time >= 30 && time < 45
   lgu_err = NoError;
   du_err = NoError;
% Test 4: Supply = On, Error = On (Fails to Unlock/Major Leakage)
elseif time >= 45 && time < 60
   lgu_err = Error;
   du_err = Error;
end 