clc;
clear;
close all;

imgFile = dir('*.jpeg') ; 
N = length(imgFile) ; 
% create the video writer with 1 fps
writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 30;
% open the video writer
open(writerObj);
% write the frames to the video
for i=1:N
    img = imgFile(i).name ; 
    I = imread(img) ; 
    imshow(I) ; 
    F = getframe(gcf) ;
    writeVideo(writerObj, F);
end
% close the writer object
close(writerObj);