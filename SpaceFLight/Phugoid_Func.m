
function [Xu, Zu] = Phugoid_Func(MethodNumber)

clc

addpath .\Cranfield_Flight_Test_Data;

%% Import flight test data
kts2ms = 0.51444;
Pg_data = xlsread('Phugoid_GpA.xls');
time = Pg_data(:,1);
U = Pg_data(:,4) * kts2ms;

%% Plot the velocity response of the aircraft
[pk,lc] = findpeaks(U,time);
[troughs, lc1] = findpeaks(-U,time);
troughs = -troughs;
plot(time,U);
grid minor
hold on
plot(lc, pk, 'mo', lc1, troughs, 'ko');
ax.XTickLabelMode = 'auto';
hold off
xlabel('Time (Seconds)')
ylabel ('Aircraft Velocity (m/s)')

%% Determine the amplitude of the response and corresponding times for use in the logarithmic decrement method
r1 = pk(1);
r2 = troughs(2);
r3 = pk(2);

t1 = lc(1);
t2 = lc1(2); 
t3 = lc(2);

%% Using the logarithmic decrement method provided in Flight Dynamics Notes 
    switch MethodNumber 
    case 1
    Omeg_d = (2*(pi))/(t3 - t1);
    
    lil_delta = -log(abs((r3-r2)/(r2-r1)));
    
    Zeta = lil_delta / (sqrt((pi^2) + (lil_delta^2)))
        
    Omeg_n = Omeg_d / (sqrt(1 - (Zeta^2)))

    Zu = - (U_0 * (Omeg_n^2)) / gravity;
        
    CZ_u = (m * U_0 * Zu) / (Q * S_w);
       
    Xu = -(Zeta * 2 * Omeg_n);
        
    CX_u = (m * U_0 * Xu) / (Q * S_w);
    
%% Load Varibles from mat file
load('JetStream.mat', 'gravity', 'm', 'S_w', 'EffFac_V', 'V_v' , 'l_v' , 'Cbar', 'CL_Av', ...
        'CM_Alpha', 'CD_Uw', 'CL_Uw', 'CD_0w','CL_0w', 'CD_Aw', 'CL_0w', 'CL_Aw', 'X_ac', 'CG', 'I_y', ...
        'dEpsBYdAlpha', 'U_0', 'q', 'Rho')
    
CD_Uw = 0.1;

%% Calulations
Q = 0.5 * Rho * (U_0^2);

% Where did this equation for Cmq come from?
Cz_q = -(2 * CL_Av * EffFac_V * V_v);
CM_q = Cz_q * (l_v / Cbar);
M_q = ((CM_q) * (Cbar / (2 * U_0)) * Q * S_w * Cbar) / I_y;
M_u = 0;
	
% Calculate Mw and Malhpa
M_w = (CM_Alpha * Q * S_w * Cbar) / (U_0 * I_y);
M_Alpha = M_w * U_0;

% Calculate Mwdot and Malphadot
CZ_AlphaDot = -(2 * CL_Av * EffFac_V * V_v * dEpsBYdAlpha);
CM_AlphaDot = CZ_AlphaDot * (l_v / Cbar);
M_wDot = (CM_AlphaDot * (Cbar / (2 * U_0)) * Q * S_w * Cbar) / (U_0 * I_y);
M_AlphaDot = M_wDot * U_0;

% Calculate Xu
Xu = (-(CD_Uw + (2 * CD_0w)) * Q * S_w) / (U_0 * m);

% Calculate Xw and XAlpha
Xw = (-(CD_Aw - CL_0w) * Q * S_w) / (U_0 * m);	
XAlpha = Xw * U_0;

% Calculate Zu
Zu = (-(CL_Uw * (2 * CL_0w)) * Q * S_w) / (U_0 * m);

% Calculate Zw and Zalpha	
Zw = (-(CL_Aw - CL_0w) * Q * S_w) / (U_0 * m);	
ZAlpha = Zw * U_0;
      
%% Using Bairstow's Phugoid Approximation  from S.Pradeer Paper
    case 2
    % U_0 is the component of steady state velocity along the x axis
    A = U_0;
    B = -(U_0) * (M_q + M_AlphaDot) - ZAlpha;
    C = (M_q * ZAlpha) - (M_Alpha * U_0);
    D = Xu * ((M_Alpha * U_0) - (M_q * ZAlpha))- ((M_u * U_0) * (XAlpha - gravity));
    E = gravity * ((M_Alpha * Zu) - (M_u * ZAlpha));

    Omeg_n = sqrt(E/C)
    
%     Two_Zeta_Omeg_n = (1/(Malpha*U_0 - Mq*Zalpha)) * ((Xu*(-Malpha*U_0+Mq*Zalpha)) ...
%                                                    + Zu*(-Mq*Xalpha + g*Malpha*U1*Malpha+Mq+Zalpha

%     Two_Zeta_Omeg_n = (1 / ((M_Alpha * U_0) - (M_q * Z_Alpha))) ...
%     * (((Xu * (-(M_Alpha * U_0) + (M_q * Z_Alpha))) ...
%     + (Zu * (-(M_q * X_Alpha) + (((gravity * M_Alpha) * U_0 ...
%     * (M_AlphaDot + M_q) + Z_Alpha) / ((M_Alpha * U_0) ...
%     - (M_q * Z_Alpha))))) + ((M_u * ((U_0 * X_Alpha) ...
%     - ((gravity * (Z_Alpha * ((U_0 * M_AlphaDot) + Z_Alpha) ...
%     + (M_Alpha * (U_0^2)))) / ((M_Alpha * U_0) - (M_q * Z_Alpha))))))));

    C_0 = (Omeg_n)^2;
    C_1 = Two_Zeta_Omeg_n;

% Phugoid_Sfunc = S^2 + (C_1 * S) + C_0

%% Using 3-Degrees-of-Freedom Approximation from S.Pradeer Paper
    case 3
    Theta = q;
    Alpha = 1;
        
    U_Dot = (Xu * U) + (Alpha.*XAlpha) - (Theta.*gravity);

    Omeg_n = sqrt ((gravity * ((ZAlpha * M_u) - (Zu * M_Alpha))) /( M_Alpha * U_0));
    Two_Zeta_Omeg_n =  -(Xu) + ((M_u * (XAlpha - gravity)) / M_Alpha);
    
    Zeta = Two_Zeta_Omeg_n/(2 * Omeg_n);
    
    end
    
end