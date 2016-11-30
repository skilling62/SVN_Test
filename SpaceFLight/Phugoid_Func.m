function [Xu, Zu] = Phugoid_Func(MethodNumber)

clc

addpath .\Cranfield_Flight_Test_Data;

%% Loading Varibles 
load('JetStream.mat', 'gravity', 'm', 'S_w', 'eta_h', 'V_h' , 'l_h' , 'Cbar', 'CL_Ah', ...
        'CM_Alpha', 'CD_Uw', 'CL_Uw', 'CD_0w', 'CD_Aw', 'CL_0w', 'CL_Aw', 'X_ac', 'CG', 'I_y', ...
        'dEpsBYdAlpha', 'U_0', 'q', 'Rho')
    
%% Calulations
Q = 0.5 * Rho * (U_0^2);
% Calculate Cmq using Czq (Nelson p126). Mq Needed for Bairstow Phugoid
% approximation
Czq = -2 * CL_Ah * eta_h * V_h;
CMq = Czq * (l_h / Cbar);
Mq = ((CMq) * (Cbar / (2 * U_0)) * Q * S_w * Cbar) / I_y;

Mu = 0;
% Calculate Mw and Malhpa
Mw = (CM_Alpha * Q * S_w * Cbar) / (U_0 * I_y);
Malpha = Mw * U_0;

% Calculate Mwdot and Malphadot (Procedure Nelson p126)
CZalphaDot = -(2 * CL_Ah * eta_h * V_h * dEpsBYdAlpha);
CmalphaDot = CZalphaDot * (l_h / Cbar);
Mwdot = CmalphaDot * (Cbar / (2 * U_0)) * ((Q * S_w * Cbar) / (U_0 * I_y));
MalphaDot = Mwdot * U_0;

% Calculate Xu
Xu = (-(CD_Uw + (2 * CD_0w)) * Q * S_w) / (U_0 * m);

% Calculate Xw and XAlpha
Xw = (-(CD_Aw - CL_0w) * Q * S_w) / (U_0 * m);	
Xalpha = Xw * U_0;

% Calculate Zu
Zu = (-(CL_Uw + (2 * CL_0w)) * Q * S_w) / (U_0 * m);

% Calculate Zw and Zalpha	
Zw = (-(CL_Aw + CD_0w) * Q * S_w) / (U_0 * m);	
Zalpha = Zw * U_0;
    
%% Import flight test data
kts2ms = 0.51444;
Pg_data = xlsread('Phugoid_GpA.xls');
global time 
time = Pg_data(:,1);
global U 
U = Pg_data(:,4) * kts2ms;
GroupName = Pg_data(1,7);

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
axis tight

%% Determine the amplitude of the response and corresponding times for use in the logarithmic decrement method

if GroupName == 1
    r1 = pk(1);
    r2 = troughs(2);
    r3 = pk(2);

    t1 = lc(1);
    t2 = lc1(2); 
    t3 = lc(2);
    
elseif GroupName == 2
    r1 = pk(2);
    r2 = troughs(2);
    r3 = pk(3);
    
    t1 = lc(2);
    t2 = lc1(2);
    t3 = lc(3);
    
else 
    msg = 'Group C shall be discarded due to anomolous data';
    error (msg)
end
%% Using the logarithmic decrement method provided in Flight Dynamics Notes 
    switch MethodNumber 
    case 1
    % Calulations
   
    Omeg_d = (2*(pi))/(t3 - t1);
    
    lil_delta = -log(abs((r3-r2)/(r2-r1)));
    
    Zeta = lil_delta / (sqrt((pi^2) + (lil_delta^2)));
        
    Omeg_n = Omeg_d / (sqrt(1 - (Zeta^2)));

    Zu = - (U_0 * (Omeg_n^2)) / gravity;
        
    CZ_u = (m * U_0 * Zu) / (Q * S_w);
       
    Xu = -(Zeta * 2 * Omeg_n);
        
    CX_u = (m * U_0 * Xu) / (Q * S_w);
    
      
%% Using Bairstow's Phugoid Approximation  from S.Pradeep Paper
    case 2
    % U_0 is the component of steady state velocity along the x axis
    A = U_0;
    B = -(U_0) * (Mq + MalphaDot) - Zalpha;
    C = (Mq * Zalpha) - (Malpha * U_0);
    D = Xu * ((Malpha * U_0) - (Mq * Zalpha))- ((Mu * U_0) * (Xalpha - gravity));
    E = gravity * ((Malpha * Zu) - (Mu * Zalpha));

    Omeg_n = sqrt(E/C);
    
    Two_Zeta_Omeg_n = ((1/(Malpha*U_0 - Mq*Zalpha)) * ((Xu*(-Malpha*U_0+Mq*Zalpha))...
                                                + Zu*((-Mq*Xalpha) + ((gravity*Malpha*(U_0*(Malpha+Mq)+Zalpha)) / (Malpha*U_0 - Mq*Zalpha)))...
												+ Mu*((U_0*Xalpha) - ((gravity*(Zalpha*(U_0*Malpha+Zalpha)+Malpha*U_0^2)) / (Malpha*U_0-Mq*Zalpha)))));

    Zeta = Two_Zeta_Omeg_n/(2*Omeg_n);
    
%% Using 3-Degrees-of-Freedom Approximation from S.Pradeep Paper
    case 3
    Theta = q;
    Alpha = 1;
        
    U_Dot = (Xu * U) + (Alpha.*Xalpha) - (Theta.*gravity);

    Omeg_n = sqrt ((gravity * ((Zalpha * Mu) - (Zu * Malpha))) /( Malpha * U_0));
    Two_Zeta_Omeg_n =  -(Xu) + ((Mu * (Xalpha - gravity)) / Malpha);
    
    Zeta = Two_Zeta_Omeg_n/(2 * Omeg_n);
    
    end
    
end