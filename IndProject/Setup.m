close all
clearvars;
clc

%% Read the desired video file and output the struct to the workspace
% Create a VideoReader object to read the input video file
videoFile = 'video_00005.mp4';
vidObj = VideoReader(videoFile);

% Determine the width and height of the frames (1280p by 720p)
vidWidth = vidObj.Width;
vidHeight = vidObj.Height;
vidDuration = vidObj.Duration;

% Create a MATLAB� movie structure array, s
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

% Get information about the movie structure array s. size of s indicates
% number of frames
whos s

%% Load Camera Parameters
load ('cameraParams.mat')