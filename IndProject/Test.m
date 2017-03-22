clc

%% Initialise visual odometry by extracting features in the first frame
% Need to review when the first frame should be taken
prevPoints = detectSURFFeatures(s(1).cdata);
prevFeatures = extractFeatures(s(1).cdata,prevPoints);

% Initialise a viewset object
vSet = viewSet;
viewId = 1;

% Original View
view0 = [1 0 0;0 0 -1;0 1 0];
vSet = addView(vSet, viewId, 'Points', prevPoints, 'Orientation', ...
    eye(3,'like',prevPoints.Orientation), 'Location', ...
    zeros(1, 3, 'like', prevPoints.Location));

%% Display Features
figure;
imshow(s(1).cdata); hold on; plot(prevPoints,'showOrientation',true);
title('Detected Features','fontsize',20);

%%
for i = 2:12
    currPoints = detectSURFFeatures(s(i).cdata);
    currFeatures = extractFeatures(s(i).cdata,currPoints);
    indexPairs = matchFeatures(prevFeatures,currFeatures);
    matchedPoints1 = prevPoints(indexPairs(:,1),:);
    matchedPoints2 = currPoints(indexPairs(:,2),:);
    
    %% Display Matched Features
%     figure;
%     showMatchedFeatures(s(i-1).cdata,s(i).cdata,matchedPoints1,matchedPoints2,'montage');
%     title('Initial Feature Matching Between Frames','fontsize',20);
    
    %% Filter Out Outliers using RANSAC (Random Sample Consensus)
    % Estimate the geometric transform between the frames
    [tform, inlierPoints1, inlierPoints2] = estimateGeometricTransform...
    (matchedPoints1, matchedPoints2, 'affine');
%     figure;
%     showMatchedFeatures(s(i-1).cdata, s(i).cdata, inlierPoints1, inlierPoints2,...
%     'montage');
%     title('RANSAC Filtered Matches','fontsize',20);
    %% Select 5 Inliers
    iteration = floor((size(inlierPoints1,1))/5);
    spacing = 1:iteration:iteration*5;

    for j = 1:length(spacing)
        inlierPoints1(j) = inlierPoints1(spacing(j));
        inlierPoints2(j) = inlierPoints2(spacing(j));
    end
    inlierpoints1 = inlierPoints1(1:5);
    inlierpoints2 = inlierPoints2(1:5);
    
    %% Plot 5 Inliers
%     showMatchedFeatures(s(i-1).cdata, s(i).cdata, inlierpoints1, inlierpoints2,...
%     'montage');
%     title('5 RANSAC Filtered Matches','fontsize',20);
%     
    %% Calculate the Essential Matrix
    % Use this to determine the relative orientation of the two images

        [relativeOrient, relativeLoc, inlierIdx] = helperEstimateRelativePose(...
        matchedPoints1, matchedPoints2, cameraParams);
    
    %% Populate the viewset object
    % Add current view to the view set
    vSet = addView(vSet,i, 'Points', currPoints);
    
    % Store the point matches between the previous and the current view
    % (review this line)
    vSet = addConnection(vSet, i-1, i, 'Matches', indexPairs(inlierIdx,:));
    
    % Get the table containing the previous camera pose (link to odometry)
    prevPose = poses(vSet, i-1);
    prevOrientation = prevPose.Orientation{1};
    prevLocation    = prevPose.Location{1};
    
    % Compute the current camera pose in the global coordinate system
    % relative to the first view.
    orientation = relativeOrient * prevOrientation;
    location    = prevLocation + relativeLoc * prevOrientation;
    vSet = updateView(vSet, i, 'Orientation', orientation, ...
        'Location', location);
    
    % Find point tracks across all views.
    tracks = findTracks(vSet);

    % Get the table containing camera poses for all views.
    camPoses = poses(vSet);
    
     % Triangulate initial locations for the 3-D world points.
    xyzPoints = triangulateMultiview(tracks, camPoses, cameraParams);

    % Refine the 3-D world points and camera poses.
    [xyzPoints, camPoses, reprojectionErrors] = bundleAdjustment(xyzPoints, ...
        tracks, camPoses, cameraParams, 'FixedViewId', 1, ...
        'PointsUndistorted', true);

    % Store the refined camera poses.
    vSet = updateView(vSet, camPoses);

    prevFeatures = currFeatures;
    prevPoints   = currPoints;
end

%%
% Display camera poses.
camPoses = poses(vSet);
figure;
plotCamera(camPoses, 'Size', 0.2, 'Opacity', 0);
hold on

% Exclude noisy 3-D points.
goodIdx = (reprojectionErrors < 5);
xyzPoints = xyzPoints(goodIdx, :);

% Display the 3-D points.
pcshow(xyzPoints, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', ...
    'MarkerSize', 45);
grid on

% Specify the viewing volume.
loc1 = camPoses.Location{1};
xlim([loc1(1)-10, loc1(1)+10]);
ylim([loc1(2)-10, loc1(2)+10]);
zlim([loc1(3)-10, loc1(3)+10]);

% Set up the axis convention
set(gca,'YDir','reverse','ZDir','reverse')
view(-60,30)
xlabel('X')
ylabel('Y')
zlabel('Z')
title('Refined Camera Poses');

