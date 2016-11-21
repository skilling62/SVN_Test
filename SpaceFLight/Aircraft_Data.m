%% 	Aircraft Data function 
%	This function was created to allow easy when coonstructing other functions
%	(e.g. Phugoid, Short period, Dutch ROll, eta.)
%	
%	Date Created: 27/10/2016
%
%	BAe Jetstream 31 Specification
%


function Aircraft_Data ()

% global m S_w S_v b_w b_v AR_w AR_v l_v V_v Y1 Y2 Cr Ct Lan q X_ac
% global EffFac_W CL_Av dEpsBYdAlpha C_nBeta_wt EffFac_V dSigmaBYdBeta
% global CM_Af CD_Uw CL_Uw

    % Name of the MAT-file that will be generated
    cfgmatfile = 'JetStream';

    gravity = 9.81; % Gravity accelartional constant m/s^-2
    Lan = 1.4; % Air Specific Constant
    %% Aircraft Specifications
    
    % Weights of Aircraft
    m = 6348; % kg, Mass of the Aircraft
    W = m * gravity; % N, Weight of the Aircraft
	MTOW = 7350;	% kg, Max Take-off Weight of the Aircraft
	MLW = 7080;		% kg, Max Landing Weight of the Aircraft
	OEW = 4720;		% kg, Operating Empty Weight of the Aircraft
	MZFW = 6760;	% kg, Max Zero Fuel Weight of the Aircraft
    
    % Lengths of Aircraft
    xm = 4.67; % Distances from the datum to the CG m
    lf = 13.446; % length of the fuselage m
    h1f = 1.992; % height of the fuselage at 1/4 length m
    h2f = h1f/2; % height of the fuselage at 3/4 length m
    wf = 1.981;  % max body width m
    Sf = 18.51;  % The Projected Side Area of the fuselage m^2
    la = 14.364; % m, Length of the aircraft
    vis = 1.694; % N.s/m^2, Assumed constant at 3000m Ref: http://www.engineeringtoolbox.com/standard-atmosphere-d_604.htm
    Swept_Chord = 3.9761; %Swept angle of the main wing
    
    Y1 = 3.61514; % m, Length from root along the trailling edge to the start of the aileron
    Y2 = 4.73708; % m, Length from root along the trailling edge to the end of the aileron
    Cr = 2.375; % m, Length of wing chord
    Ct = 0.7874; % m, Length of wing tip
    
    % Speed
    
    U_0 = Initial_Speed();
    
    Kts2Mach = 0.0015; 
    
    Mach = U_0 * Kts2Mach;
    
    
    %% Coefficients of Aircraft		
    % Main Wing
    
    data4 = xlsread('JavaFoil_MainWingData');
    CL_w = data4(:,2);
    CD_w = data4(:,3);
    Alpha = data4(:,1);
    
%     figure
%     subplot(2,1,1)
%     plot(Alpha, CL_w, 'b')
%     subplot(2,1,2)
%     plot(Alpha, CD_w, 'k')
    
    CL_0w = 0.368;
    CD_0w = 0.01852;
    CM_Ow = -0.059;      % 25% MAC
	

    CL_Uw = ((Mach)^2 / (1 - (Mach)^2)) * CL_0w;

    CL_Aw = 4.9732;

    CD_Aw = 0.008956;
    CM_Aw = -0.0014;
      
    % Horizontal Stabilisers
    CL_0h = 0.00;
    CD_0h = 0.01217;
    CM_0h = -0.00;        % 25% MAC
    
    CL_Ah = 1;
    CD_Ah = 1;
    CM_Ah = 1;
    
    % Vertical Stabilisers
    data5 = xlsread('JavaFoil_TailData');
    CL_v = data5(:,2);
    CD_v = data5(:,3);
   
