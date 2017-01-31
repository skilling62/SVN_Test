
function [iv_open,sv_down,sv_up,ev_open] = LGC_Functionality(time,up_down,lg_pos,door_pos,hydraulic_press)

    % Get definitions of shared constants
    run('SetConstants');

    % Instrumentation
    fprintf('Time[%f] Command[%f] LG[%f] Door[%f]\n',time,up_down,lg_pos,door_pos);
    
    % Set defaults
    iv_open   = Off;
    sv_down   = Off;
    sv_up     = Off;
    ev_open   = Off;
    
    % Some very basic functionality, for initial demo
    if(time <60) 
        iv_open = On;        
    elseif (time <120)
        iv_open = On;
    elseif (time <180)
        iv_open = Off;
    elseif (time <240)
            iv_open = Off;
    end

end
