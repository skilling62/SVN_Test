%% Landing gear Actuator LGCF script

% Inputs into the landing gear actuator come from the isolation valve, the emergencey
% vlave, the landing gear actuator shuttle valve and the selector valve.  
% The landing gear actuator has a gravity drop that will extend the doors when the uplock is unlocked. 

%%
% Run tests 

iv_open=On;
% Actuator supply =Off
if time < 15
   sv_down = Off;
   sv_up = Off;
% Actuator supply =Off Error =ON
elseif time >= 15 && time < 30
   sv_down = Off;
   sv_up = Off;
% Actuator Extend = On Error = Off (normal operation)
elseif time >= 30 && time < 45
   sv_down = On;
   sv_up = Off;
% Actuator Retract=On Error ON  (major leakage)
elseif time >= 45 && time < 60
   sv_down = Off;
   sv_up = On;
% Actuator Retract = ON Error =On (up lock failiure & actuator major leakge )
elseif time >= 60 && time < 75
   sv_down = Off;
   sv_up = On;
% Actuator Retract=On Error Off 
elseif time >= 75 && time < 175
   sv_down = Off;
   sv_up = On;
% Actuator Extend = On error =Off (uplock fault)
elseif time >= 175 && time < 190
   sv_down = On;
   sv_up = Off;
% Actuator supply =Off Error =On (uplock failiure & Actuator jammed)
elseif time >= 190 && time < 205
   sv_down = Off;
   sv_up = Off;
% Actuator Extend = On error =ON (uplock error and jamed actuator )
elseif time >= 205 && time < 220
   sv_down = On;
   sv_up = Off;
% Actuator Extend and Retract = On Error =Off (conflicted)
elseif time >= 220 && time < 235
   sv_down = On;
   sv_up = On;
% Actuator Extend and Retract = On Error =On (conflicted)
elseif time >= 235 && time < 250
   sv_down = On;
   sv_up = On;
 % Actuator Extend =On Error =On (Actuator jammed) 
elseif time >= 250 && time < 265
   sv_down = On;
   sv_up = Off;
 % Actuator Retract =On Error = Off (uplock error) 
elseif time >= 265 && time < 280
   sv_down = Off;
   sv_up = On;
 % Actuator Supply = Off Error = Off (uplock error)
elseif time >= 280 && time < 295
   sv_down = Off;
   sv_up = Off;
  % Actuator Extend and Retract = On Error =Off (conflicted) 
elseif time >= 295 && time < 310
   sv_down = On;
   sv_up = On;
 % Actuator Extend and Retract = On Error =ON (conflicted)
elseif time >= 310 && time < 325
   sv_down = On;
   sv_up = On;     
   
end 