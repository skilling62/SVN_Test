%Test 17: Emergency hydraulic system failure (Shuttle valve jammed )

if time < 15
    iv_open   = Off;
    sv_down   = Off;
    sv_up     = Off;
    ev_open   = On;
    
else 
    iv_open   = Off;
    sv_down   = Off;
    sv_up     = Off;
    ev_open   = Off;
end 