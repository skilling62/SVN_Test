%%

% Read the timestamp of the first frame in the sequence
find(time>s(1).timestamp,1);

% Get pose data in the axis system used by plot camera
posInCam = zeros(size(pos));
posInCam(:,1) = pos(:,2);
posInCam(:,2) = pos(:,3)*-1;
posInCam(:,3) = pos(:,1);

posInCam = posInCam(1:64:length(posInCam),:);
Location = cell(length(posInCam),1);

for i = 1:length(posInCam)
    Location{i} = posInCam(i,:);
end

groundTruth = table(Location);

%% Initialise visual odometry by extracting features in the first frame
% Need to review when the first frame should be taken

prevPoints = detectSURFFeatures(s(1).cdata);
prevFeatures = extractFeatures(s(1).cdata,prevPoints);

% Initialise a viewset object
vSet = viewSet;
viewId = 1;

% Original View - Camera Faces the down the positive z axis
vSet = addView(vSet, viewId, 'Points', prevPoints, 'Orientation', ...
    eye(3), 'Location', zeros(1, 3));

%% Plot Initial Camera Pose
figure
axis([-5, 5, -5, 5, -5, 5]);

% Set Y-axis to be vertical pointing down.
view(gca, 3);
set(gca, 'CameraUpVector', [0, -1, 0]);
camorbit(gca, -120, 0, 'data', [0, 1, 0]);

grid on
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
hold on

% Plot camera from observations
camObs =  plotCamera('Size', 0.1, 'Location',...
    vSet.Views.Location{1}, 'Orientation', vSet.Views.Orientation{1},...
    'Color', 'g', 'Opacity', 0);

% Plot camera from observations
camNav = plotCamera('Size', 0.1, 'Location', posInCam(1,:), 'Orientation', ...
    eye(3), 'Color', 'b', 'Opacity', 0);

% Initialize camera trajectories.
trajectoryObs = plot3(0, 0, 0, 'g-');
trajectoryNav = plot3(0, 0, 0, 'b-');

legend('Estimated Trajectory', 'Actual Trajectory');
title('Camera Trajectory');

%% 
i = 2;
  
% Match features between the previous and the current image.
[currPoints, currFeatures, indexPairs] = helperDetectAndMatchFeatures(...
prevFeatures, s(i).cdata);

% Estimate the pose of the current view relative to the previous view.
[orient, loc, inlierIdx] = helperEstimateRelativePose(...
prevPoints(indexPairs(:,1)), currPoints(indexPairs(:,2)), cameraParams);
  
% Exclude epipolar outliers.
indexPairs = indexPairs(inlierIdx, :);

% Add the current view to the view set.
vSet = addView(vSet, i, 'Points', currPoints, 'Orientation', orient, ...
    'Location', loc);

% Store the point matches between the previous and the current views.
vSet = addConnection(vSet, i-1, i, 'Matches', indexPairs);
    
    %%

    warningstate = warning('off', 'vision:ransac:maxTrialsReached');
    
    [relativeOrient, relativeLoc, inlierIdx] = helperEstimateRelativePose(...
    matchedPoints1, matchedPoints2, cameraParams);
    
    warning(warningstate)

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
    


%%
camPoses = poses(vSet);
locations = cat(1, camPoses.Location{:});
set(trajectoryObs, 'XData', locations(:,1), 'YData', ...
    locations(:,2), 'ZData', locations(:,3));

camObs.Location = vSet.Views.Location{i};
camObs.Orientation = vSet.Views.Orientation{i};

locationsNav = cat(1, groundTruth.Location{:});
set(trajectoryNav, 'XData', locationsNav(:,1), 'YData', locationsNav(:,2),...
    'ZData', locationsNav(:,3));

