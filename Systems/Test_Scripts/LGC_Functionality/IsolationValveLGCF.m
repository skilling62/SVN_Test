% The valve position is input 1 to the combinational logic block
% Off

% iv_open is input 1

% Run tests in blocks of 15 seconds
if time < 15
    iv_open = Off;
% UncommandedOn
elseif time >= 15 && time < 30
    iv_open = Off;
% Normal
elseif time >= 30 && time < 45
    iv_open = On;
% Uncommaned On
else
    iv_open = On;
end