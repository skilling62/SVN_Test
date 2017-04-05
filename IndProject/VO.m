% -------------------------------------------------------------------------
% Compute camera path up to an unkown scale factor using Visual Odometry
% https://uk.mathworks.com/help/vision/examples/structure-from-motion-from-multiple-views.html
% -------------------------------------------------------------------------

%% Initialise visual odometry by extracting features in the first frame
% Need to review when the first frame should be taken

prevPoints = detectSURFFeatures(s(1).cdata);
prevFeatures = extractFeatures(s(1).cdata,prevPoints);

% Initialise a viewset object to store the camera views
vSet = viewSet;
viewId = 1;

% Add original view - camera at origin + faces the down the positive z axis
vSet = addView(vSet, viewId, 'Points', prevPoints, 'Orientation', ...
    eye(3, 'like', prevPoints.Location), 'Location', ...
    zeros(1, 3, 'like', prevPoints.Location));

%%  Estimate remaining views
for i = 2:56
    
    % Detect, extract and match features.
    currPoints   = detectSURFFeatures(s(i).cdata);
    currFeatures = extractFeatures(s(i).cdata, currPoints);
    indexPairs = matchFeatures(prevFeatures, currFeatures, 'Unique', true);
    
    % Select matched points.
    matchedPoints1 = prevPoints(indexPairs(:, 1));
    matchedPoints2 = currPoints(indexPairs(:, 2));
    
    % Disable RANSAC warning
    warningstate = warning('off', 'vision:ransac:maxTrialsReached');
    
    % Calculate pose of current view with respect to previous view
    [relativeOrient, relativeLoc, inlierIdx] = helperEstimateRelativePose(...
    matchedPoints1, matchedPoints2, cameraParams);

    % Re enable RANSAC warning
    warning(warningstate)

    % Add the current view to the view set
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
    
    % Update viewset with current location and orientation
    
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

% Plot the final camera orientation
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
xlim([loc1(1)-10, loc1(1)+10]);
ylim([loc1(2)-10, loc1(2)+10]);
zlim([loc1(3)-10, loc1(3)+10]);
camorbit(0, -30);

title('Refined Camera Poses');