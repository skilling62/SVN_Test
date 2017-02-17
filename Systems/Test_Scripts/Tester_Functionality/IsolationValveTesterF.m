% The error position is input 2 to the combinational logic block
% Off

% Run tests in blocks of 15 seconds

if time < 15
    iv_err = NoError;
% UncommandedOn
elseif time >= 15 && time < 30
    iv_err = Error;
% Normal
elseif time >= 30 && time < 45
    iv_err = NoError;
% Uncommaned On
else
    iv_err = Error;
end
     
