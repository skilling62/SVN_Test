%% Initialise visual odometry by extracting features in the first frame
% Need to review when the first frame should be taken
border = 50;
roi = [border, border, size(s(1).cdata, 2)- 2*border, size(s(1).cdata, 1)- 2*border];

prevPoints = detectSURFFeatures(s(1).cdata);
prevFeatures = extractFeatures(s(1).cdata,prevPoints, 'Upright', true);

% Initialise a viewset object
vSet = viewSet;
viewId = 1;

% Original View - Camera Faces the down the positive z axis
vSet = addView(vSet, viewId, 'Points', prevPoints, 'Orientation', ...
    eye(3, 'like', prevPoints.Location), 'Location', ...
    zeros(1, 3, 'like', prevPoints.Location));
%% 
for i = 2:44
    % Detect, extract and match features.
    currPoints   = detectSURFFeatures(s(i).cdata);
    currFeatures = extractFeatures(s(i).cdata, currPoints, 'upright', true);
    indexPairs = matchFeatures(prevFeatures, currFeatures, 'Unique', true);

    % Select matched points.
    matchedPoints1 = prevPoints(indexPairs(:, 1));
    matchedPoints2 = currPoints(indexPairs(:, 2));
    
    [relativeOrient, relativeLoc, inlierIdx] = helperEstimateRelativePose(...
    matchedPoints1, matchedPoints2, cameraParams);

    % Add the current view to the view set.
    vSet = addView(vSet, i, 'Points', currPoints);

    % Store the point matches between the previous and the current views.
    vSet = addConnection(vSet, i-1, i, 'Matches', indexPairs(inlierIdx,:));
    
    % Get the table containing the previous camera pose.
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

%% For the i'th view display matches
figure;
showMatchedFeatures(s(i-1).cdata,s(i).cdata,matchedPoints1,matchedPoints2,'montage');
title('Feature Matching Between Frames','fontsize',20)

%% Display camera poses.
camPoses = poses(vSet);
figure;
plotCamera('Size', 0.3,'Location',vSet.Views.Location{1},'Orientation',vSet.Views.Orientation{1});
hold on

% Plot the estimated trajectory.
trajectoryObs = plot3(0,0,0, 'g-','LineWidth',1.5);
locations = cat(1, camPoses.Location{:});
set(trajectoryObs, 'XData', locations(:,1), 'YData', ...
    locations(:,2), 'ZData', locations(:,3));

plotCamera('Size', 0.3,'Location',vSet.Views.Location{i},'Orientation',vSet.Views.Orientation{i});

% Exclude noisy 3-D points.
goodIdx = (reprojectionErrors < 5);
xyzPoints = xyzPoints(goodIdx, :);

% Display the 3-D points.
pcshow(xyzPoints, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', ...
    'MarkerSize', 45);
grid on

xlabel('X')
ylabel('Y')
zlabel('Z')
hold off

% Specify the viewing volume.
loc1 = camPoses.Location{1};
xlim([loc1(1)-2, loc1(1)+15]);
ylim([loc1(2)-10, loc1(2)+10]);
zlim([loc1(3)-2, loc1(3)+15]);
camorbit(0, -30);

title('Refined Camera Poses');

%% Compute Dense Reconstruction
% Go through the images again. This time detect a dense set of corners,
% and track them across all views using |vision.PointTracker|.

% Detect corners in the first image.
prevPoints = detectMinEigenFeatures(s(1).cdata, 'MinQuality', 0.001);

% Create the point tracker object to track the points across views.
tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 6);

% Initialize the point tracker.
prevPoints = prevPoints.Location;
initialize(tracker, prevPoints, s(1).cdata);

% Store the dense points in the view set.
vSet = updateConnection(vSet, 1, 2, 'Matches', zeros(0, 2));
vSet = updateView(vSet, 1, 'Points', prevPoints);

% Track the points across all views.
for i = 2:4
    
    % Track the points.
    [currPoints, validIdx] = step(tracker, s(i).cdata);
    
    % Clear the old matches between the points.
    if i < 44
        vSet = updateConnection(vSet, i, i+1, 'Matches', zeros(0, 2));
    end
    vSet = updateView(vSet, i, 'Points', currPoints);
    
    % Store the point matches in the view set.
    matches = repmat((1:size(prevPoints, 1))', [1, 2]);
    matches = matches(validIdx, :);        
    vSet = updateConnection(vSet, i-1, i, 'Matches', matches);
end

% Find point tracks across all views.
tracks = findTracks(vSet);

% Find point tracks across all views.
camPoses = poses(vSet);

% Triangulate initial locations for the 3-D world points.
xyzPoints = triangulateMultiview(tracks, camPoses,...
    cameraParams);

% Refine the 3-D world points and camera poses.
[xyzPoints, camPoses, reprojectionErrors] = bundleAdjustment(...
    xyzPoints, tracks, camPoses, cameraParams, 'FixedViewId', 1, ...
    'PointsUndistorted', true);

%% Display Dense Reconstruction
% Display the camera poses and the dense point cloud.

% Display the refined camera poses.
figure;
plotCamera(camPoses, 'Size', 0.2);
hold on

% Exclude noisy 3-D world points.
goodIdx = (reprojectionErrors < 5);

% Display the dense 3-D world points.
pcshow(xyzPoints(goodIdx, :), 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', ...
    'MarkerSize', 45);
grid on
hold off

% Specify the viewing volume.
loc1 = camPoses.Location{1};
xlim([loc1(1)-2, loc1(1)+8]);
ylim([loc1(2)-10, loc1(2)+10]);
zlim([loc1(3)-2, loc1(3)+12]);
camorbit(0, -30);

title('Dense Reconstruction');