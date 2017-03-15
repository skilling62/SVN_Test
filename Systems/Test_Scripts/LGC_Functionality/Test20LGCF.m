% Test 20: Loss of hydraulic control system ( Hydraulic system and emergency hydraulic failure )

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