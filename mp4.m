clc;
clear;

list = dir('*.mp4');
T = "";
for i = 1:size(list,1)
    T(i,1) = list(i).name;
    filename = char(T(i));
    filename = filename(1:end-4);
    [y,Fs] = audioread(T(i));
    audiowrite(sprintf('%s.wav',filename),y,Fs);
end
