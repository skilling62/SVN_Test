 
mkdir Tests
TestCaseNum = 0;
PathLog = ['Tests/TestCase_'  num2str(TestCaseNum)  '.txt'];
StampTime = datestr(now,'HH:MM:SS dd/mm/yy \n');

A  = rand(10,1);
B = rand(10,1);
header = ['Landing Gear - Test Case '  num2str(TestCaseNum)  ''];
fid = fopen(PathLog,'w');
fprintf(fid, [ header '\n']);
fprintf(fid, '%s\n', StampTime);
fprintf(fid, '%f %f \n', [A B]');
fclose(fid);

