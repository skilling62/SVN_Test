function Dens_Calc(airfieldalt_ft,testalt_ft,airfieldtemp_deg,airfieldpress_mb )



global Rho g

%% Declare Variables

% Acceleration due to Gravity in ms^-2
g = 9.81;
% Lapse rate Km^-1
a = -0.0065;
% Gas Constant(J/kgk)
R = 287.0;

%% Convert units

% Convert airfield and test altitude from feet to metres
airfieldalt_m = airfieldalt_ft * 0.3048;
testalt_m = testalt_ft * 0.3048;

% Convert airfield temperature from celsius to kelvin
airfieldtemp_k = airfieldtemp_deg + 273.16;
% Convert airfield pressure from bar to Nm^-2
airfieldpress_nm = airfieldpress_mb*100;
% Calculate air density at airfield, kgm^-3 
airfieldrho = airfieldpress_nm/(R * airfieldtemp_k);


%% Calculate conditions at test altitude and sea level

% Calculate temperature at test altitude
testtemp_k = airfieldtemp_k + -6.5e-3*(testalt_m - airfieldalt_m);
% Calculate temperature at sea level
seatemp_k = airfieldtemp_k - (-6.5e-3*airfieldalt_m);
% Calculate the ISA condition
ISA = seatemp_k - 288.16;
%disp(['The ISA COndition is + ',num2str(ISA),' celsius']);

%% Plot the temperature altitude relationship for ISA and conditions and ISA + 3.7
h = linspace(0,10000,100);
t0 = 288.15;
t = t0+(a.*h);
plot(t,h)
grid on
xlabel('Temperature(k)')
ylabel('Altitude(m)')
hold on
tmy = seatemp_k+(a.*h);
plot(tmy,h)
v_testalt_m = linspace(testalt_m,testalt_m,length(t));
plot(t,v_testalt_m)

%% Display some values to check calculation
% Display temperature at test altitude
%disp(['Temperature at test alt: ', num2str(testtemp_k),' kelvin']);
% Display temperature at sea level
%disp(['Temperature at Sea Level: ',num2str(seatemp_k),' kelvin']);


%% Calculate the pressure and density at the test altitude

testpress_nm = (testtemp_k/airfieldtemp_k)^(-g/(a*R)) * airfieldpress_nm;
Rho = (testtemp_k/airfieldtemp_k)^(-1*((g/(a*R))+1)) * airfieldrho;


end

