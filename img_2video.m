clc;
clear;
close all;

imgFile = dir('*.jpeg') ; %file_type
N = length(imgFile) ; 

vid = VideoWriter("vid.avi"); %video_name and file_type
vid.FrameRate = 20; %fps
open(vid) 
for i=1:N
    img = imgFile(i).name ; 
    I = imread(img) ; 
    writeVideo(vid, I);
    fprintf('%s is Processing \n',string(imgFile(i).name))
end
fprintf('Completed\n')
close(vid)
