clc;
clear;

t=0.00025;
imgfiles1 = dir('*.jpg');
for v = 1:length(imgfiles1)
    IM = imread(imgfiles1(v).name);
    IM = insertText(IM,[0 0],sprintf('TIME STEP : %4d\nTime : %6.5f [S]\nPinion M4.5 Z16 240 RPM\nWhell M4.5 Z24 160 RPM\n0.36 Deg/TimeStep\n0.99/1 Scaled',v-1,(v-1)*t),'AnchorPoint','LeftTop','BoxColor','r',BoxOpacity=1,FontSize=50);
    IM = insertText(IM,[1218 1198],sprintf('%11s\nm.tarik.yaman@gmail.com','Tarık Yaman'),'AnchorPoint','Center','BoxColor','y',BoxOpacity=0.4,FontSize=40);
    imwrite(IM,imgfiles1(v).name);
end
