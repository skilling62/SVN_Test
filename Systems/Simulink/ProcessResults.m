% This function is called by the model when the simulation stops.
% A runtests function is called, which outputs the results of the user
% specified test as a .csv 

% List of tests
% Model Verification Tests
    % Results_IsolationValve_Emergency_Valve
    % Results_Shuttle_Valves
    % Results_Uplocks

testname = 'Results_Shuttle_Valves';
result = runtests(testname);
rt = table(result);
cd('../Test_Results')
testname(length(testname)+1:length(testname)+4) = '.csv';
writetable(rt,testname);