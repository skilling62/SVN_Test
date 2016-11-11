% Stability Derivative Development 
% Group 19

clear all
close all
clc

% =========================================================================
%% Eurostar Data =========================================================================
load('eurostar.mat');
%% Conversions and constants
g = 9.81;
ft_to_m = 0.3048;
mph_to_mps = 0.44704;

%% standard atmosphere data
load('stdatm.mat')

Table_Altitude = stdatm(:,1);   % m
Table_Temp = stdatm(:,2);       % K
Table_Pressure = stdatm(:,3);   % Pascals
Table_Density = stdatm(:,4);    % Kg/m^3



%% Import the data
[~, ~, raw] = xlsread('PhugoidValues.xlsx','Sheet1','B4:J43');
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
PhugoidValues1 = reshape([raw{:}],size(raw));

%% Clear temporary variables
clearvars raw R;

%Size of matrix generated
[Num_rows_FT , Num_cols_FT] = size(PhugoidValues1);

for i = 1:Num_rows_FT
    delta_FT(i) = -log(((abs(PhugoidValues1(i,3)-PhugoidValues1(i,1)))/(abs(PhugoidValues1(i,2)-PhugoidValues1(i,1)))));
    zeta_FT(i) = delta_FT(i)/sqrt(((pi^2)+(delta_FT(i)^2)));  % Damping ratio
    wd_FT(i)= (2*pi)/(PhugoidValues1(i,7)); % Damped natural frequency
    wn_FT(i)= wd_FT(i)/(sqrt(1-(zeta_FT(i))^2)); % Natural frequency
    airspeed_FT(i)= nanmean(PhugoidValues1(i,1:6)); % in mph
    u0_FT(i)= airspeed_FT(i)*mph_to_mps; % m/s
    m_FT(i)= PhugoidValues1(i,9); % Kg - Use empty weight, pilots and fuel in your calculation
    Zu_FT(i)= ((-(wn_FT(i)^2))*u0_FT(i))/g;
    Altitude_ft_FT(i) = PhugoidValues1(i,8); % ft (after climb test)
    Altitude_m_FT(i) = Altitude_ft_FT(i)*ft_to_m; % m
    rho_FT(i)= stdatmo(Altitude_m_FT(i));
    Q_FT(i) = 0.5*rho_FT(i)*u0_FT(i)^2; % Dynamic Pressure
    CZu_FT(i) = (m_FT(i)*u0_FT(i)*Zu_FT(i))/(Q_FT(i)*S);
    CL0_FT(i) = -CZu_FT(i)/2;
    Xu_FT(i) = -2*zeta_FT(i)*wn_FT(i);
    CXu_FT(i) = (m_FT(i)*u0_FT(i)*Xu_FT(i))/(Q_FT(i)*S);
    CD0_FT(i) = -CXu_FT(i)/3;
    Weight_Array_FT(i) = nanmean(PhugoidValues1(i,9));
end 
    
%% Mean values
CD0_Mean = nanmean(CD0_FT);
CL0_Mean = nanmean(CL0_FT);
Zu_Mean = nanmean(Zu_FT);
u0_Mean = nanmean(u0_FT);
Xu_Mean = nanmean(Xu_FT);
rho_Mean = nanmean(rho_FT);
m_Mean = nanmean(m_FT);
CZu_Mean = nanmean(CZu_FT);
Q_Mean = nanmean(Q_FT);
Altitude_Mean = nanmean(Altitude_m_FT);
Weight_Mean = nanmean(Weight_Array_FT);
zeta_Mean = nanmean(zeta_FT);
CZu_Mean = nanmean(CZu_FT);
CXu_Mean = nanmean(CXu_FT);
wn_Mean = nanmean(wn_FT);
wd_Mean = nanmean(wd_FT);
delta_Mean = nanmean(delta_FT);
%% Variances
CD0_Var = nanvar(CD0_FT);
CL0_Var = nanvar(CL0_FT);
Zu_Var = nanvar(Zu_FT);
u0_Var = nanvar(u0_FT);
Xu_Var = nanvar(Xu_FT);
rho_Var = nanvar(rho_FT);
m_Var = nanvar(m_FT);
CZu_Var = nanvar(CZu_FT);
Q_Var = nanvar(Q_FT);
Altitude_Var = nanvar(Altitude_m_FT);
Weight_Var = nanvar(Weight_Array_FT);
zeta_Var = nanvar(zeta_FT);
CZu_Var = nanvar(CZu_FT);
CXu_Var = nanvar(CXu_FT);
wn_Var = nanvar(wn_FT);
wd_Var = nanvar(wd_FT);
delta_Var = nanvar(delta_FT);
%% Stadard deviations
CD0_std = nanstd(CD0_FT);
CL0_std = nanstd(CL0_FT);
Zu_std = nanstd(Zu_FT);
u0_std = nanstd(u0_FT);
Xu_std = nanstd(Xu_FT);
rho_std = nanstd(rho_FT);
m_std = nanstd(m_FT);
CZu_std = nanstd(CZu_FT);
Q_std = nanstd(Q_FT);
Altitude_std = nanstd(Altitude_m_FT);
Weight_std = nanstd(Weight_Array_FT);
zeta_std = nanstd(zeta_FT);
CZu_std = nanstd(CZu_FT);
CXu_std = nanstd(CXu_FT);
wn_std = nanstd(wn_FT);
wd_std = nanstd(wd_FT);
delta_std = nanstd(delta_FT);
%% Refining of material
Refined_CL0 = CL0(abs(CL0-CL0_Mean)<CL0_std ) ;   %CL0 without outlying values
Refined_CD0 = CD0(abs(CD0-CD0_Mean)<CD0_std ) ;   %CD0 without oulying values
%% Mean of new refined material
CL0_New = mean(Refined_CL0);
CD0_New = mean(Refined_CD0);
