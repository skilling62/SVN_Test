%% Landing gear uplock tester script

% Inputs into the landing gear uplock come from the isolation valve, the emergencey
% vlave, the selector valve and the landing gear uplock shuttle valve. 

%%
% Run tests in blocks of 15 seconds

% Normal supply - Off 
if time < 15
   lgu_err = NoError;
   lgusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
% Error normal  supply  - Off 
elseif time >= 15 && time < 30
   lgu_err = Error;
   lgusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
% Normal supply - On 
elseif time >= 30 && time < 45
   lgu_err = NoError;
   lgusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;

% Error normal supply - On
elseif time >= 45 && time < 60
   lgu_err = Error;
   lgusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;   
end 