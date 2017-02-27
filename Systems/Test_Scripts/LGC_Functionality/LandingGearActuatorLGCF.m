%% Landing gear Actuator LGCF script

% Inputs into the landing gear actuator come from the isolation valve, the emergencey
% vlave, the landing gear actuator shuttle valve and the selector valve.  
% The landing gear actuator has a gravity drop that will extend the doors when the uplock is unlocked. 

%%
% Run tests in blocks of 15 seconds

% Extened and retract Off Error Off  
if time < 15
   iv_open = Off;
   sv_down = Off;
   sv_up = Off;
   ev_open = Off;
% extened and retract Off Error On
elseif time >= 15 && time < 30
   iv_open = Off;
   sv_down = Off;
   sv_up = Off;
   ev_open = Off;
% Extened off Retract On Error Off 
elseif time >= 30 && time < 45
  iv_open = On;
   sv_down = Off;
   sv_up = On;
   ev_open = Off;
% Extened Off Retract On Error On
elseif time >= 45 && time < 60
   iv_open = On;
   sv_down = Off;
    sv_up = On;
   ev_open = Off;
% extened On Retract Off Error Off
elseif time >= 60 && time < 75
   iv_open = On;
   sv_down = On;
   sv_up = Off;
   ev_open = Off;   
% Extened On Retract Off Error On
elseif time >= 75 && time < 90
   iv_open = On;
   sv_down = On;
   sv_up = Off;
   ev_open = Off;   
% Extend On  Retract On Error Off
elseif time >= 90 && time < 105
   iv_open = On;
   sv_down = On;
   sv_up = On;
   ev_open = Off;
% Extened On Retract On Error On 
elseif time >= 105 && time < 120
   iv_open = On;
   sv_down = On;
   sv_up = On;
   ev_open = Off;   
end 