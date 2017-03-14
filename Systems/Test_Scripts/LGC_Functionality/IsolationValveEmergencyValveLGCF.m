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
    iv_open = Off;
    ev_open = Off;
% Test 2: Supply = Off, Error = On (Uncommanded Movement to Open Position)
elseif time >= 15 && time < 30
    iv_open = Off;
    ev_open = Off;
% Test 3: Supply = On, Error = Off (Regular Operation Off)
elseif time >= 30 && time < 45
    iv_open = On;
    ev_open = On;
% Test 4: Supply = On, Error = On (Fails to Open)
else
    iv_open = On;
    ev_open = On;
end