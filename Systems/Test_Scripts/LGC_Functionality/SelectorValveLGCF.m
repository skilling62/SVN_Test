%% Selector Valve LGCF script

% Inputs into the Selector Valve come from the isolation valve set On (constant hydrualics supply) and position
% is comanded using SV_Up and SV_down. 

%%
% Run tests in blocks of 15 seconds

% SV_Up and SV_down = Off Error = Off
if time < 15
 iv_open = On; 
 sv_down = Off;
 sv_up = Off;
%  SV_Up and SV_down = Off Error = On 
elseif time >= 15 && time < 30
 iv_open = On;
 sv_down = Off;
 sv_up = Off;
% SV_Up = On Error= Off
elseif time >= 30 && time < 45
 iv_open = On;
 sv_down = Off;
 sv_up = On; 
% SV_Up = On Error = On 
elseif time >= 45 && time < 60
 iv_open = On;
 sv_down = Off;
 sv_up = On;
% SV_down = On Error = Off
elseif time >= 60 && time <75 
 iv_open = On;
 sv_down = On;
 sv_up = Off;
% SV_down = On Error = On 
elseif time >= 75 && time <90 
 iv_open = On;
 sv_down = On;
 sv_up = Off;
%SV_Up and SV_down = On Error = Off
elseif time >= 90 && time <105 
 iv_open = On;
 sv_down = On;
 sv_up = On;
% SV_Up and SV_down = On Error = On 
elseif time >= 105 && time <120 
 iv_open = On;
 sv_down = On;
 sv_up = On;
end 