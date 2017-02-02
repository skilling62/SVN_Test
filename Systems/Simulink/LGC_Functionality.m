
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
    
    % Test Script to Run
    IsolationValveLGCF;

end
