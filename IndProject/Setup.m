% -------------------------------------------------------------------------
% This script imports the navdata and video feeds for processing in:
% Navdata - poseEstimate.m and CombinedVO.m
% Video Feed - VO.m and combined VO.m
% -------------------------------------------------------------------------
close all
clearvars;
clc

%% ------------------------------------------------------------------------
% Read Odometry Data
%  ------------------------------------------------------------------------
% Import Data
addpath(genpath('Odometry_CSVs'));
M = csvread('flight11.csv', 1);

% Adjust array so that there is only one instance of t = 0 (initial
% conditions). Arbitrary variable rem
rem = M(:,1);

for j = 5:-1:2
    initSum = rem(j) + rem(j-1);
    if initSum == 0
        index = j;
    end
end

M = M(index:size(M,1),:);

%% Load Camera Parameters
load ('cameraParams.mat')
cameraStruct = toStruct(cameraParams);

% Downward Facing Camera Parameters
% cameraStruct.IntrinsicMatrix = [686.994766, 0, 329.323208; 0, 688.195055, 159.323007; 0, 0, 1]';

% Forward Facing Camera Parameters
cameraStruct.IntrinsicMatrix = [561.999146, 0, 307.433982; 0, 561.782697, 190.144373; 0, 0, 1]';
cameraParams = cameraParameters(cameraStruct);

%% ------------------------------------------------------------------------
%  Read Video File
%  ------------------------------------------------------------------------
% Read from video file from a certain point if required
k = find(M(:,11)>=0.68,1);
t0Vid = (M(k,1))/1000;
t0Vid = 0.0;

% Read the desired video file and output the struct to the workspace
% Create a VideoReader object to read the input video file
addpath .\Computer_Vision
videoFile = 'flight11.avi';
vidObj = VideoReader(videoFile, 'CurrentTime', t0Vid);

% Determine the width and height of the frames (640p by 360p)
vidWidth = vidObj.Width;
vidHeight = vidObj.Height;
vidDuration = vidObj.Duration;
vidFrameRate = vidObj.FrameRate;

% Create a movie structure array to store video parameters in
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'timeStamp',[],...
    'colormap',[]);

k = 1;
while hasFrame(vidObj)
        frame = rgb2gray(readFrame(vidObj));
        % If the frame is blacked out skip to the next frame (threshold =
        % intensity of 10)
        if (sum(frame(vidHeight/2,:))/(vidWidth)) > 10
            s(k).cdata = undistortImage(frame, cameraParams);
            s(k).timestamp = vidObj.CurrentTime;
        end
        k = k+1;
end

% Remove null frames from the array
sMatrix = zeros(vidHeight,vidWidth,length(s));
    for k_ = 1:length(s)
        try
        % Add intensity information to each layer of the matrix
        sMatrix(:,:,k_) = s(k_).cdata;
        catch
            sMatrix(:,:,k_) = zeros(size(sMatrix,1),size(sMatrix,2));
        end
    end

% Remove blacked out frames from the array (a black frame in the array has 
% all elements = 0)    
remFrame = sum(sMatrix(vidHeight/2,:,1:length(s)));
keepFrame = remFrame~=0;
s = s(keepFrame);

%% ------------------------------------------------------------------------
%  Optional
%  ------------------------------------------------------------------------
% Limit number of views to encourage camera transformation between views
numSkippedFrames = 10;
s = s(150:numSkippedFrames:length(s));
frameRate = vidFrameRate/numSkippedFrames;

% Extract Images 
% cd ('C:\Users\James\Documents\Uni_3rd_Year\Individual_Project\Video_Feed\RelativePoseImages')
% view1 = 1;
% view2 = 44;
% filename = (['Frame ' num2str(view1) '.png']);
% imwrite(s(view1).cdata, filename);
% filename = (['Frame ' num2str(view2) '.png']);
% imwrite(s(view2).cdata, filename);