%% Landing gear Actuator shuttle valve tester script

% Inputs into the landing gear actuator shuttle valve come from the isolation valve, the emergencey
% vlave, the selector valve.  
% The landing gear actuator shuttle valve has an
% OR relationship so the tests bellow have the the normal supply (isolation
% valve and selector valve) and the emergeney supply (emergency valve) are either one is ON, 
% both of them are On or both of them are Off.  

%%
% Run tests in blocks of 15 seconds

% Normal and emergencey supply - Off 
if time < 15
   lgasv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
% Error normal and emergencey supply  - Off 
elseif time >= 15 && time < 30
    lgasv_err = Error;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
% Normal supply - On 
elseif time >= 30 && time < 45
   lgasv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
% Emergency supply  - On
elseif time >= 45 && time < 60
   lgasv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
% Normal and Emergency supply - On
elseif time >= 60 && time < 75
    lgasv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;   
% Error normal supply - On
elseif time >= 75 && time < 90
    lgasv_err = Error;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;   
% Error emergencey supply - On
elseif time >= 90 && time < 105
    lgasv_err = Error;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
% Error emergencey and normal supply - On
elseif time >= 105 && time < 120
   lgasv_err = Error;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;  
end 