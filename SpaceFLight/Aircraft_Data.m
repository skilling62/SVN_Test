%% 	Aircraft Data function 
%	This function was created to allow easy when coonstructing other functions
%	(e.g. Phugoid, Short period, Dutch ROll, eta.)
%	
%	Date Created: 27/10/2016
%
%	BAe Jetstream 31 Specification
%


function Aircraft_Data ()

global U_0 Q Rho m S b I_z 

   		
    kts2ms = 0.51444; % kts to m/s 1 = 0.51444
	
    addpath .\Cranfield_Flight_Test_Data;
    
    data1 = xlsread('Phugoid_GpA.xls');
	data2 = xlsread('Phugoid_GpB.xls');
	data3 = xlsread('Phugoid_GpC.xls');

    U1_0 = data1(1,4);
	U2_0 = data2(1,4);
	U3_0 = data3(1,4);

    U_0 = (((U1_0 + U2_0 + U3_0) / 3) * kts2ms);	% m/s, U_0 is the average speed of the phugoid

	

%     Ref: http://www.airlines-inform.com/commercial-aircraft/Jetstream-31.html

	m = 6348; 		% kg, Weight of the Aircraft
	S = 25.083; 	% m^2, Wing Area
	b = 15.8;		% m, Wing SPan
	
	MTOW = 7350;	% kg, Max Take-off Weight
	MLW = 7080;		% kg, Max Landing Weight
	OEW = 4720;		% kg, Operating Empty Weight
	MZFW = 6760;	% kg, Max Zero Fuel Weight
	
	
	l_v = 0;		% Distance from CG to vertical Vertical Tail MAC
	S_v = 0;		% Vertical tail Area
	V_v = 0;		% Vertical tail volume ratio
	
	
	I_z = 0;		% Moment of inertia on the z axis
	I_x = 0;		% Moment of inertia on the x axis
	I_y = 0;		% Moment of inertia on the y axis
	
	
		
	Q = 0.5 * Rho * (U_0)^2;


		
	end
