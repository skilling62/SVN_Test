% This is the function called by the model when the simulation stops
% A runtests function is called, which outputs the results of the user
% specified test as a .csv 

% List of tests
% Model Verification Tests
    % Results_IsolationValve_Emergency_Valve
    % Results_Shuttle_Valves

result = runtests('Results_Shuttle_Valves');
rt = table(result);
cd('../Test_Results')
writetable(rt,'results.csv');