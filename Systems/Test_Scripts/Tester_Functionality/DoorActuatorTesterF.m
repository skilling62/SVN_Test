%% Door Actuator tester script

% Inputs into the Door actuator come from the isolation valve, the emergencey
% vlave, the door actuator shuttle valve and thevselector valve.  
% The Door actuator has a gravity drop that will extend the doors when the uplock is unlocked.  

%%
% Run tests in blocks of 15 seconds
iv_err = NoError;
sv_err = NoError; 
% Actuator supply =Off
if time < 15
da_err  = NoError; 
du_err  = NoError; 
% Actuator supply =Off Error =ON
elseif time >= 15 && time < 30
da_err  = Error; 
du_err  = NoError; 
% Actuator Extend = On Error = Off (normal operation)
elseif time >= 30 && time < 45
da_err  = NoError; 
du_err  = NoError; 
% Actuator Retract=On Error ON  (major leakage)
elseif time >= 45 && time < 60
da_err  = Error; 
du_err  = NoError; 
% Actuator Retract = ON Error =On (up lock failiure & actuator major leakge )
elseif time >= 60 && time < 75
da_err  = Error; 
du_err  = Error; 
% Actuator Retract=On Error Off 
elseif time >= 75 && time < 175
da_err  = NoError; 
du_err  = NoError; 
% Actuator Extend = On error =Off (uplock fault)
elseif time >= 175 && time < 190
da_err  = NoError; 
du_err  = Error; 
% Actuator supply =Off Error =On (uplock failiure & Actuator jammed)
elseif time >= 190 && time < 205
da_err  = Error; 
du_err  = Error; 
% Actuator Extend = On error =ON (uplock error and jamed actuator )
elseif time >= 205 && time < 220
da_err  = Error; 
du_err  = Error; 
% Actuator Extend and Retract = On Error =Off (conflicted)
elseif time >= 220 && time < 235
da_err  = NoError; 
du_err  = NoError; 
% Actuator Extend and Retract = On Error =On (conflicted)
elseif time >= 235 && time < 250
da_err  = Error; 
du_err  = NoError;     

 % Actuator Extend =On Error =On (Actuator jammed) 
elseif time >= 250 && time < 265
da_err  = Error; 
du_err  = NoError; 
 % Actuator Retract =On Error = Off (uplock error) 
elseif time >= 265 && time < 280
da_err  = NoError; 
du_err  = Error; 
 % Actuator Supply = Off Error = Off (uplock error)
elseif time >= 280 && time < 295
da_err  = NoError; 
du_err  = Error; 
  % Actuator Extend and Retract = On Error =Off (conflicted) 
elseif time >= 295 && time < 310
 da_err  = NoError; 
du_err  = Error; 
 % Actuator Extend and Retract = On Error =ON (conflicted)
elseif time >= 310 && time < 325
da_err  = Error; 
du_err  = Error; 
end 