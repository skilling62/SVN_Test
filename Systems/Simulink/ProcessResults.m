result = runtests('analyseTest');
rt = table(result);
writetable(rt,'results.csv');