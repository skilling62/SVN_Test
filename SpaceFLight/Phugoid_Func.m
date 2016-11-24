
function [Xu, Zu] = Phugoid_Func(MethodNumber)
addpath .\Cranfield_Flight_Test_Data;
%% Loading Varibles 
load('JetStream.mat', 'gravity', 'm', 'S_w', 'EffFac_V', 'V_v' , 'l_v' , 'Cbar', 'CL_Av', ...
        'CM_Af', 'CD_Uw', 'CL_Uw', 'CD_0w', 'CD_Aw', 'CL_0w', 'CL_Aw', 'X_ac', 'CG', 'I_y', ...
        'dEpsBYdAlpha', 'U_0', 'q', 'Rho')
    
    CD_Uw = 0.1;
%% Calulations

    Q = 0.5 * Rho * (U_0^2);

    Cz_q = -(2 * CL_Av * EffFac_V * V_v);
	CM_q = Cz_q * (l_v / Cbar);
    M_q = ((CM_q) * (Cbar / (2 * U_0)) * Q * S_w * Cbar) / I_y;
	
	M_u = 0;
	
	CM_Aw = (CL_Aw * ((CG / Cbar) - (X_ac / Cbar))) + ...
        CM_Af - (EffFac_V * V_v * CL_Av * (1 - dEpsBYdAlpha));
       
	M_w = (CM_Aw * Q * S_w * Cbar) / (U_0 * I_y);
	
	M_Alpha = M_w * U_0;
	
	CZ_AlphaDot = -(2 * CL_Av * EffFac_V * V_v * dEpsBYdAlpha);
	CM_AlphaDot = CZ_AlphaDot * (l_v / Cbar);
	M_wDot = (CM_AlphaDot * (Cbar / (2 * U_0)) * Q * S_w * Cbar) / (U_0 * I_y);
	
	M_AlphaDot = M_wDot * U_0;
	
	Xu = (-(CD_Uw + (2 * CD_0w)) * Q * S_w) / (U_0 * m);
	
	X_w = (-(CD_Aw - CD_0w) * Q * S_w) / (U_0 * m);
	
	X_Alpha = X_w * U_0;
	
	Zu = (-(CL_Uw * (2 * CL_0w)) * Q * S_w) / (U_0 * m);
	
	Z_w = (-(CL_Aw - CL_0w) * Q * S_w) / (U_0 * m);
	
	Z_Alpha = Z_w * U_0;

%% Creating Data to use in calulations

kts2ms = 0.51444; % kts to m/s 1 = 0.51444
Pg_data = xlsread('Phugoid_GpA.xls');
time = Pg_data(:,1);
U = Pg_data(:,4) * kts2ms;

[pk,lc] = findpeaks(U,time);
[troughs, lc1] = findpeaks(-U,time);
troughs = -troughs;
plot(time,U, 'g',lc, pk, 'mo', lc1, troughs, 'ko');
ax.XTickLabelMode = 'auto';
grid minor;
xlabel('Time (Seconds)')
ylabel ('Velocity (m/s)')

t1 = lc(1,:); t2 = lc1(1,:); t3 = lc(2,:);
t4 = lc1(2,:); t5 = lc(3,:); t6 = lc1(3,:);

r1 = pk(1,:); r2 = troughs(1,:); r3 = pk(2,:);
r4 = troughs(2,:); r5 = pk(3,:); r6 = troughs(3,:);


    switch MethodNumber 
%% Using the logarithmic decrement method provided in Flight Dynamics Notes
    % Calculate the Damped Natural Frequency  
     case 1
        Omeg_d = 2*(pi)/ (t3 - t1);

        lil_delta = -log((abs(r3 - r1))/ (abs(r2 - r3)));
        
        Zeta = lil_delta / (sqrt((pi^2) + (lil_delta^2)));
        
        Omeg_n = Omeg_d / (sqrt(1 - (Zeta^2)));

        Zu = - (U_0 * (Omeg_n^2)) / gravity;
        
        CZ_u = (m * U_0 * Zu) / (Q * S_w);
       
        Xu = -(Zeta * 2 * Omeg_n);
        
        CX_u = (m * U_0 * Xu) / (Q * S_w);
               
%% Using Bairstow's Phugoid Approximation  from S.Pradeer Paper
    case 2
        A = U_0
        B = -(U_0) * (M_q + M_AlphaDot) - Z_Alpha
        C = (M_q * Z_Alpha) - (M_Alpha * U_0)
        D = Xu * ((M_Alpha * U_0) - (M_q * Z_Alpha)) ...
            - ((M_u * U_0) * (X_Alpha - gravity))
        E = gravity * ((M_Alpha * Zu) - (M_u * Z_Alpha))

        Omeg_Phugoid = sqrt(E/C);

        Two_Zeta_Omeg_Phuoid = (1 / ((M_Alpha * U_0) - (M_q * Z_Alpha))) ...
            * (((Xu * (-(M_Alpha * U_0) + (M_q * Z_Alpha))) ...
            + (Zu * (-(M_q * X_Alpha) + (((gravity * M_Alpha) * U_0 ...
            * (M_AlphaDot + M_q) + Z_Alpha) / ((M_Alpha * U_0) ...
            - (M_q * Z_Alpha))))) + ((M_u * ((U_0 * X_Alpha) ...
            - ((gravity * (Z_Alpha * ((U_0 * M_AlphaDot) + Z_Alpha) ...
            + (M_Alpha * (U_0^2)))) / ((M_Alpha * U_0) - (M_q * Z_Alpha))))))));

        C_0 = (Omeg_Phugoid)^2;
        C_1 = Two_Zeta_Omeg_Phuoid;

%         Phugoid_Sfunc = S^2 + (C_1 * S) + C_0

%% Using 3-Degrees-of-Freedom Approximation from S.Pradeer Paper
    case 3
        Theta = q;
        Alpha = 1;
        
        U_Dot = (Xu * U) + (Alpha.*X_Alpha) - (Theta.*gravity);

        % Characteristic Equation
%         0 = Landa^2 + ((-(X_U) * ((X_Alpha * M_u)/ M_Alpha)) ...
%         - ((g * M_u) / M_Alpha)) * Landa + (gravity * (((Z_Alpha * M_u) ...
%         - (Z_u * M_Alpha)) / (M_Alpha *U_0)));

        Omeg_Phugoid = sqrt((gravity * (((Z_Alpha * M_u) - (Zu * M_Alpha)) / (M_Alpha * U_0))));
        Two_Zeta_Omeg_Phuoid_1 =  -(Xu) + ((M_u * (X_Alpha - gravity)) / M_Alpha);
    
    end
    
end