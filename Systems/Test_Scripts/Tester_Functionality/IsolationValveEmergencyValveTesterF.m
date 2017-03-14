%% Landing Gear Isolation Valve Script
% Test ID:
% Test chart (I/O):
% The inputs to the Isolation Valve
% Input: Valve Open
% Input: Isolation Valve Error Injection

%%
% Run tests in blocks of 15 seconds
% Test 1: Supply = Off, Error = Off (Regular Operation Off)
if time < 15
    iv_err = NoError;
    ev_err  = NoError;
% Test 2: Supply = Off, Error = On (Uncommanded Movement to Open Position)
elseif time >= 15 && time < 30
    iv_err = Error;
    ev_err  = Error;
% Test 3: Supply = On, Error = Off (Regular Operation Off)
elseif time >= 30 && time < 45
    iv_err = NoError;
    ev_err  = NoError;
% Test 4: Supply = On, Error = On (Fails to Open)
else
    iv_err = Error;
    ev_err  = Error;
end
     
