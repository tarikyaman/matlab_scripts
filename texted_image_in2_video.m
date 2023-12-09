clc;
clear;

vid = VideoWriter("vid.avi");
vid.FrameRate = 20;
open(vid)

t=0.0000625;
imgfiles1 = dir('*.jpeg');
for v = 1:length(imgfiles1)
    IM = imread(imgfiles1(v).name);
    IM = insertText(IM,[0 0],sprintf('TIME STEP : %4d\nTime : %8.7f [S]\nPinion M4.5 Z16 240 RPM\nWhell M4.5 Z24 160 RPM\n0.09 Deg/TimeStep\n0.99/1 Scaled',v-1,(v-1)*t),'AnchorPoint','LeftTop','BoxColor','r',BoxOpacity=1,FontSize=50);
    imwrite(IM,imgfiles1(v).name);
    writeVideo(vid, IM);
    fprintf('%s is Processing\n.',string(imgfiles1(v).name));
end
close(vid)
fprintf('Completed\n')
