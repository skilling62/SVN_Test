% This function is called from the S_Fun block. Therefore it is sampled
% throughout the simulation of the model

function [iv_open,sv_down,sv_up,ev_open] = LGC_Functionality(time,up_down,lg_pos,door_pos,hydraulic_press)

    % Get definitions of shared constants
    run('SetConstants');

    % Instrumentation
    %fprintf('Time[%f] Command[%f] LG[%f] Door[%f]\n',time,up_down,lg_pos,door_pos);
    
    % Display outputs as an array as this will make them easier to analyse
    Out = [time up_down lg_pos door_pos];
    %disp(Out);
    
    % Set defaults
    % Locally defined so cannot be modified by another script
    iv_open   = Off;
    sv_down   = Off;
    sv_up     = Off;
    ev_open   = Off;
    
    %% Test script to run
    
    % Error and Isolation Valves
%     IsolationValveLGCF;
%     EmergencyValveLGCF;
%     
    % Shuttle Valves
%     ShuttleValveLGCF;

%     Uplocks
%     DoorUplockLGCF;
%     LandinggearUplockLGCF;
    
    % Actuators
    
    
    
end
