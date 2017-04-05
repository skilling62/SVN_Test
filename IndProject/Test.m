%% Create a table of camera poses that is aligned with each camera view
% Camera poses come from poseEstimate

% Read the timestamp of the first frame in the sequence
index = find(time>s(1).timestamp,1);
newLength = size(pos,1) - index +1;

% Get pose data in the axis system used by plot camera function (x axis
% becomes z axis, y axis becomes x axis, z becomes y
posInCam = zeros(newLength,size(pos,2));
posInCam(:,1) = pos(index:length(pos),2);
posInCam(:,2) = pos(index:length(pos),3)*-1;
posInCam(:,3) = pos(index:length(pos),1);

% Place the first view in the origin of the camera coordinate system 
offset = zeros(1,3) - posInCam(1,:);
posInCam = posInCam(1:(200/frameRate):length(posInCam),:)+offset;
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
    eye(3), 'Location', zeros(1,3));

%% Plot Initial Camera Pose
% Setup axis
figure
axis([-10, 10, -10, 10, -10, 10]);

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

% Plot camera from Navdata
camNav = plotCamera('Size', 0.1, 'Location', posInCam(1,:), 'Orientation', ...
    eye(3), 'Color', 'b', 'Opacity', 0);

% Initialize camera trajectories.
trajectoryObs = plot3(0, 0, 0, 'g-');
trajectoryNav = plot3(0, 0, 0, 'b-');

legend('Estimated Trajectory', 'Actual Trajectory');
title('Camera Trajectory');

%% ------------------------------------------------------------------------
% Estimate the pose of the second view
% -------------------------------------------------------------------------

% ViewId = 2
i = 2;

% Match features between the previous and the current image.
currPoints   = detectSURFFeatures(s(i).cdata);
currFeatures = extractFeatures(s(i).cdata, currPoints);
indexPairs = matchFeatures(prevFeatures, currFeatures, 'Unique',true);

matchedPoints1 = prevPoints(indexPairs(:, 1));
matchedPoints2 = currPoints(indexPairs(:, 2));
    
% Estimate the pose of the current view relative to the previous view.
[orient, loc, inlierIdx] = helperEstimateRelativePose(...
matchedPoints1, matchedPoints2, cameraParams);

indexPairs = indexPairs(inlierIdx,:);


% Add the current view to the view set.
vSet = addView(vSet, i, 'Points', currPoints, 'Orientation', orient, ...
    'Location', loc);

% Store the point matches between the previous and the current views.
vSet = addConnection(vSet, i-1, i, 'Matches', indexPairs);

% Compute scale factor
vSet = helperNormalizeViewSet(vSet, groundTruth);

prevPoints   = currPoints;
prevFeatures = currFeatures;

%% Plot Second View
camPoses = poses(vSet);
locations = cat(1, camPoses.Location{i});
set(trajectoryObs, 'XData', locations(:,1), 'YData', ...
    locations(:,2), 'ZData', locations(:,3));

camObs.Location = vSet.Views.Location{i};
camObs.Orientation = vSet.Views.Orientation{i};

locationsNav = cat(1, groundTruth.Location{1:i});
set(trajectoryNav, 'XData', locationsNav(:,1), 'YData', locationsNav(:,2),...
    'ZData', locationsNav(:,3));

%% Bootstrap Estimating Camera Trajectory Using Global Bundle Adjustment
for i = 3:10
    
    % Match features between the previous and the current image.
    currPoints = detectSURFFeatures(s(i).cdata);
    currFeatures = extractFeatures(s(i).cdata,currPoints);
    indexPairs = matchFeatures(prevFeatures,currFeatures,'unique',true);
    
    % Eliminate outliers from feature matches.
    inlierIdx = helperFindEpipolarInliers(prevPoints(indexPairs(:,1)),...
        currPoints(indexPairs(:,2)), cameraParams);

    indexPairs = indexPairs(inlierIdx, :);
    
    % Triangulate points from the previous two views, and find the
    % corresponding points in the current view.
    [worldPoints, imagePoints] = helperFind3Dto2DCorrespondences(vSet,...
        cameraParams, indexPairs, currPoints);
    
    warningstate = warning('off','vision:ransac:maxTrialsReached');
    
    %% Estimate the world camera pose for the current view.
    % 99.9 and 0.8
    [orient, loc] = estimateWorldCameraPose(imagePoints, worldPoints, ...
        cameraParams, 'Confidence', 99.0, 'MaxReprojectionError', 0.9);
    
    % Restore the original warning state
    warning(warningstate)
    
    %% Add current view to the view set
    vSet = addView(vSet,i, 'Points', currPoints, 'Orientation', ...
        orient, 'Location', loc);
    
    % Store the point matches between the previous and the current views.
    vSet = addConnection(vSet, i-1, i, 'Matches', indexPairs);
    
    tracks = findTracks(vSet);
    
    camPoses = poses(vSet);
    
    % Triangulate initial locations for the 3-D world points.
    xyzPoints = triangulateMultiview(tracks, camPoses, cameraParams);
    
    % Refine camera poses using bundle adjustment.
    [~, camPoses] = bundleAdjustment(xyzPoints, tracks, camPoses, ...
        cameraParams, 'PointsUndistorted', true, 'AbsoluteTolerance', 1e-9,...
        'RelativeTolerance', 1e-9, 'MaxIterations', 300);
    
    % Update the view set
    vSet = updateView(vSet, camPoses);
    
    vSet = helperNormalizeViewSet(vSet, groundTruth);
    
    prevFeatures = currFeatures;
    prevPoints = currPoints;
    
