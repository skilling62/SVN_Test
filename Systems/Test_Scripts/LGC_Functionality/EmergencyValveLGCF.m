
% The valve position is input 1 to the combinational logic block

% ev_open is input 1

% Run tests in blocks of 15 seconds

% Normal operation - Off 
if time < 15
    ev_open = Off;
% Uncommanded - On 
elseif time >= 15 && time < 30
    ev_open = Off;
% Normal operation - On 
elseif time >= 30 && time < 45
    ev_open = On;
% Uncommaned - Off 
else
    ev_open = On;
end