%% 	Aircraft Data function 
%	This function was created to allow easy when constructing other functions
%	(e.g. Phugoid, Short period, Dutch ROll, eta.)
%	
%	Date Created: 27/10/2016
%
%	BAe Jetstream 31 Specification
%


function Aircraft_Data ()

    addpath .\SupportingDocs
    addpath .\Cranfield_Flight_Test_Data;
    
%% ========================= Mat-File =====================================
    
% -------------------------------------------------------------------------   
    cfgmatfile = 'JetStream';        % Generating a JetStream MAT-file to be used throughout all caluations of all modes
% ------------------------------------------------------------------------- 
    
    
%% ========================= Constants ====================================

% ------------------------------------------------------------------------- 
    gravity = 9.81;                     % Gravity accelartional constant m/s^-2
    Lan = 1.4;                          % Air Specific Constant
    vis = 1.694;                        % N.s/m^2, Assumed constant at 3000m Ref: http://www.engineeringtoolbox.com/standard-atmosphere-d_604.htm
% ------------------------------------------------------------------------- 
    
%% ========================================================================
% -.-.-.-.-.-.-.-.-.-.- Aircraft Specifications -.-.-.-.-.-.-.-.-.-.-.-.-.-
% =========================================================================


% ========================== Weights of Aircraft ==========================

% -------------------------------------------------------------------------
    m = 6348;                           % kg, Mass of the Aircraft
    W = m * gravity;                    % N, Weight of the Aircraft
	MTOW = 7350;                        % kg, Max Take-off Weight of the Aircraft
	MLW = 7080;                         % kg, Max Landing Weight of the Aircraft
	OEW = 4720;                         % kg, Operating Empty Weight of the Aircraft
	MZFW = 6760;                        % kg, Max Zero Fuel Weight of the Aircraft
% -------------------------------------------------------------------------    


% ========================== Lengths of Aircraft ==========================
    
% --------------------------- Fuselage ------------------------------------
    lf = 13.1875;                       % length of the fuselage m
    hf = 1.775;                         % height of the fuselage
    h1f = 2.038446372;                  % height of the fuselage at 1/4 length m
    h2f = 1.788840694;                  % height of the fuselage at 3/4 length m
    wf = 1.825;                         % max body width m
    Sf = 18.51;                         % The Projected Side Area of the fuselage m^2
    la = 14.364;                        % m, Length of the aircraft
    CentreLine_f = 6.126934;            % m, Fuselage Centreline
% -------------------------------------------------------------------------
    
% --------------------------- Main Wing -----------------------------------
    Swept_Angle = 3.9761 * (pi / 180);  %Swept angle of the main wing
    Y1 = 3.61514;                       % m, Length from root along the trailling edge to the start of the aileron
    Y2 = 4.73708;                       % m, Length from root along the trailling edge to the end of the aileron
    Cr = 2.3375;                        % m, Length of wing chord
    Ct = 0.775;                         % m, Length of wing tip
    S_w = 25.0838208;                   % m^2, Main Wing Area
	b_w = 15.6;                         % m, Main Wing Span
    e_w = (b_w + la) / 2;               % m, Main Wing Span + Length of Aircract divided by 2
	Cbar = 1.72;                        % m, Mean Aerodynamic Chord (5ft7.6 inches, from POH p.4)
    Gamma = 7 * (pi / 180);             % Degress changed to Rads, From the POH, Wing Dihedral Angle
% -------------------------------------------------------------------------    
   
% ------------------------- Vertical Stabiliser ---------------------------
    b_v = 3.0375;                       % m, Vertical Stabiliser span from the Fuselage
    b_Totv = 5.2375;                    % m, Vertical Stabiliser Overall span  
    S_v = 5.639214528;                  % m^2, Vertical Stabiliser area 
    Cr_v = 1.4375;                      % m, Vertical Stabiliser Root Chord
    Cp_v = Cr_v * 0.25;                 % m, Location of the Centre of Pressure for the Vertical Stabiliser
    Cr = 0.669;
    Cf = 1.910;
    
    % Calculate the Control surface area/lifting surface area Paremeter (Cook p56)
    Vcontrol_surface = 0.669/1.910;
    % Determine graphically the flap effectiveness parameter (tau) from
    % Nelson p64
    tau_r = 0.5;
% -------------------------------------------------------------------------
    
% -------------------------- Horizontal Stabilier -------------------------
    S_h = 7.80385536;                   % m^2, Horizontal Stabiliser area 
    b_h = 6.5;                          % m, Span of Horizontal Stabiliser
    Cr_h = 1.65;                        % m, Horizontal Stabiliser Root Chord
    Ct_h = 0.675;                       % m, Horizontal Stabiliser Tip Chord
    
  
