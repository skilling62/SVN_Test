% This function is called by the model when the simulation stops.
% A runtests function is called, which outputs the results of the user
% specified test as a .csv 

StampTime = datestr(now,'_HH:MM:SS dd/mm/yy');
addpath Model_Post_Processing_Scripts

% List of available tests
%% Model Verification
%     Results_IsolationValve_Emergency_Valve
%     Results_Selector_Valves
%     Results_Uplocks
%     Results_Shuttle_Valves
    
%% System Verification
    
%% Run test and export results to .csv 
% testname = 'Results_Shuttle_Valves';
% result = runtests(testname);
% rt = table(result);
% cd('../Test_Results')
% testname(length(testname)+1:length(testname)+18) = StampTime;
% testname(length(testname)+1:length(testname)+4) = '.csv';
% writetable(rt,testname);