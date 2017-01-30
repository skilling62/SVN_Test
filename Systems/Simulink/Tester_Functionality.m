%% 
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
          ev_err] = Tester_Functionality(time,lg_pos,door_pos)
      
    % Get definitions of shared constants
    run('SetConstants');

    % Instrumentation
    fprintf('Time[%f] LG[%f] Door[%f]\n',time,lg_pos,door_pos);
    
    % Commanded LG position - default
	up_down   = Off;
    
    % Error triggering - default
	iv_err    = NoError;
	sv_err    = NoError;
	lga_err   = NoError;
	lgasv_err = NoError;
	lgu_err   = NoError;
	lgusv_err = NoError;
	da_err    = NoError;
	dasv_err  = NoError;
	du_err    = NoError;
	dusv_err  = NoError;
	ev_err    = NoError;
    
    % Some very basic functionality, for initial demo
    if(time < 60)
        up_down = On;
        iv_err  = Error; 
    else
        up_down = Off;
        iv_err  = NoError; 
    end

end
