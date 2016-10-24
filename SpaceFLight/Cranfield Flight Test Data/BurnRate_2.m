%% Burn Rate 
% Thrust Specfic Fuel Consumption (TSFC) 
% [https://www.grc.nasa.gov/www/k-12/airplane/sfc.html]



m_f = 0;        % Fuel Mass Flow Rate
m_a = 0;    	% Air Mass Flow Rate
f = m_f / m_a;  % Fuel to Air Ratio
F = 0;          % Net Thrust
Fs = F / m_a;   % Specfic Thrust

TSFC = f / Fs