% -------------------------------------------------------------------------    


% ======================== Distances of Aircraft ==========================

% ---------------------------- Fuselage -----------------------------------
    xm = 4.2889; % Distances from the datum to the CG m
% -------------------------------------------------------------------------
    
% ---------------------------- Main Wing ----------------------------------
    Y1_w = (b_w / 2) - ((b_w / 2) * 0.3);   % Spanwise Distance from Centreline to the inboard edge of the aileron control percentage taken estimate 
    X_ac = Cbar / 4;                        % Aerodynamic Centre 1/4 MAC Distances 
% -------------------------------------------------------------------------
    
% -------------------------- Vertical Stabiliser --------------------------
    l_v = 7.12;                             % Distance from CG to vertical Stabiliser MAC
    z_u = 6.134134426;                      % m, Distance from centre of pressure of the vertical tail to the fuselage centreline 
% -------------------------------------------------------------------------


% ======================== Ratios of Aircraft =============================

% ----------------------------- Main Wing ---------------------------------
    Lander = Ct / Cr;                       % Taper Ratio (tip chord/root chord) for the Main Wing
    AR_w = (b_w^2) / S_w;                   % Aspect Ratio for Main Wing
    EffFac_W = Y1_w / (b_w / 2);            % Efficiency factor of the main wing 
% -------------------------------------------------------------------------
    
% ---------------------------- Vertical Stabiliser ------------------------
    AR_v = (b_v^2) / S_v;                   %  Aspect Ratio for Verticial Stabiliser
	V_v = (l_v * S_v) / (S_w * Cbar);       % Vertical Stabiliser volume ratio
    EffFac_V = 1;                           % Efficiency factor of the Vertical Stabiliser
% -------------------------------------------------------------------------
    
% ---------------------------- Horizontal Stabilier -----------------------
    AR_h = (b_h^2) / S_h;                   %  Aspect Ratio for Horizontial Stabiliser
% -------------------------------------------------------------------------


% ============== Moment of Inertia for the Aircraft =======================

% -------------------------------------------------------------------------
%   Medium Twin (Cessna 402) [close approx as there are no R_ given for a JetStream 31] 
%   pg. 34 - FLIGHT DYNAMICS FOR MICROSOFT FLIGHT SIMULATOR
    
    R_x = 0.373;
    R_y = 0.269;
    R_z = 0.461;
    
    g = 32.2; % Gravity in feet/second^2
    
%   Calculation in slugs ft^2 and then convert to kgm^2
    I_x = (((MTOW*2.20462 / g) * (R_x * ((b_w * 3.28084) / 2))^2)) * 1.355817962; 
    I_y = ((MTOW*2.20462 / g) * (R_y * (la * 3.28084/2))^2) * 1.355817962;
    I_z = (((MTOW*2.20462 / g) * (R_z * ((e_w * 3.28084)/2))^2)) * 1.355817962;     
% -------------------------------------------------------------------------


% ================= Empirical Factors of the Aircraft =====================

% -------------------------------------------------------------------------
%   Using results from KN_factors, graph used to find the K_n Empirical factor, Found in Nelson pg 75
    
    KN_Factor1 = xm / lf;                   % Distances from the datum to the CG Divided by the Fuselage Length
    KN_Factor2 = (lf^2) / Sf;               % Fuselage Length all Squared Divided by the Projected Side Area of the fuselage
    KN_Factor3 = sqrt(h1f / h2f);           % Square rooted values of the 1/4 fuselage lenth hieght by the 3/4 fuselage lenth hieght
    KN_Factor4 = hf / wf;                   % Fuselage Hieght Divided by the Max Fuselage Width

    K_n = 0.00085;                          % Empirical Wing-body interference factor that is a function of the fuselage geometry Calculated using the Results from KN_Factor's and using the graph from Nelson pg 75 

%   Using results from V_lf, graph used to find the K_Rl Empirical factor, Found in Nelson pg 75
    V_lf = (Sf * lf) / (S_w * b_w);         % The Projected Side Area of the fuselage times by the Fuselage length Divided by the Main Wing Area Divided by the Main Wing Span

    R_lf = (V_lf * vis)*10^-6;              % Renyolds number Correction Factor

    K_Rl = 1.2;                             % Empirical correction factor that is a function of the fuselage Reynolds number

    K = -0.12;                              % Empirical factor for Cn_lilDelta_Aileron Nelson, R -  CH 3 pg 122 fig 3.12    
