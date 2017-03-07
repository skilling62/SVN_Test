% If implement as a function, inputs are frame to read and pose 
%% Get current frame and extract Features
k = 1;
greyFrame = (s(k).cdata);
points = detectSURFFeatures(greyFrame);
[feats, validpts] = extractFeatures(greyFrame, points);

%% Transform xf and yf to xw and yw



%% Transform xw and yw to xmap and ymap



%% Store the descriptors 



%% Query stored descriptors (narrow down based on estimated pos)



%% Brute force matching (Return Absolute Position Estimate)


