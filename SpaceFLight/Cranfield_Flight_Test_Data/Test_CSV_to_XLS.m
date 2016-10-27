yourfolder='\\nstu-uwe02.campus.ads.uwe.ac.uk\users2$\j69-lewis\Personal\MATLAB\Year 3\Cranfield Flight Test Data'
d=dir([yourfolder '\*.csv']);
files={d.name};
for k=1:numel(files)
   old_name=files{k}; 
   [~,~,b] = xlsread(old_name) ;
   new_name=strrep(old_name,'csv','xls')
   xlswrite(new_name,b);
end