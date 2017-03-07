%% Feature Detection
% detectSURFFeatures returns an array with length = number of detected
% features. points.Location contains [x y] point co-ordinates
greyFrame1 = (s(300).cdata);
greyFrame2 = (s(301).cdata);
points1 = detectSURFFeatures(greyFrame1);
points2 = detectSURFFeatures(greyFrame2);

%% Feature Description. 
% Can use points.selectStrongest(number) for best features only
% (EXPERIMENT WITH NUMBER OF FEATURES)
% ExtractFeatures returns feature vectors(64d descriptors) and valid points 
% associated with each output descriptor
[feats1, validpts1] = extractFeatures(greyFrame1, points1);
[feats2, validpts2] = extractFeatures(greyFrame2, points2);

%% Display Features
figure;
imshow(greyFrame1); hold on; plot(validpts1,'showOrientation',true);
title('Detected Features','fontsize',20);

%% Match Features
% matchFeatures returns indices of the matching features in the two input
% descriptor sets
indexPairs = matchFeatures(feats1,feats2);
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