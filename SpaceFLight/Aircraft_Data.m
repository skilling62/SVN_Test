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
global EffFac_W CL_Av dEpsBYdAlpha C_nBeta_wt EffFac_V

    % Name of the MAT-file that will be generated
    cfgmatfile = 'JetStream';

    %% Aircraft Specifications
    
    % Weights of Aircraft
    m = 6348; 		% kg, Weight of the Aircraft
	MTOW = 7350;	% kg, Max Take-off Weight of the Aircraft
	MLW = 7080;		% kg, Max Landing Weight of the Aircraft
	OEW = 4720;		% kg, Operating Empty Weight of the Aircraft
	MZFW = 6760;	% kg, Max Zero Fuel Weight of the Aircraft
    
    %% Coefficients of Aircraft		
    % Main Wing
    
    data4 = xlsread('JavaFoil_MainWingData');
    CL_w = data4(:,2);
    CD_w = data4(:,3);
    Alpha = data4(:,1);
    
    figure
    subplot(2,1,1)
    plot(Alpha, CL_w, 'b')
    subplot(2,1,2)
    plot(Alpha, CD_w, 'k')
    
    CL_0w = 0.368;
    CD_0w = 0.01852;
    CM_Ow = -0.059;      % 25% MAC
	
    CL_Aw = 0.0788;
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
   
    figure
    subplot(2,1,1)
    plot(Alpha, CL_v, 'b')
    subplot(2,1,2)
    plot(Alpha, CD_v, 'k')
    
    CL_0v = 1;
    CD_0v = 1;
    CM_0v = 1;
    
    CL_Av = 1;
    CD_Av = 1;
    CM_Av = 1;
    
        
    %% Fuselage data
    K_n = 1;    % Empirical wing-body interference factor tha is a function of the fuselage geometry
    K_RL = 1;   % Empirical correction factor that is a function of the fuselage Reynolds Number
    S_fs = 1;   % The projected side area of the fuselage
    L_f = 1;    % Length of the fuselage
    
    
	%% Wing Specifications
    % Main Wing
    S_w = 25.083; 	% m^2, Main Wing Area
	b_w = 15.85;	% m, Main Wing Span
    d_w = 14.351;   % m, Main Wing Length
    e_w = (b_w + d_w) / 2; % m
	AR_w = (b_w^2) / S_w; % Aspect Ratio for Main Wing
    Cbar = 1.71704;  % m, Mean Aerodynamic Chord
        
	Y1 = (b_w / 2) - ((b_w / 2) * 0.3); % Spanwise Distance from Centreline to the inboard edge of the aileron control percentage taken estimate 
	EffFac_W = Y1 / (b_w / 2); % Efficiency factor of the main wing
    K = -0.12;      % Empirical factor for Cn_lilDelta_Aileron Nelson, R -  CH 3 pg 122 fig 3.12
    
       
    % Vertical Stabiliser  
    S_v = 5.639215; % m^2, Vertical Stabiliser area 
	b_v = 3.0861;   % m, Height of Verticial Stabiliser
    AR_v = (b_v^2) / S_v; %  Aspect Ratio for Verticial Stabiliser
    l_v = 0;		% Distance from CG to vertical Stabiliser MAC
	V_v = (l_v * S_v) / (S_w * Cbar);		% Vertical Stabiliser volume ratio
    Y2 = (b_v / 2) - ((b_v / 2) * 0.95); % Spanwise Distance from Centreline to the inboard edge of the rudder percentage taken estimate 
    EffFac_V = Y2 / (b_v / 2); % Efficiency factor of the Veritical Stabiliser
    CM_Av = -(EffFac_V) * V_v * CL_Av * (1 - dEpsBYdAlpha); 
    
    
    % Horizontal Stabilisers Specification
    S_h = 7.80386;  % m^2, Horizontal Stabiliser area 
    b_h = 6.64464;  % m, Span of Horizontal Stabiliser 
    AW_h = (b_h^2) / S_h;   %  Aspect Ratio for Horizontial Stabiliser
      
    %% Other Parametres
    
    C_nBeta_wt = -(K_n) * K_RL * ((S_fs * L_f)/(S_w * b_w));
    
    dEpsBYdAlpha = (2 * CL_Aw) / (pi * AR_w);
    Sweep_25Chord = 1
    dSigmaBYdBeta = (S_v / S_w) / (1 + (cos(Sweep_25Chord)));  
    
    
		
    %%  Moments of Inertia Calulations
    
    % Medium Twin (Cessna 402) pg. 34 - FLIGHT DYNAMICS FOR MICROSOFT FLIGHT SIMULATOR
    R_x = 0.373;
    R_y = 0.269;
    R_z = 0.461;
    
    g = 32.2;
    
    I_x = ((MTOW / g) * R_x * b_w/2); % Moment of inertia on the x axis
    I_y = ((MTOW / g) * R_y * d_w/2); % Moment of inertia on the x axis
    I_z = ((MTOW / g) * R_z * e_w/2); % Moment of inertia on the x axis
    
    
    %% OTHER SIMULATION PARAMETERS %%%
    
    % WMM-2000 date [day month year]
    dmy = [13 05 2002];
 
%     d = datetime('today')
    
    % Save workspace variables to MAT file
    save(cfgmatfile);

    % Output a message to the screen
    fprintf(strcat('\n Aircraft configuration saved as:\t', strcat(cfgmatfile),'.mat'));
    fprintf('\n');

	end
