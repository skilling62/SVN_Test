function [L_p] = Roll_Func(MethodNumber)
clc

load('Jetstream', 'S_w', 'b_w', 'I_z', 'CL_Aw', 'gravity', 'U_0', ...
    'W', 'Y1', 'Y2', 'Cr', 'Lander', 'CL_BetaByGam', 'Gamma', 'I_x', 'Rho') 

addpath .\Cranfield_Flight_Test_Data;

%% Import the Data (Time vector and roll rate) and plot

    switch MethodNumber 
    
    case 1
    % Import Data
    Roll_data = xlsread('Roll_GpA.xls');
    roll_time = Roll_data(:,1);
    p = Roll_data(:,4);
    delta_a = Roll_data(:,2);
    phi = Roll_data(:,3);
    GroupName = Roll_data(1,8);

    % Plot
    subplot(2,1,1)
    plot(roll_time,p,'DisplayName','Roll Rate (Degrees/s)')
    [pk,locs] = findpeaks(p,roll_time,'MinPeakDistance',1.8);
    [troughs, lc1] = findpeaks(-p,roll_time,'MinPeakDistance',1.5);
    troughs = -troughs;
    hold on
    plot(locs,pk,'mo',lc1, troughs, 'ko','HandleVisibility','off')
    plot (roll_time, delta_a,'DisplayName','Aileron Deflection Angle (Degrees)');
    grid minor
    xlabel('Time (Seconds)')
    ylabel('State Variable')
    legend(gca,'show')
    hold off
    %% Determine the Time Constant

    % Rescale the plot
    t1 = lc1(3);
    t2 = lc1(4);
    y1 = troughs(3);
    global time_
    time_ = roll_time(roll_time>=t1 & roll_time<t2)-t1;
    index = length(roll_time) - length(roll_time(roll_time>=t1)) + 1;
    pfindex = (index + length(time_)) -1 ;
    global RollRate_
    RollRate_ = p(index:pfindex) - abs(y1);

    % Find the steady state
    if GroupName == 1
            p_ss = pk(4) - abs(y1);
        elseif GroupName == 2
            p_ss = pk(3) - abs(y1);
    end

    t_ss = 0.632*p_ss;
    Vp_ss = linspace(p_ss,p_ss,length(time_));
    Vt_ss = linspace(t_ss,t_ss,length(time_));

    % Find the time at which 63.2% is reached
    idx = find(Vt_ss' - RollRate_ < eps, 1);
    px = time_(idx);
    py = Vt_ss(idx);

    % Negate the flat response at the start
    k = find(RollRate_>0.1,1);
    py_ = RollRate_(k);
    px_ = time_(k);

    % Plot the response
    subplot(2,1,2)
    plot(time_,RollRate_,'DisplayName','Roll Rate (Degrees/s)')
    hold on
    plot(time_,Vt_ss,'--k', px, py,'ro','HandleVisibility','off')
    plot(time_,Vp_ss,'DisplayName','Steady State')
    plot(px_,py_,'ko','HandleVisibility','off')
    hold off
    axis tight
    grid minor
    xlabel('Time (Seconds)')
    ylabel('Roll Rate (Degrees/s)')
    legend(gca,'show')

    % Calculate Time Constant and Lp
    tau = px - px_;
    L_p = -1/tau;
   
%% Equations
    case 2
    
    Q = 0.5 * Rho * (U_0^2);
           
    CL_p = -(CL_Aw / 12) * ((1 + (3 * Lander)) / (1 + Lander));
    
    L_p = (Q * S_w * (b_w^2) * CL_p) / (2 * I_x * U_0);

    end
    
end