clc;
clear;
close all;


img = dir('*.jpg');
v = VideoWriter('video.avi');
v.Quality = 50;
v.FrameRate = 10;
open(v);

for i = 1:length(img)
    IM = imread(img(i).name);
    writeVideo(v,IM);
    fprintf('%s\n',img(i).name)
end
close(v);