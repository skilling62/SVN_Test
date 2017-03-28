close all
clearvars;
clc

%% Read the Odometry data
% Import Data
addpath(genpath('Odometry_CSVs'));
M = csvread('15_4_35.csv', 1);

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

%% Read from video file only once established in the hover
k = find(M(:,11)>=0.68,1);
t0Vid = (M(k,1))/1000;
t0Vid = 8.3;

%% Load Camera Parameters and transpose intrinsic matrix
load ('cameraParams.mat')
cameraStruct = toStruct(cameraParams);
%cameraStruct.IntrinsicMatrix = cameraStruct.IntrinsicMatrix';
%cameraStruct.IntrinsicMatrix = [686.994766, 0, 329.323208; 0, 688.195055, 159.323007; 0, 0, 1]';
cameraStruct.IntrinsicMatrix = [561.999146, 0, 307.433982; 0, 561.782697, 190.144373; 0, 0, 1]';
cameraParams = cameraParameters(cameraStruct);

%% Read the desired video file and output the struct to the workspace
% Create a VideoReader object to read the input video file
addpath .\Computer_Vision
videoFile = 'flight_03_25.avi';
vidObj = VideoReader(videoFile, 'CurrentTime', t0Vid);

% Determine the width and height of the frames (640p by 360p)
vidWidth = vidObj.Width;
vidHeight = vidObj.Height;
vidDuration = vidObj.Duration;
vidFrameRate = vidObj.FrameRate;

% Create a MATLAB® movie structure array, s
% s = struct(field,value). If value is a cell array, s is a structure
% array with the same dimensions as value. Fields: cdata, colormap,
% timeStamp
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'timeStamp',[],...
    'colormap',[]);

% hasFrame returns a logical 1(true) if there is a video frame available to
% read from the file
k = 1;
while hasFrame(vidObj)
        frame = rgb2gray(readFrame(vidObj));
        s(k).cdata = undistortImage(frame, cameraParams);
        s(k).timestamp = vidObj.CurrentTime;
        k = k+1;
end