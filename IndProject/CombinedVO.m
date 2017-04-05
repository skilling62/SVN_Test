% -------------------------------------------------------------------------
% poseEstimate.m should be run before runnng this file
% Plot the position estimate from both VO.m and pose Estimate.m
% Use the estimate from drone navdata to estimate the scale of the scene
% https://uk.mathworks.com/help/vision/examples/structure-from-motion-from-multiple-views.html
% https://uk.mathworks.com/help/vision/examples/monocular-visual-odometry.html
% -------------------------------------------------------------------------

%% Create a table of camera poses that is aligned with each camera view

% Read the timestamp of the first frame in the sequence. Use this timestamp
% to find the corresponding navdata pose estimate
index = find(time>s(1).timestamp,1);
newLength = size(pos,1) - index +1;

% Get pose data in the axis system used by plot camera function (x axis
% becomes z axis, y axis becomes x axis, z becomes y
posInCam = zeros(newLength,size(pos,2));
posInCam(:,1) = pos(index:length(pos),2);
posInCam(:,2) = pos(index:length(pos),3)*-1;
posInCam(:,3) = pos(index:length(pos),1);

% Place the first navdata view in the origin of the camera coordinate system 
offset = zeros(1,3) - posInCam(1,:);
posInCam = posInCam(1:(200/frameRate):length(posInCam),:)+offset;
Location = cell(length(posInCam),1);

for i = 1:length(posInCam)
    Location{i} = posInCam(i,:);
end

% Position estimate from navdata in the camera axis system (table format)
groundTruth = table(Location);

%% Initialise visual odometry by extracting features in the first frame
prevPoints = detectSURFFeatures(s(1).cdata);
prevFeatures = extractFeatures(s(1).cdata,prevPoints);

% Initialise a viewset object
vSet = viewSet;
viewId = 1;

% Original View - Camera Faces the down the positive z axis
vSet = addView(vSet, viewId, 'Points', prevPoints, 'Orientation', ...
    eye(3), 'Location', zeros(1,3));

%% Plot Initial Camera Pose
figure
axis([-4, 4, -2, 5, -2, 2]);

% Set Y-axis to be vertical pointing down.
view(gca, 3);
set(gca, 'CameraUpVector', [0, -1, 0]);
camorbit(gca, -120, 0, 'data', [0, 1, 0]);

grid on
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
hold on

% Plot camera from VO
camObs =  plotCamera('Size', 0.1, 'Location',...
    vSet.Views.Location{1}, 'Orientation', vSet.Views.Orientation{1},...
    'Color', 'g', 'Opacity', 0);

% Plot camera from navdata
camNav = plotCamera('Size', 0.1, 'Location', posInCam(1,:), 'Orientation', ...
    eye(3), 'Color', 'b', 'Opacity', 0);

% Initialize camera trajectories.
trajectoryObs = plot3(0, 0, 0, 'g-');
trajectoryNav = plot3(0, 0, 0, 'b-');

legend('VO Trajectory', 'INS Trajectory');
title('Camera Trajectory');

%%  Plot the second view
i = 2;
  
% Match features between the previous and the current image.
currPoints   = detectSURFFeatures(s(i).cdata);
currFeatures = extractFeatures(s(i).cdata, currPoints);
indexPairs = matchFeatures(prevFeatures, currFeatures, 'Unique', true);

matchedPoints1 = prevPoints(indexPairs(:, 1));
matchedPoints2 = currPoints(indexPairs(:, 2));
    
% Estimate the pose of the current view relative to the previous view.
[relativeOrient, relativeLoc, inlierIdx] = helperEstimateRelativePose(...
matchedPoints1, matchedPoints2, cameraParams);

% Get the table containing the previous camera pose.
prevPose = poses(vSet, i-1);
prevOrientation = prevPose.Orientation{1};
prevLocation    = prevPose.Location{1};

% Compute the current camera pose in the global coordinate system
% relative to the first view.
orientation = relativeOrient * prevOrientation;
location    = prevLocation + relativeLoc * prevOrientation;

vSet = addView(vSet, i, 'Points', currPoints, 'Orientation', orientation, ...
        'Location', location);

% Store the point matches between the previous and the current views.
vSet = addConnection(vSet, i-1, i, 'Matches', indexPairs(inlierIdx,:));

% Compute scale factor using estimated positions from the navdata
vSet = helperNormalizeViewSet(vSet, groundTruth);

prevPoints   = currPoints;
prevFeatures = currFeatures;

%% Plot Second View

% Plot camera trajectory (VO)
camPoses = poses(vSet);
locations = cat(1, camPoses.Location{i});
set(trajectoryObs, 'XData', locations(:,1), 'YData', ...
    locations(:,2), 'ZData', locations(:,3));

% Plot camera view (VO)
camObs.Location = vSet.Views.Location{i};
camObs.Orientation = vSet.Views.Orientation{i};

% Plot camera trajectory (navdata)
locationsNav = cat(1, groundTruth.Location{1:i});
set(trajectoryNav, 'XData', locationsNav(:,1), 'YData', locationsNav(:,2),...
    'ZData', locationsNav(:,3));

%% Plot the remaining views
for i = 3:56

    currPoints   = detectSURFFeatures(s(i).cdata);
    currFeatures = extractFeatures(s(i).cdata, currPoints);
    indexPairs = matchFeatures(prevFeatures, currFeatures, 'Unique', true);
    
    matchedPoints1 = prevPoints(indexPairs(:, 1));
    matchedPoints2 = currPoints(indexPairs(:, 2));

    warningstate = warning('off', 'vision:ransac:maxTrialsReached');

    [relativeOrient, relativeLoc, inlierIdx] = helperEstimateRelativePose(...
    matchedPoints1, matchedPoints2, cameraParams);

    warning(warningstate)
    
    % Get the table containing the previous camera pose.
    prevPose = poses(vSet, i-1);
    prevOrientation = prevPose.Orientation{1};
    prevLocation    = prevPose.Location{1};

    % Compute the current camera pose in the global coordinate system
    % relative to the first view.
    orientation = relativeOrient * prevOrientation;
    location    = prevLocation + relativeLoc * prevOrientation;

    vSet = addView(vSet, i, 'Points', currPoints, 'Orientation', orientation, ...
        'Location', location);
    
    vSet = addConnection(vSet, i-1, i, 'Matches', indexPairs(inlierIdx,:));
    
    % Find point tracks across all views.
    tracks = findTracks(vSet);

    % Get the table containing camera poses for all views.
    camPoses = poses(vSet);

    % Triangulate initial locations for the 3-D world points.
    xyzPoints = triangulateMultiview(tracks, camPoses, cameraParams);
    
    [~, camPoses, reprojectionErrors] = bundleAdjustment(xyzPoints, ...
        tracks, camPoses, cameraParams, 'FixedViewId', 1, ...
        'PointsUndistorted', true);
    
    vSet = updateView(vSet, camPoses);
    
    % Compute scale factor using estimated positions from the navdata
    vSet = helperNormalizeViewSet(vSet, groundTruth);
    
    prevFeatures = currFeatures;
    prevPoints = currPoints;
    
end
    
%% Display matched features between last and second to last views
figure;
showMatchedFeatures(s(i-1).cdata,s(i).cdata,matchedPoints1,matchedPoints2,'montage');
title('Feature Matching Between Frames','fontsize',20)

%% Plot Final View

% Plot camera trajectory (VO)
camPoses = poses(vSet);
locations = cat(1, camPoses.Location{:});
set(trajectoryObs, 'XData', locations(:,1), 'YData', ...
    locations(:,2), 'ZData', locations(:,3));

% Plot final camera view (VO)
camObs.Location = vSet.Views.Location{i};
camObs.Orientation = vSet.Views.Orientation{i};

% Plot camera trajectory (navdata)
locationsNav = cat(1, groundTruth.Location{:});
set(trajectoryNav, 'XData', locationsNav(:,1), 'YData', locationsNav(:,2),...
    'ZData', locationsNav(:,3));

%% Calculate the magnitudes of the distance between navdata and VO positions
distance = zeros(vSet.NumViews,1);
axisx = zeros(vSet.NumViews,1);
for i = 1:vSet.NumViews
distance(i,1) = sqrt((vSet.Views.Location{i}(1) - groundTruth.Location{i}(1))^2 ...
    + (vSet.Views.Location{i}(2) - groundTruth.Location{i}(2))^2 ...
    + (vSet.Views.Location{i}(3) - groundTruth.Location{i}(3))^2);
axisx(i,1) = s(i).timestamp - s(1).timestamp;
end

figure
plot(axisx,distance)
title('Position Estimation Delta Between VO and INS')
xlabel('Time(s)')
ylabel('Distance(m)')
grid minor