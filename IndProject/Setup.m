close all
clearvars;
clc

%% Read the desired video file and output the struct to the workspace
% Create a VideoReader object to read the input video file
addpath .\Computer_Vision
videoFile = 'down_03_18.mp4';
vidObj = VideoReader(videoFile);

% Determine the width and height of the frames (640p by 360p)
vidWidth = vidObj.Width;
vidHeight = vidObj.Height;
vidDuration = vidObj.Duration;
vidFrameRate = vidObj.FrameRate;

% Create a MATLAB® movie structure array, s
% s = struct(field,value). If value is a cell array, s is a structure
% array with the same dimensions as value. Fields: cdata, colormap,
% timeStamp
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'timeStamp',[]);

% hasFrame returns a logical 1(true) if there is a video frame available to
% read from the file
k = 1;
while hasFrame(vidObj)
    % Each frame is (720x1280x3 uint8)
    s(k).cdata = rgb2gray(readFrame(vidObj));
    s(k).timestamp = vidObj.CurrentTime;
    k = k+1;
end

% Load Camera Parameters and transpose intrinsic matrix
load ('cameraParams.mat')
cameraStruct = toStruct(cameraParams);
cameraStruct.IntrinsicMatrix = cameraStruct.IntrinsicMatrix';
cameraStruct.IntrinsicMatrix = [686.994766, 0, 329.323208; 0, 688.195055, 159.323007; 0, 0, 1];
cameraParams = cameraParameters(cameraStruct);

%% Read the Odometry data
% Import Data
addpath  .\Odometry_CSVs;
M = csvread('12_58_15.csv', 1);

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