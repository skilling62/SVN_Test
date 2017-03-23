%Test 17 improved system: Emergency hydraulic system failure (Shuttle valve jammed )

if time < 15
    iv_open   = Off;
    sv_down   = Off;
    sv_up     = Off;
    ev_open   = On;
    
    if sv_fail==On
        gravity_ext=On;
    else 
        gravity_ext=Off;
    end
    
else 
    iv_open   = Off;
    sv_down   = Off;
    sv_up     = Off;
    ev_open   = Off;
end 