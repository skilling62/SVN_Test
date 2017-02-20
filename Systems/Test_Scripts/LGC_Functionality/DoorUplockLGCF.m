%% Door uplock LGCF script

% Inputs into the Door uplock come from the isolation valve, the emergencey
% vlave, the selector valve and the Door uplock shuttle valve.
% tests identical to landing gear uplock because they are connected. 

%%
% Run tests in blocks of 15 seconds

% Normal supply = Off 
if time < 15
   iv_open = Off;
   sv_down = Off;
   sv_up = Off;
   ev_open = Off;
% Error and supply = Off 
elseif time >= 15 && time < 30
   iv_open = Off;
   sv_down = Off;
   sv_up = Off;
   ev_open = Off;
% Normal supply = On 
elseif time >= 30 && time < 45
  iv_open = On;
   sv_down = On;
   sv_up = Off;
   ev_open = Off;   
% Error normal supply = On
elseif time >= 45 && time < 60
   iv_open = On;
   sv_down = On;
   sv_up = Off;
   ev_open = Off;   
end 