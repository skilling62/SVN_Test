result = runtests('stevenTest');
rt = table(result);
writetable(rt,'results.csv');