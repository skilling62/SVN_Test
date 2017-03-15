%Test 18: Loss of control system ( normal and hydraulic system fail)

if time < 15
    iv_open   = On;
    sv_down   = On;
    sv_up     = Off;
    ev_open   = On;
    
else 
    iv_open   = Off;
    sv_down   = Off;
    sv_up     = Off;
    ev_open   = Off;
end 