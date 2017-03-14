
function [up_down,   ...
          iv_err,    ...
          sv_err,    ...
          lga_err,   ...
          lgasv_err, ...
          lgu_err,   ...
          lgusv_err, ...
          da_err,    ...
          dasv_err,  ...
          du_err,    ...
          dusv_err,  ...
          ev_err,    ...
          hyd_norm,  ...
          hyd_emerg] = Tester_Functionality(time,lg_pos,door_pos)
      
    % Get definitions of shared constants
    run('SetConstants');

    % Instrumentation
    %fprintf('Time[%f] LG[%f] Door[%f]\n',time,lg_pos,door_pos);
    
    % Commanded LG position - default
	up_down   = Off;
    
    % Error triggering - default
    % Variables are local to this function and therefore cannot be modified
    % by another script
    
	iv_err    = NoError;
	sv_err    = NoError;
	lga_err   = NoError;
	lgasv_err = double(Errors.NoError);
	lgu_err   = NoError;
	lgusv_err = double(Errors.NoError);
	da_err    = NoError;
	dasv_err  = double(Errors.NoError);
	du_err    = NoError;
	dusv_err  = double(Errors.NoError);
	ev_err    = NoError;

    
    %% Test Script to Run
    
    % Error and Isolation Valves
%       IsolationValveEmergencyValveTesterF

    % Selector Valve
%         SelectorValveTesterF
     
     % Shuttle Valves
      ShuttleValveTesterF;

     % Uplocks
%       LGUplockDoorUplockTesterF 
     
     % Actuators


end
