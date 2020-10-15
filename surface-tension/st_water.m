clear
clc
close all
% define some contant in the experiment
nozzle_diameter = 1.63; % unit: mm
rho = 1000; % unit: kg/m^3
g = 9.80665; % gravitity acceleration unit: m/s^2

imgs = dir('*.png');
for i = 1: numel(imgs)
    %% image process to get the Ds, De, S
    img = imread(imgs(i).name);
    rect = [350, 10, 650, 800];
    img_interested = imcrop(img, rect);
    img_bw = imbinarize(rgb2gray(img_interested),0.4);
%     figure
%     imshowpair(img_interested, img_bw, 'montage')
    img_bw2 = imfill(~img_bw, 'holes');
%     figure
%     imshow(img_bw2)
    a = sum(img_bw2, 2);
    a(a==0) = [];
    de = max(a);
    ds = a(length(a)-de);
    s = ds/de;
    ratio = mean(a(1:5))/nozzle_diameter;
    de_length = de/ratio;
    %% compute H by looking up in the database
    load S_H.mat
    h = interp1(S,H,s);
    %% final surface tension calculation [dyn/cm]
    st = g*rho*de_length^2/1000*(1/h)
    sts(i) = st;
end
