%   
%   =======================================================================
%
%   The CG_Calculations function, calculates the the Centre of gravity 
%   of the jetstream, using the data from Group 3's test flight.
%   
%   Created: 14th Novemeber 2016        Version: v1.0
%   
%   A/C = Aircraft 
%   CG = Centre of Gravity 
%   CO = 
%   m = mass
%   StRow = Seat Row
%
%   =======================================================================
%
%



function [CG, Total_Weight] = CG_Calculations ()

global CG m 

% Array created for the A/C Arms and Weights

%               M       A/C     StRow3  StRow4  StRow5  StRow6  CO
Arm_Array  =   [5.643   5.569   5.400   6.370   7.130   7.890   8.550];  
Weight_Array = [m    4949    60      207     149     239     85   ];

% Momonet are calculated using the Arm length times by the Weight at the
% individal arm lengths
Moment_Array = Weight_Array.*Arm_Array;

% The Total Moment of the A/C 
Total_Moment = sum(Moment_Array, 2);

% The Total Weight of the A/C
Total_Weight = sum(Weight_Array, 2); 

% CG Calculated from the Total_Moment and Total_Weight
CG = ((Total_Moment / Total_Weight) - 5.149) * (100/1.717);

end