% -------------------------------------------------------------------------    


% ================ Centre of Gravity of the Aircraft ======================

% -------------------------------------------------------------------------
    % Array created for the A/C Arms and Weights

    Arm_Array  =   [5.643 5.569 5.400 6.370 ...
        7.130 7.890 8.550];                     % m, Arm Lengthsfor the Aircraft
    Weight_Array = [m 4949 60 207 149 239 85];  % kg, Weights from the Flight Test Data for Group C

    Moment_Array = Arm_Array.* Weight_Array;    % Momonet are calculated using the Arm length times by the Weight at the individal arm lengths

    Total_Arm = sum(Arm_Array, 2);              % The Total Arm Lengths for the A/C

    Total_Moment = sum(Moment_Array, 2);        % The Total Moment of the A/C 

    Total_Weight = sum(Weight_Array, 2);        % The Total Weight of the A/C

    CG = ((Total_Moment / Total_Weight) ...
        - 5.149) * (100/1.717);                 % CG Calculated from the Total_Moment and Total_Weight     
% -------------------------------------------------------------------------   


% ========================== Initial Speed ================================

% -------------------------------------------------------------------------
    U_0 = Initial_Speed();                  % Average speed from the all three groupd of the Phugoid from the Flight Test Data
    Kts2Mach = 0.0015;                      % Convertion of Knots to Mach 
    Mach = U_0 * Kts2Mach;                  % Converting Initial Speed in Knots to Mach Number
% -------------------------------------------------------------------------    


% ========================== Temperature ==================================

% -------------------------------------------------------------------------
    Pg_data = xlsread('Phugoid_GpA.xls');   % Temperature Data used in Phugoid & Roll
    Rho = Dens_Calc(358,Pg_data(1,5),18,1012);
    q = Pg_data(:,3);
% -------------------------------------------------------------------------  


% ==================== Coefficients of Aircraft ===========================

% --------------------------- Aircrafte ------------------------------------
    % Approximated from Cooke simulation model p28
    CM_Alpha = -0.3;
% -------------------------------------------------------------------------

% --------------------------- Main Wing -----------------------------------
    data4 = xlsread('JavaFoil_MainWingData');
    CL_w = data4(:,2);
    CD_w = data4(:,3);
    Alpha = data4(:,1);
    
    CL_0w = 0.368;
    CD_0w = 0.01852;
    CM_Ow = -0.059;      % 25% MAC

    CL_Uw = ((Mach)^2 / (1 - (Mach)^2)) * CL_0w;

    CL_Aw = 4.9733;
    CD_Aw = 0.008956;
    CM_Aw = -0.0014;
    
    CL_BetaByGam = -0.000218; % using graph from Nelson P122 (figure 3.11)
% -------------------------------------------------------------------------
    
% -------------------------- Vertical Stabiliser --------------------------
    data5 = xlsread('JavaFoil_TailData');
    CL_v = data5(:,2);
    CD_v = data5(:,3);
    
    CL_0v = 1;
    CD_0v = 1;
    CM_0v = 1;
    
    CL_Av = 2.360586116;
    CD_Av = 1;
    
    CD_Uv = ((Mach)^2 / (1 - (Mach)^2)) * CL_0v;
% -------------------------------------------------------------------------

% ------------------------- Horizontal Stabilier --------------------------  
    CL_0h = 0.00;
    CD_0h = 0.01217;
    CM_0h = -0.00;        % 25% MAC
    
    CL_Ah = 2.360586116;
    CD_Ah = 1;
    CM_Ah = 1;
% -------------------------------------------------------------------------


% ===================== Changes of Aircraft ===============================

% -------------------------------------------------------------------------
    dEpsBYdAlpha = (2 * CL_Aw) / (pi * AR_w);                   % Change in downwash due to a change on Angle of Attack
    dSigmaBYdBeta = (S_v / S_w) / (1 + (cos(Swept_Angle)));     % Change in Sidewash angle with a change in sideslip angle
    CM_Av = -(EffFac_V) * V_v * CL_Av * (1 - dEpsBYdAlpha);     % Coefficient of Moment to the Angle of Attack relative to the Verticial Stabiliser 
% -------------------------------------------------------------------------


% ========================= Mat File Parameters =========================== 
    
% -------------------------------------------------------------------------
    d = datetime('today')                   % Date
    save(cfgmatfile);                       % Save workspace variables to MAT file
    fprintf(strcat('\n Aircraft configuration saved as:\t', strcat(cfgmatfile),'.mat'));
    fprintf('\n');
% -------------------------------------------------------------------------    
	end