end

%% Display matched features
figure;
showMatchedFeatures(s(i-1).cdata,s(i).cdata,matchedPoints1,matchedPoints2,'montage');
title('Feature Matching Between Frames','fontsize',20)

%% Plot View
camPoses = poses(vSet);
locations = cat(1, camPoses.Location{:});
set(trajectoryObs, 'XData', locations(:,1), 'YData', ...
    locations(:,2), 'ZData', locations(:,3));

camObs.Location = vSet.Views.Location{i};
camObs.Orientation = vSet.Views.Orientation{i};

locationsNav = cat(1, groundTruth.Location{:});
set(trajectoryNav, 'XData', locationsNav(:,1), 'YData', locationsNav(:,2),...
    'ZData', locationsNav(:,3));

%% 
for i = 11:145
    
    % Match features between the previous and the current image.
    currPoints = detectSURFFeatures(s(i).cdata);
    currFeatures = extractFeatures(s(i).cdata,currPoints);
    indexPairs = matchFeatures(prevFeatures,currFeatures,'unique',true);
    
    % Eliminate outliers from feature matches.
    inlierIdx = helperFindEpipolarInliers(prevPoints(indexPairs(:,1)),...
        currPoints(indexPairs(:,2)), cameraParams);

    indexPairs = indexPairs(inlierIdx, :);
    
    % Triangulate points from the previous two views, and find the
    % corresponding points in the current view.
    [worldPoints, imagePoints] = helperFind3Dto2DCorrespondences(vSet,...
        cameraParams, indexPairs, currPoints);
    
    % Estimate the world camera pose for the current view.
    
    warningstate = warning('off','vision:ransac:maxTrialsReached');
    
    [orient, loc] = estimateWorldCameraPose(imagePoints, worldPoints, ...
        cameraParams, 'Confidence', 99.99, 'MaxReprojectionError', 0.9,...
        'MaxNumTrials',5000);
    
    % Restore the original warning state
    warning(warningstate)
    
    % Add current view to the view set
    vSet = addView(vSet,i, 'Points', currPoints, 'Orientation', ...
        orient, 'Location', loc);
    
    % Store the point matches between the previous and the current views.
    vSet = addConnection(vSet, i-1, i, 'Matches', indexPairs);
    
    % Refine estimated camera poses using windowed bundle adjustment. Run
    % the optimization every 7th view.
    if mod(i, 7) == 0
        % Find point tracks in the last 15 views and triangulate.
        windowSize = 15;
        startFrame = max(1, i - windowSize);
        tracks = findTracks(vSet, startFrame:viewId);
        camPoses = poses(vSet, startFrame:viewId);
        [xyzPoints, reprojErrors] = triangulateMultiview(tracks, camPoses, ...
            cameraParams);
        
        % Hold the first two poses fixed, to keep the same scale.
        fixedIds = [startFrame, startFrame+1];
        
        % Exclude points and tracks with high reprojection errors.
        idx = reprojErrors < 2;

        [~, camPoses] = bundleAdjustment(xyzPoints(idx, :), tracks(idx), ...
            camPoses, cameraParams, 'FixedViewIDs', fixedIds, ...
            'PointsUndistorted', true, 'AbsoluteTolerance', 1e-9,...
            'RelativeTolerance', 1e-9, 'MaxIterations', 300);

         vSet = updateView(vSet, camPoses);
         
    prevFeatures = currFeatures;
    prevPoints = currPoints;
    
    end
    
end

%% Plot final
camPoses = poses(vSet);
locations = cat(1, camPoses.Location{:});
set(trajectoryObs, 'XData', locations(:,1), 'YData', ...
    locations(:,2), 'ZData', locations(:,3));

camObs.Location = vSet.Views.Location{i};
camObs.Orientation = vSet.Views.Orientation{i};
