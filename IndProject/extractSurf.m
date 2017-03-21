%% Feature Detection
% detectSURFFeatures returns an array with length = number of detected
% features. points.Location contains [x y] point co-ordinates
greyFrame1 = (s(150).cdata);
greyFrame2 = (s(151).cdata);
points1 = detectSURFFeatures(greyFrame1);
points2 = detectSURFFeatures(greyFrame2);

%% Feature Description. 
% ExtractFeatures returns feature vectors(64d descriptors) and valid points 
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

%% Select 5 Inliers
iteration = floor((size(inlierPoints1,1))/5);
spacing = 1:iteration:iteration*5;

for i = 1:length(spacing)
    inlierPoints1(i) = inlierPoints1(spacing(i));
    inlierPoints2(i) = inlierPoints2(spacing(i));
end
inlierpoints1 = inlierPoints1(1:5);
inlierpoints2 = inlierPoints2(1:5);

%% Plot 5 Inliers
showMatchedFeatures(greyFrame1, greyFrame2, inlierpoints1, inlierpoints2,...
    'montage');
title('RANSAC Filtered Matches','fontsize',20);

%% Estimate the essential matrix from corresponding points in a pair of images
% For the essential matrix, both non zero singular values are identical
% The essential matrix is of rank 2
% The essential matrix is homogeneus and |E| = 0
[E,inliersIndex] = estimateEssentialMatrix(inlierpoints1,inlierpoints2,cameraParams);
computedInliers = length(inliersIndex(inliersIndex==1));

%% Corresponding Points Test
% Normalize the points (between -1 and 1)
xPixPrime = inlierpoints1(5).Location';
xPixPrime(3) = 1;
xPixPPrime = inlierpoints2(5).Location';
xPixPPrime(3) = 1;
c = cameraParams.IntrinsicMatrix;

% Calculate the direction in the camera frame of two corresponding points
direction1 = (inv(c))*xPixPrime;
direction2 = (inv(c))*xPixPPrime;
quiver3(0,0,0,direction1(1), direction1(2), direction1(3))
hold on
quiver3(0,0,0,direction2(1), direction2(2), direction2(3))
hold off
% direction1' * (E * xPixPPrime)
(direction2' * E) * direction1

%% Tester from "SFM From Multiple Views" - the Mathworks
[relativeOrient, relativeLoc, inlierIdx] = helperEstimateRelativePose(...
        inlierpoints1, inlierpoints2, cameraParams)
