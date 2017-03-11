%% Landing gear uplock shuttle valve tester script

% Inputs into the landing gear uplock shuttle valve come from the isolation valve, the emergencey
% valve, the selector valve.  
% The landing gear uplock shuttle valve has an
% OR relationship so the tests below have the the normal supply (isolation
% valve and selector valve) and the emergency supply (emergency valve) are either one is ON, 
% both of them are On or both of them are Off.  

%%
% Run tests in blocks of 15 seconds

% Normal and emergency supply - Off 
if time < 15
   lgusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
% Error normal and emergency supply  - Off 
elseif time >= 15 && time < 30
   lgusv_err = Error;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
% Normal supply - On 
elseif time >= 30 && time < 45
   lgusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
% Emergency supply  - On
elseif time >= 45 && time < 60
   lgusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
% Normal and Emergency supply - On
elseif time >= 60 && time < 75
    lgusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;   
% Error normal supply - On
elseif time >= 75 && time < 90
    lgusv_err = Error;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;   
% Error emergency supply - On
elseif time >= 90 && time < 105
    lgusv_err = Error;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
% Error emergency and normal supply - On
elseif time >= 105 && time < 120
   lgusv_err = Error;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;  
end 