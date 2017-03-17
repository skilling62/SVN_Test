% This function is called by the model when the simulation stops.
% A runtests function is called, which outputs the results of the user
% specified test as a .csv 

StampTime = datestr(now,'(HH.MM.SS)(dd.mm.yy)');
addpath Model_Post_Processing_Scripts

% List of available tests
%% Model Verification
%     Results_IsolationValve_Emergency_Valve
%     Results_Selector_Valve
%     Results_Uplocks
%     Results_Shuttle_Valves
%     Results_Actuators
    
%% System Verification
%    Results_test1
%    Results_test2
%    Results_test3
%    Results_test4
%    Results_test5
%    Results_test6
%    Results_test7
%    Results_test8
%    Results_test9
%    Results_test10
%    Results_test11
%    Results_test12
%    Results_test13
%    Results_test14
%    Results_test15
%    Results_test16
%    Results_test17
%    Results_test18
%    Results_test19
%    Results_test20
%    Results_test21
%    Results_test22


%% Run test and export results to .csv 
% testname = 'Results_test22';
% result = runtests(testname);
% rt = table(result);
% cd('../Test_Results')
% testname(length(testname)+1:length(testname)+20) = StampTime;
% testname(length(testname)+1:length(testname)+4) = '.csv';
% writetable(rt,testname);