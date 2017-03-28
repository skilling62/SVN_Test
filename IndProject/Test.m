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
    eye(3,'like',prevPoints.Orientation)*R, 'Location', ...
    zeros(1, 3, 'like', prevPoints.Location));

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

% Plot Initial Camera Pose (Observation)
camObs = plotCamera('Location', vSet.Views.Location{1}, 'Orientation',...
    vSet.Views.Orientation{1},...
    'Color', 'g', 'Opacity', 0);

camNav = plotCamera('Location',zeros(1,3),'Orientation',eye(3), 'Color',...
    'b', 'Opacity', 0);

% Plot the Initial Camera Pose (Onboard Sensing)

% Initialise Camera Trajectories
trajectoryObs = plot3(0,0,0, 'g-');

legend('Observed Trajectory')

%% Display Features
figure;
imshow(s(1).cdata); hold on; plot(prevPoints,'showOrientation',true);
title('Detected Features','fontsize',20);
figure;
imshow(undistortImage((s(1).cdata),cameraParams)); hold on; plot(prevPoints,'showOrientation',true);
title('Undistorted Image','fontsize',20);

%% Estimate the pose of the second view
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



















%%
for i = 2:10
    currPoints = detectSURFFeatures(s(i).cdata);
    currFeatures = extractFeatures(s(i).cdata,currPoints);
    indexPairs = matchFeatures(prevFeatures,currFeatures);
    matchedPoints1 = prevPoints(indexPairs(:,1),:);
    matchedPoints2 = currPoints(indexPairs(:,2),:);
    

    
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
    

    %% Calculate the Essential Matrix
    % Use this to determine the relative orientation of the two images

        [relativeOrient, relativeLoc, inlierIdx] = helperEstimateRelativePose(...
        inlierpoints1, inlierpoints2, cameraParams);
    
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
plotCamera(camPoses, 'Size', 0.2, 'Opacity', 0);

% Exclude noisy 3-D points.
goodIdx = (reprojectionErrors < 5);
xyzPoints = xyzPoints(goodIdx, :);