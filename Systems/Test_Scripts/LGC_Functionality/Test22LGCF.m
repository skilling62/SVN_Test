% Test 22: Extension mode failure (Critical actuator uplock fault )


if time < 15
    iv_open   = On;
    sv_down   = On;
    sv_up     = Off;
    ev_open   = Off;
    
else 
    iv_open   = Off;
    sv_down   = Off;
    sv_up     = Off;
    ev_open   = Off;
end 