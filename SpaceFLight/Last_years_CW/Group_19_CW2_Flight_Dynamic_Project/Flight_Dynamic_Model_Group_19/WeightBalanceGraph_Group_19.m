% Weight - Balance Graph for EV-97 Microlight Aircraft
% Created by Group 19 for UFMFCH-15-3 Spaceflight 
% Relates to Section 3.0 in Flight Test Coursework

% Variable Dictionary 
% Empty_Weight - kg
% Payload_Weight - kg
% Weight_Arm - mm
% Payload_arm - mm
% Total_Weight - kg
% Total_Moment - kgmm
% xcg - centre of gravity (mm)
% c - Aerofoil chord (mm)
% xac_c - Aerofoil aerodynamic centre from LE (mm)
% b - Wing span (mm)
% S - Aerofoil planform area (mm^2)
% St - Tail plane planform area (mm^2)
% AP - Aspect Ratio
% n - Tail efficiency ratio 
% CL0w = Coefficient of Lift at 0 AoA
% CLaw = Rate of change of Cl with respect to AoA of wing
% Cmac = Coefficient moment at aerodynamic centre
% da0 - Downwash angle at zero AoA (radians)
% dag - Downwash angle gradient (radians)
% iw - Wing incidence angle (degrees)
% it - Tail plane incidence angle (degrees)
% CLat - Rate of change of CL with respect to angle of attack of tail
% lt - moment arm (mm)
% VH - Horizontal Tail Volume Ratio

format long g

%% Weight Values - kg
Empty_Weight = 268;
Baggage_Weight = input('Enter Baggage Weight: (kg)')
Crew_Weight = input('Enter Crew Weight: (kg)')
Fuel = input('Enter Fuel Weight: (litres)')
% Convert litres to weight (conversion from POH)
Fuel_Weight = Fuel*0.72;


%% Moment Arm values - mm aft of leading edge
Weight_Arm = 200;
Baggage_Arm = 1270;
Crew_Arm = 500;
Fuel_Arm = 920;

%% Moment Calculations
Weight_Array = [Empty_Weight, Baggage_Weight, Crew_Weight, Fuel_Weight];
Arm_Array = [Weight_Arm, Baggage_Arm, Crew_Arm, Fuel_Arm];
Moment_Array = Weight_Array.*Arm_Array;

Total_Weight = sum(Weight_Array);
Total_Moment = sum(Moment_Array);

xcg = Total_Moment/Total_Weight;

%% Angle of attack from -15 to 15 degrees
% alphaw = -15:0.01:15;
% alphaw_rads = alphaw.*(pi/180);

%% Aircraft & Atmsopheric variables 
% c = 1215;
% xac_c = 0.25*c;
% b = 8100;
% S = 9840000;
% St = 1950000;
% AR = (b^2)/S;
% n = 0.90;

% Cl0w = 0.261; %(0.261)/(1+(0.261/(pi*AR)));
% Claw = 0.107882; %(0.107882)/(1+(0.107882/(pi*AR)));
% Cmac = -0.056;

% Wing moment contribution
% Cm0w = Cl0w*(xcg/c-xac_c);
% Cmaw = Cmac + Claw*(xcg/c-xac_c);
% Cmw = Cm0w + Cmaw.*alphaw_rads;
% Clat = 0.1093; %(0.1093)/(1+(0.1093/(pi*((2.5^2)/1.95))));

% da0 = Cl0w*(2/(pi*AR));
% dag = Claw*(2/(pi*AR));

%% Angle of Incidence's conversion to radians
% iw = 3;
% iw_rads = iw*(pi/180);
% it = 0;
% it_rads = it*(pi/180);

% Tail moment contribution
% lt = 3642;
% VH = (lt*St)/(S*c);
% Cm0t = n*VH*Clat*(da0+iw_rads-it_rads);
% Cmat = -n*VH*Clat*(1 - dag);
% Cmt = Cm0t + Cmat.*alphaw_rads;

%% Total Moment
% Cm0 = Cm0w + Cm0t;
% Cma = Cmaw + Cmat;
% Cm = Cm0 + Cma.*alphaw_rads;

% Calculate the stick fixed neutral point of the aircraft (xnp) 
% xnp = c.*(n.*VH.*(Clat/Claw).*(1-dag)+xac_c);        
% rearward_limit = (xnp/100);

%% Defining boundary of Weight Balance Graph 
WB_Box_x = [250,250,410,410];
WB_Box_y = [250,450,450,250];

figure(1)
x = plot(xcg, Total_Weight, 'rx');
grid on
hold on
plot(WB_Box_x, WB_Box_y, 'k')
axis([200,500,300,500])
set(x,'linewidth',3);
title('Weight & Balance of EV-97')
ylabel('Weight (kg)')
xlabel('Aircraft Centre of Gravity aft of datum (mm)')
hold off
