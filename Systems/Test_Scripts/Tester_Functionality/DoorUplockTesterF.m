%% Door uplock tester script

% Inputs into the Door uplock come from the isolation valve, the emergencey
% vlave, the selector valve and the Door uplock shuttle valve. 

%%
% Run tests in blocks of 15 seconds

% Normal supply - Off 
if time < 15
   du_err = NoError;
   dusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
% Error normal  supply  - Off 
elseif time >= 15 && time < 30
   du_err = Error;
   dusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;
% Normal supply - On 
elseif time >= 30 && time < 45
   du_err = NoError;
   dusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;

% Error normal supply - On
elseif time >= 45 && time < 60
   du_err = Error;
   dusv_err = NoError;
   sv_err = NoError;
   ev_err = NoError;
   iv_err = NoError;   
end 