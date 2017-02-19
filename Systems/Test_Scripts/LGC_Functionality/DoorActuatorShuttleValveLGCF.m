%% Door Actuator shuttle valve LGCF script

% Same inputs as Door uplock shuttle valve becuase they are conected 
% Inputs into the landing gear actuator shuttle valve come from the isolation valve, the emergencey
% vlave, the selector valve.  
% The Door actuator shuttle valve has an
% OR relationship so the tests bellow have the the normal supply (isolation
% valve and selector valve) and the emergeney supply (emergency valve) are either one is ON, 
% both of them are On or both of them are Off.  

%%
% Run tests in blocks of 15 seconds

% Normal supply - Off 
if time < 15
   iv_open = Off;
   sv_down = Off;
   sv_up = Off;
   ev_open = Off;
% Error normal and emergencey supply  - Off 
elseif time >= 15 && time < 30
   iv_open = Off;
   sv_down = Off;
   sv_up = Off;
   ev_open = Off;
% Normal supply - On 
elseif time >= 30 && time < 45
  iv_open = On;
   sv_down = On;
   sv_up = Off;
   ev_open = Off;
% Emergency supply  - On
elseif time >= 45 && time < 60
   iv_open = Off;
   sv_down = Off;
   ev_open = On;
% Normal and Emergency supply - On
elseif time >= 60 && time < 75
   iv_open = On;
   sv_down = On;
   sv_up = Off;
   ev_open = On;   
% Error normal supply - On
elseif time >= 75 && time < 90
   iv_open = On;
   sv_down = On;
   sv_up = Off;
   ev_open = Off;   
% Error emergencey supply - On
elseif time >= 90 && time < 105
   iv_open = Off;
   sv_down = Off;
   sv_up = Off;
   ev_open = On;
% Error emergencey and normal supply - On
elseif time >= 105 && time < 120
   iv_open = On;
   sv_down = On;
   sv_up = Off;
   ev_open = On;   
end 