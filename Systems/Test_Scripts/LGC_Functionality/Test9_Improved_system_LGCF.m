% Test 9 improved system: Critical actuator uplock fault (uplock leak)

if time < 15
    iv_open   = On;
    sv_down   = On;
    sv_up     = Off;
    ev_open   = Off;
    gravity_ext= On; 
else 
    iv_open   = Off;
    sv_down   = Off;
    sv_up     = Off;
    ev_open   = Off;
    gravity_ext= Off; 
end 