% The error position is input 3 to the combinational logic block

% Run tests in blocks of 15 seconds


% Normal operation - Off 
if time < 15
    ev_err  = NoError;
% Uncommanded - On 
elseif time >= 15 && time < 30
    ev_err  = Error;
% Normal operation - On  
elseif time >= 30 && time < 45
    ev_err  = NoError;
% Uncommaned - Off 
else
    ev_err  = Error;
end
     
