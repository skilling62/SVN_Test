%% Landing Gear and Door Uplock Shuttle Valve LGCF Script
% Test ID:
% Test chart (I/O):
% The inputs to the uplock shuttle valves:
% Input: Normal hydraulic supply (down)
% Input: Emergency hydraulic supply
% Input: Shuttle Valve Error Injection
% To control the shuttle valve, the isolation and selector valves must be
% manipulated, as well as the emergency valve
%%
% Run tests in blocks of 15 seconds
% Test 1: Emergency Supply with no errors
if time < 15
   iv_open = Off;
   sv_down = Off;
   sv_up = Off;
   ev_open = On;
% Test 2: Emergency Supply - Jammed Centre
elseif time >= 15 && time < 30
   iv_open = Off;
   sv_down = Off;
   sv_up = Off;
   ev_open = On;
% Test 3: Emergency Supply - Jammed Normal
elseif time >= 30 && time < 45
  iv_open = Off;
   sv_down = Off;
   sv_up = Off;
   ev_open = On;
% Test 4: Normal Supply with no errors
elseif time >= 45 && time < 60
   iv_open = On;
   sv_down = On;
   sv_up = Off;
   ev_open = Off;   
% Test 5: Normal Supply - Jammed Centre
elseif time >= 60 && time < 75
   iv_open = On;
   sv_down = On;
   sv_up = Off;
   ev_open = Off;   
% Test 6: Normal Supply - Jammed Normal
elseif time >= 75 && time < 90
   iv_open = On;
   sv_down = On;
   sv_up = Off;
   ev_open = Off;
% Test 7: Emergency and Normal with no errors
elseif time >= 90 && time < 105
   iv_open = On;
   sv_down = On;
   sv_up = Off;
   ev_open = On;
% Test 8: Emergency and Normal Jammed Centre
elseif time >= 105 && time < 120
   iv_open = On;
   sv_down = On;
   sv_up = Off;
   ev_open = On;
% Test 9: Emergency and Normal Jammed Normal
elseif time >= 120 && time < 135
   iv_open = On;
   sv_down = On;
   sv_up = Off;
   ev_open = On;
end 