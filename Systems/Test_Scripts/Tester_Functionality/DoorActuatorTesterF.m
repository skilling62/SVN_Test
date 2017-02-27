%% Door Actuator tester script

% Inputs into the Door actuator come from the isolation valve, the emergencey
% vlave, the door actuator shuttle valve and thevselector valve.  
% The Door actuator has a gravity drop that will extend the doors when the uplock is unlocked.  

%%
% Run tests in blocks of 15 seconds

% Extened and retract Off Error Off 
if time < 15
   da_err = NoError;
   dasv_err= NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;  
   du_err = NoError;
   dusv_err = NoError;
% extened and retract Off Error On
elseif time >= 15 && time < 30
   da_err = Error;
   dasv_err= NoError;
    sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
   du_err = NoError;
   dusv_err = NoError;
%  Extened off Retract On Error Off 
elseif time >= 30 && time < 45
   da_err = NoError;
   dasv_err= NoError;
    sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
   du_err = NoError;
   dusv_err = NoError;
% Extened Off Retract On Error On
elseif time >= 45 && time < 60
   da_err = Error;
   dasv_err= NoError;
    sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
   du_err = NoError;
   dusv_err = NoError;
% extened On Retract Off Error Off
elseif time >= 60 && time < 75
   da_err = NoError;
   dasv_err= NoError;
    sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;   
   du_err = NoError;
   dusv_err = NoError;
% Extened On Retract Off Error On
elseif time >= 75 && time < 90
da_err = Error;
 dasv_err= NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
   du_err = NoError;
   dusv_err = NoError;   
% Extend On  Retract On Error Off
elseif time >= 90 && time < 105
   da_err = NoError;
   dasv_err= NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
   du_err = NoError;
   dusv_err = NoError;
% Extened On Retract On Error On 
elseif time >= 105 && time < 120
   da_err = Error;
   dasv_err= NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;  
   du_err = NoError;
   dusv_err = NoError;
end 