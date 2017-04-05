function [E] = Debug()

% -------------------------------------------------------------------------
% This function was used to play video feeds and observe features at any 
% given frame. Mathcing parameters were also investigated
% -------------------------------------------------------------------------

%% Play Video File
s_ = evalin('base','s');
camera = evalin('base','cameraParams');
implay(s_)

%% Test Section
greyFrame1 = (s_(frameNumber-1).cdata);
greyFrame2 = (s_(frameNumber).cdata);
points1 = detectSURFFeatures(greyFrame1);
points2 = detectSURFFeatures(greyFrame2);

[feats1, validpts1] = extractFeatures(greyFrame1, points1);
[feats2, validpts2] = extractFeatures(greyFrame2, points2);

% matchFeatures returns indices of the matching features in the two input
% descriptor sets
indexPairs = matchFeatures(feats1,feats2,'MaxRatio',1.0);
% Find the locations of the corresponding poits for each image (spatial
% coordinate system is used)
matchedPoints1 = validpts1(indexPairs(:,1),:);
matchedPoints2 = validpts2(indexPairs(:,2),:);

%% Display Matched Features
figure;
showMatchedFeatures(greyFrame1,greyFrame2,matchedPoints1,matchedPoints2,'montage');
title('Initial Feature Matching Between Frames','fontsize',20);

%% Filter Out Outliers using RANSAC (Random Sample Consensus)
% Estimate the geometric transform between the frames
[tform, inlierPoints1, inlierPoints2] = estimateGeometricTransform...
    (matchedPoints1, matchedPoints2, 'affine');
figure;
showMatchedFeatures(greyFrame1, greyFrame2, inlierPoints1, inlierPoints2,...
    'montage');
title('RANSAC Filtered Matches','fontsize',20);

end

