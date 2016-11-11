% =========================================================================
% Function to calculate aircraft Centre of Gravity
% Group 19
%
% =========================================================================

function [centre_of_gravity, Total_Weight] = Centre_Of_Gravity(Basic_Empty_Weight, Payload_Weight);
% moment arm values - inches aft of datum
Weight_Arm = 0.075;
Payload_Arm = 0.075;

% % Moment Calculations - Array Method

% Weight and moment arm array defition.
Weight_Array = [Basic_Empty_Weight, Payload_Weight];
Arm_Array = [Weight_Arm, Payload_Arm];

% Total Weight of Aircraft - hint: use help sum to see why the 2 is
% required
Total_Weight = sum(Weight_Array, 2);

% Total moment of aircraft
Moment_Array = Weight_Array.*Arm_Array;
Total_Moment = sum(Moment_Array, 2);

% Centre of Gravity (inches aft of datum)
centre_of_gravity = Total_Moment/Total_Weight;

end
