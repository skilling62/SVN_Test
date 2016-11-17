%   
%   =======================================================================
%
%   The CG_Calculations function, calculates the the Centre of gravity 
%   of the jetstream, using the data from all 3 Groups from the Cranfield
%   test flight.
%   
%   Created: 14th Novemeber 2016        Version: v1.0
%   
%   kts2ms = Knots converted to meters per second 
%   Kts2Mach = Knots converted to Mach 
%   U_0 = Initial Speed
%
%   =======================================================================
%
%


function [U_0] = Initial_Speed ()

global Mach

    kts2ms = 0.51444; % kts to m/s 1 = 0.51444
	
    addpath .\Cranfield_Flight_Test_Data;
    
    data1 = xlsread('Phugoid_GpA.xls');
	data2 = xlsread('Phugoid_GpB.xls');
	data3 = xlsread('Phugoid_GpC.xls');

    U1_0 = data1(1,4);
	U2_0 = data2(1,4);
	U3_0 = data3(1,4);
    
    
    % m/s, U_0 is the average speed of the phugoid
    U_0 = (((U1_0 + U2_0 + U3_0) / 3) * kts2ms);	
    
    
    % Knots to Mach Number convertion 1 = 0.0015
    Kts2Mach = 0.0015; 
    
    Mach = U_0 * Kts2Mach;
    
    %   Ref: http://www.airlines-inform.com/commercial-aircraft/Jetstream-31.html

end