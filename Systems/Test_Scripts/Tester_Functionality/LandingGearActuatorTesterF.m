%% Landing gear Actuator tester script

% Inputs into the landing gear actuator come from the isolation valve, the emergencey
% vlave, the landing gear actuator shuttle valve and the selector valve.  
% The landing gear actuator has a gravity drop that will extend the doors when the uplock is unlocked. 


%%
% Run tests in blocks of 15 seconds

% Extened and retract Off Error Off 
if time < 15
   lga_err = NoError;
   lgasv_err = NoError;
   lgu_err = NoError; 
   lgusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;  
% extened and retract Off Error On
elseif time >= 15 && time < 30
   lga_err = Error;
   lgasv_err = NoError;
   lgu_err = NoError; 
   lgusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError; 
%  Extened off Retract On Error Off 
elseif time >= 30 && time < 45
   lga_err = NoError;
   lgasv_err = NoError;
   lgu_err = NoError; 
   lgusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError; 
% Extened Off Retract On Error On
elseif time >= 45 && time < 60
   lga_err = Error;
   lgasv_err = NoError;
   lgu_err = NoError; 
   lgusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError; 
% extened On Retract Off Error Off
elseif time >= 60 && time < 75
   lga_err = NoError;
   lgasv_err = NoError;
   lgu_err = NoError; 
   lgusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError; 
% Extened On Retract Off Error On
elseif time >= 75 && time < 90
   lga_err = Error;
   lgasv_err = NoError;
   lgu_err = NoError; 
   lgusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;   
% Extend On  Retract On Error Off
elseif time >= 90 && time < 105
   lga_err = NoError;
   lgasv_err = NoError;
   lgu_err = NoError; 
   lgusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError; 
% Extened On Retract On Error On 
elseif time >= 105 && time < 120
   lga_err = Error;
   lgasv_err = NoError;
   lgu_err = NoError; 
   lgusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError; 
end 