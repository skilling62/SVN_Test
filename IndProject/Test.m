%% Load random Poses from mathworks tutorial
load(fullfile(toolboxdir('vision'), 'visiondata', ...
    'visualOdometryGroundTruth.mat'));
for z = 1:150
    groundTruthPoses.Location{z} = [0 0 0];
    groundTruthPoses.Orientation{z} = eye(3);
end
    
%% Initialise visual odometry by extracting features in the first frame
% Need to review when the first frame should be taken
prevPoints = detectSURFFeatures(s(1).cdata);
prevFeatures = extractFeatures(s(1).cdata,prevPoints);

% Initialise a viewset object
vSet = viewSet;
viewId = 1;
omega = 0;
phi = 0;
kappa = 0;
Rx = [1 0 0; 0 cos(omega) -sin(omega); 0 sin(omega) cos(omega)];
Ry = [cos(phi) 0 sin(phi); 0 1 0; -sin(phi) 0 cos(phi)];
Rz = [cos(kappa) -sin(kappa) 0; sin(kappa) cos(kappa) 0; 0 0 1];
R = Rx*Ry*Rz;

% Original View - Camera Faces the down the positive z axis
vSet = addView(vSet, viewId, 'Points', prevPoints, 'Orientation', ...
    eye(3), 'Location', zeros(1,3));

%% Plot the Initial Camera Pose
% Setup the axes
axis([-5, 5, -5, 5, -5, 5]);
view(gca,3)
set(gca, 'CameraUpVector', [0, -1, 0]);
camorbit(gca, -120, 0, 'data', [0, 1, 0]);
xlabel('X')
ylabel('Y')
zlabel('Z')
grid on
hold on

% Plot Initial Camera Poses
camObs = plotCamera('Location', vSet.Views.Location{1}, 'Orientation',...
    vSet.Views.Orientation{1},...
    'Color', 'g', 'Opacity', 0);

camNav = plotCamera('Location', groundTruthPoses.Location{1}, 'Orientation', ...
    groundTruthPoses.Orientation{1}, 'Color', 'b', 'Opacity', 0);

% Initialise Camera Trajectories
trajectoryObs = plot3(0,0,0, 'g-');
trajectoryNav = plot3(0,0,0,'b-');

legend('Observed Trajectory','Navdata Trajectory')

%% Display Features
figure;
imshow(s(1).cdata); hold on; plot(prevPoints,'showOrientation',true);
title('Detected Features','fontsize',20);
figure;
imshow(undistortImage((s(1).cdata),cameraParams)); hold on; plot(prevPoints,'showOrientation',true);
title('Undistorted Image','fontsize',20);

%% ------------------------------------------------------------------------
% Estimate the pose of the second view
% -------------------------------------------------------------------------

% ViewId = 2
i = 2;

% Match features between the previous and the current image.
currPoints = detectSURFFeatures(s(i).cdata);
currFeatures = extractFeatures(s(i).cdata,currPoints);
indexPairs = matchFeatures(prevFeatures,currFeatures);
matchedPoints1 = prevPoints(indexPairs(:,1),:);
matchedPoints2 = currPoints(indexPairs(:,2),:);

%% Plot Matched Features
figure;
showMatchedFeatures(s(i-1).cdata,s(i).cdata,matchedPoints1,matchedPoints2,'montage');
title('Initial Feature Matching Between Frames','fontsize',20)

%% Generated 5 RANSAC Filtered Matches
[tform, inlierPoints1, inlierPoints2] = estimateGeometricTransform...
(matchedPoints1, matchedPoints2, 'affine');
iteration = floor((size(inlierPoints1,1))/5);
spacing = 1:iteration:iteration*5;
for j = 1:length(spacing)
     inlierPoints1(j) = inlierPoints1(spacing(j));
     inlierPoints2(j) = inlierPoints2(spacing(j));
end
inlierpoints1 = inlierPoints1(1:5);
inlierpoints2 = inlierPoints2(1:5);

%% Plot 5 Inliers
figure;
showMatchedFeatures(s(i-1).cdata, s(i).cdata, inlierpoints1, inlierpoints2,...
'montage');
title('5 RANSAC Filtered Matches','fontsize',20);

%% Estimate the relative orientation of the second view
% Estimate the pose of the current view relative to the previous view.
[relativeOrient, relativeLoc, inlierIdx] = helperEstimateRelativePose(...
        inlierpoints1, inlierpoints2, cameraParams);

% Add the current view to the view set.
vSet = addView(vSet, i, 'Points', currPoints, 'Orientation', relativeOrient, ...
    'Location', relativeLoc);

% Store the point matches between the previous and the current views.
vSet = addConnection(vSet, i-1, i, 'Matches', indexPairs);

%% Update camera trajectory plot
camNav.Location = groundTruthPoses.Location{i};
camNav.Orientation = groundTruthPoses.Orientation{i};
camObs.Location = vSet.Views.Location{i};
camObs.Orientation = vSet.Views.Orientation{i};

helperUpdateCameraTrajectories(i,trajectoryObs, trajectoryNav, poses(vSet),...
    groundTruthPoses);

prevFeatures = currFeatures;
prevPoints   = currPoints;

%% Bootstrap Estimating Camera Trajectory Using Global Bundle Adjustment
for i = 3:15
    
    % Match features between the previous and the current image.
    currPoints = detectSURFFeatures(s(i).cdata);
    currPoints   = selectUniform(currPoints, 50, size(s(i).cdata));
    currFeatures = extractFeatures(s(i).cdata,currPoints);
    indexPairs = matchFeatures(prevFeatures,currFeatures,'Unique',true);
    
    % Eliminate outliers from feature matches.
    inlierIdx = helperFindEpipolarInliers(prevPoints(indexPairs(:,1)),...
        currPoints(indexPairs(:, 2)), cameraParams);
    
    %%
    indexPairs = indexPairs(inlierIdx, :);
    
    %% Triangulate points from the previous two views, and find the
    % corresponding points in the current view.
    [worldPoints, imagePoints] = helperFind3Dto2DCorrespondences(vSet,...
        cameraParams, indexPairs, currPoints);
    
    warningstate = warning('off','vision:ransac:maxTrialsReached');
    
    %% Estimate the world camera pose for the current view.
    % 99.9 and 0.8
    [orient, loc] = estimateWorldCameraPose(imagePoints, worldPoints, ...
        cameraParams, 'Confidence', 99.9, 'MaxReprojectionError', 0.8);
    
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
    
    % Update camera trajectory plot
    camNav.Location = groundTruthPoses.Location{i};
    camNav.Orientation = groundTruthPoses.Orientation{i};
    camObs.Location = vSet.Views.Location{i};
    camObs.Orientation = vSet.Views.Orientation{i};
    
    helperUpdateCameraTrajectories(i,trajectoryObs, trajectoryNav, poses(vSet),...
    groundTruthPoses);

    prevFeatures = currFeatures;
    prevPoints = currPoints;
    
end
    
    
 %%
    
    
    
    
    
    
    
    
    
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
% Display camera poses.
camPoses = poses(vSet);
plotCamera(camPoses, 'Size', 0.2, 'Opacity', 0);

% Exclude noisy 3-D points.
goodIdx = (reprojectionErrors < 5);
xyzPoints = xyzPoints(goodIdx, :);