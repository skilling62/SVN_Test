% This is the function called by the model when the simulation stops
% A runtests function is called, which outputs the results of the user
% specified test as a .csv 

result = runtests('analyseTest');
rt = table(result);
cd('../Test_Results')
writetable(rt,'results.csv');