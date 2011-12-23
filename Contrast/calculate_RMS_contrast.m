function calculate_RMS_contrast

imagesDir = '/home/lisandro/Work/Project_CFS/CFS/CFS_BuenosAires/Stimuli/100Stimuli/';
outDir = '/home/lisandro/Work/Project_CFS/CFS/CFS_BuenosAires/Stimuli/';
files = dir( [ imagesDir '*GB.png']);

RMS = zeros(1,length(files));
for i = 1: length(files)    
    im = double( imread([imagesDir files(i).name]));
    [RMS(i), avg(i)] = RMS_contrast (im); %
    display(i)
end

mean(avg)
std(avg)
save([outDir 'RMS_100Stimuli_30%_luminance'], 'RMS')

function [RMS, avg] = RMS_contrast (im)

% Calculates the RMS of an image
% It first scales the image [0 1]

a = 0;
b = 0.3;
maxim = max(im(:));
minim = min(im(:));

% apply the same transformation as with psychtoolbox
im = scaleif(im, a, b);
% hist(im(:,:,1))

% calculate RMS contrast
[cols, rows] = size(im(:,:,1));
avg = mean(im(:));
diffs = (im(:,:,1) - avg).^2;
RMS = sqrt( sum(diffs(:)) / (cols*rows));



% imshow(Image)
% imshow(uint8(im*maxim));
% imshow('antelope_Gray8_GB.png');

