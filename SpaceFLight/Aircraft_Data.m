%% 	Aircraft Data function 
%	This function was created to allow easy when coonstructing other functions
%	(e.g. Phugoid, Short period, Dutch ROll, eta.)
%	
%	Date Created: 27/10/2016
%
%	BAe Jetstream 31 Specification
%


function Aircraft_Data ()

global U_0 m S_w S_v b_w b_v I_z I_x I_y Mach AR_w AR_v l_v V_v 
global EffFac_W CL_AlphaV dSigmaBYdBeta C_nBeta_wt EffFac_V

   		
    kts2ms = 0.51444; % kts to m/s 1 = 0.51444
	
    addpath .\Cranfield_Flight_Test_Data;
    
    data1 = xlsread('Phugoid_GpA.xls');
	data2 = xlsread('Phugoid_GpB.xls');
	data3 = xlsread('Phugoid_GpC.xls');

    U1_0 = data1(1,4);
	U2_0 = data2(1,4);
	U3_0 = data3(1,4);

    U_0 = (((U1_0 + U2_0 + U3_0) / 3) * kts2ms);	% m/s, U_0 is the average speed of the phugoid
    
    Kts2Mach = 0.0015; % Knots to Mach Number convertion 1 = 0.0015
    
    Mach = U_0 * Kts2Mach;
    
   %     Ref: http://www.airlines-inform.com/commercial-aircraft/Jetstream-31.html

	% Wing Spec
    S_w = 25.083; 	% m^2, Main Wing Area
	b_w = 15.85;		% m, Main Wing Span
	AR_w = (b_w^2) / S_w; % Aspect Ratio for Main Wing
	
    % Vertical Stabiliser
    S_v = 5.639215; % m^2, Vertical Stabiliser area 
	b_v = 3.0861;   % m, Height of Verticial stabiliser
    AR_v = (b_v^2) / S_v; %  Aspect Ratio for Verticial stabiliser
    
    % Weights
    m = 6348; 		% kg, Weight of the Aircraft
	MTOW = 7350;	% kg, Max Take-off Weight of the Aircraft
	MLW = 7080;		% kg, Max Landing Weight of the Aircraft
	OEW = 4720;		% kg, Operating Empty Weight of the Aircraft
	MZFW = 6760;	% kg, Max Zero Fuel Weight of the Aircraft
	
	
	l_v = 0;		% Distance from CG to vertical Vertical Tail MAC
	V_v = 0;		% Vertical tail volume ratio
	Y1 = (b_w / 2) - ((b_w / 2) * 0.3); % Spanwise Distance from Centreline to the inboard edge of the aileron control percentage taken estimate 
	EffFac_W = Y1 / (b_w / 2); % Efficiency factor of the main wing
    Y2 = (b_v / 2) - ((b_v / 2) * 0.95); % Spanwise Distance from Centreline to the inboard edge of the rudder percentage taken estimate 
    EffFac_V = Y2 / (b_v / 2); % Efficiency factor of the Veritical Stabiliser
    
	K = -0.12;      % Value found using graph from Nelson, R Flight Stability and Automatic Control CH 3 pg 122 fig 3.12
	
	I_z = 0;		% Moment of inertia on the z axis
	I_x = 0;		% Moment of inertia on the x axis
	I_y = 0;		% Moment of inertia on the y axis
	
    CL_AlphaV = 1;
    dSigmaBYdBeta = 1;
    C_nBeta_wt = 1;
    
        
	
    % CG Calculations
    
    M_W = 6348; M_A = 5.643; M_M = M_W * M_A;
    AC_W = 4949; AC_A = 5.569; AC_Mo = AC_W * AC_A;
    StRow3_W = 60; StRow3_A = 5.400; StRow3_Mo = StRow3_W * StRow3_A;
    StRow4_W = 207; StRow4_A = 6.370; StRow4_Mo = StRow4_W * StRow4_A;
    StRow5_W = 149; StRow5_A = 7.130; StRow5_Mo = StRow5_W * StRow5_A;
    StRow6_W = 239; StRow6_A = 7.890; StRow6_Mo = StRow6_W * StRow6_A;
    CO_W = 85; CO_A = 8.550; CO_Mo = CO_W * CO_A;

    SUM_Mass = (AC_W + M_W + StRow3_W + StRow4_W + StRow5_W + StRow6_W + CO_W);
    SUM_Mom = (AC_Mo + M_M + StRow3_Mo + StRow4_Mo + StRow5_Mo + StRow6_Mo + CO_Mo);

    CG = (((SUM_Mom / SUM_Mass)-5.149)) * 100;

		
	end