%     figure
%     subplot(2,1,1)
%     plot(Alpha, CL_v, 'b')
%     subplot(2,1,2)
%     plot(Alpha, CD_v, 'k')
    
    CL_0v = 1;
    CD_0v = 1;
    CM_0v = 1;
    
    CL_Av = 1;
    CD_Av = 1;
    CM_Av = 1;
    
    CD_Uw = 1;  % !!!!!!!! Need to find !!!!!!!!

        
    % Whole Aircraft
    CM_Af = -0.3;
        
    %% Fuselage data
    X_ac = 1;   % !!!!!!!! Need to find !!!!!!!! 
    
	%% Wing Specifications
    % Main Wing
    S_w = 25.083; 	% m^2, Main Wing Area
	b_w = 15.85;	% m, Main Wing Span
    d_w = 14.351;   % m, Main Wing Length
    e_w = (b_w + d_w) / 2; % m
	AR_w = (b_w^2) / S_w; % Aspect Ratio for Main Wing
    Cbar = 1.71704;  % m, Mean Aerodynamic Chord
        
	Y1_w = (b_w / 2) - ((b_w / 2) * 0.3); % Spanwise Distance from Centreline to the inboard edge of the aileron control percentage taken estimate 
	EffFac_W = Y1_w / (b_w / 2); % Efficiency factor of the main wing
       
       
    % Vertical Stabiliser  
    S_v = 5.639215; % m^2, Vertical Stabiliser area 
	b_v = 3.0861;   % m, Height of Verticial Stabiliser
    AR_v = (b_v^2) / S_v; %  Aspect Ratio for Verticial Stabiliser
    l_v = 7.12;		% Distance from CG to vertical Stabiliser MAC
	V_v = (l_v * S_v) / (S_w * Cbar);		% Vertical Stabiliser volume ratio
    Y2_v = (b_v / 2) - ((b_v / 2) * 0.95); % Spanwise Distance from Centreline to the inboard edge of the rudder percentage taken estimate 
    EffFac_V = Y2_v / (b_v / 2); % Efficiency factor of the Veritical Stabiliser
    
    
    
    % Horizontal Stabilisers Specification
    S_h = 7.80386;  % m^2, Horizontal Stabiliser area 
    b_h = 6.64464;  % m, Span of Horizontal Stabiliser 
    AW_h = (b_h^2) / S_h;   %  Aspect Ratio for Horizontial Stabiliser
    
    %% Empirical Factors
 
% Using results from KN_factors, graph used to find the K_n Empirical factor, Found in Nelson pg 75
    KN_Factor1 = xm / lf;
    KN_Factor2 = (lf^2) / Sf;
    KN_Factor3 = sqrt(h1f / h2f);
    KN_Factor4 = h1f / wf;

    K_n = 0.0015; % Empirical Wing-bodyinterference factore that is a function of the fuselage geometry 

% Using results from V_lf, graph used to find the K_Rl Empirical factor, Found in Nelson pg 75
    V_lf = (Sf * lf) / (S_w * b_w);

    R_lf = (V_lf * vis)*10^-6;

    K_Rl = 1.2; % Empirical correction factor that is a function of the fuselage Reynolds number

    K = -0.12;      % Empirical factor for Cn_lilDelta_Aileron Nelson, R -  CH 3 pg 122 fig 3.12
    
    %% CG Calculations
    
    % Array created for the A/C Arms and Weights

    Arm_Array  =   [5.643 5.569 5.400 6.370 7.130 7.890 8.550];  
    Weight_Array = [m 4949 60 207 149 239 85];

    % Momonet are calculated using the Arm length times by the Weight at the
    % individal arm lengths
    Moment_Array = Arm_Array.* Weight_Array;

    % The Total Arm Lengths for the A/C
    Total_Arm = sum(Arm_Array, 2);

    % The Total Moment of the A/C 
    Total_Moment = sum(Moment_Array, 2);

    % The Total Weight of the A/C
    Total_Weight = sum(Weight_Array, 2); 

    % CG Calculated from the Total_Moment and Total_Weight
    CG = ((Total_Moment / Total_Weight) - 5.149) * (100/1.717);

    
    
    
    
    %% Other Parametres
    
    q = 0.75;       % !!!!!!!! Need to find !!!!!!!!
    
    C_nBeta_wt = -(K_n) * K_Rl * ((Sf * lf)/(S_w * b_w));
    
    dEpsBYdAlpha = (2 * CL_Aw) / (pi * AR_w);
    
    dSigmaBYdBeta = (S_v / S_w) / (1 + (cos(Swept_Chord))); % Change in Sidewash angle with a change in sideslip angle
    
    CM_Av = -(EffFac_V) * V_v * CL_Av * (1 - dEpsBYdAlpha); 
   
   % Medium Twin (Cessna 402) pg. 34 - FLIGHT DYNAMICS FOR MICROSOFT FLIGHT SIMULATOR
    
    R_x = 0.373;
    R_y = 0.269;
    R_z = 0.461;

    % Gravity in feet/second^2
    g = 32.2;
    
    % Calculation in slugs ft^2 and then convert to kgm^2
    I_x = ((MTOW / g) * R_x * b_w/2); % Moment of inertia on the x axis
    I_y = (((MTOW*2.20462 / g) * (R_y * ((la*3.28084)/2))^2))*1.355817962; % Moment of inertia on the x axis
    I_z = ((MTOW / g) * R_z * e_w/2); % Moment of inertia on the x axis
    
    

    %% OTHER SIMULATION PARAMETERS %%%
    
    % WMM-2000 date [day month year]
%     dmy = [13 05 2002];
 
    d = datetime('today')
    
    % Save workspace variables to MAT file
    save(cfgmatfile);

    % Output a message to the screen
    fprintf(strcat('\n Aircraft configuration saved as:\t', strcat(cfgmatfile),'.mat'));
    fprintf('\n');

	end
