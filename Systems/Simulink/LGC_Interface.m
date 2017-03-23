function LGC_Interface(block)
    setup(block);
end

%% Function: setup ===================================================
function setup(block)

    % Register number of ports
    block.NumInputPorts  = 6;
    block.NumOutputPorts = 5;

    % Setup port properties to be inherited or dynamic
    block.SetPreCompPortInfoToDefaults;
    block.SetPreCompPortInfoToDefaults;

    % Override input port properties
    for i = 1:block.NumInputPorts
        block.InputPort(i).Dimensions  = 1;
        block.InputPort(i).DatatypeID  = 0;  % double
        block.InputPort(i).Complexity  = 'Real';
        block.InputPort(i).DirectFeedthrough = true;
    end

    % Override output port properties
    for i = 1:block.NumOutputPorts
        block.OutputPort(i).Dimensions  = 1;
        block.OutputPort(i).DatatypeID  = 0; % double
        block.OutputPort(i).Complexity  = 'Real';
    end

    % Register parameters etc
    block.NumDialogPrms     = 0;
    block.SampleTimes = [0 0];
    block.SimStateCompliance = 'DefaultSimState';

    %% Register methods
    block.RegBlockMethod('Outputs', @Outputs);

end

%% Outputs:
function Outputs(block)
    [block.OutputPort(1).Data,   ...
     block.OutputPort(2).Data,   ...
     block.OutputPort(3).Data,   ...
     block.OutputPort(4).Data, ...
     block.OutputPort(5).Data] = ...
       LGC_Functionality(block.InputPort(1).Data, ...
                         block.InputPort(2).Data, ...
                         block.InputPort(3).Data, ...
                         block.InputPort(4).Data, ...
                         block.InputPort(5).Data, ...
                         block.InputPort(6).Data);

end


