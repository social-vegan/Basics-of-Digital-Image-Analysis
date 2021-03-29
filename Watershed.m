clc; close all; clear all;
%% Gradient Magnitude

I=imread('circles.png');
figure, imshow(I);
dd=bwdist(~I);
figure, imagesc(dd), colormap(gray), title('Distance Transform of binary image');
dd=-dd;
figure, imagesc(dd), colormap(gray), title('Complement of Distance Transform');
%L=watershed(dd);
%figure,imagesc(L), colormap(gray);
%I(L==0)=false;
%figure, imshow(I);

d2=imhmin(dd,2);
L1=watershed(d2);
figure,imagesc(L1),colormap(gray),title('Watershed Transform');
I(L1==0)=false;
figure, imshow(I), title('Segmented Image');













%%




I = imread('img7.png');
I = rgb2gray(I);
gmag = imgradient(I);
imshow(gmag,[])
title('Gradient Magnitude')


















%% Watershed

L = watershed(gmag);
Lrgb = label2rgb(L);
%imshow(Lrgb)
%title('Watershed Transform of Gradient Magnitude')

se = strel('disk',20);
Io = imopen(I,se);
%imshow(Io)
%title('Opening')

Ie = imerode(I,se);
Iobr = imreconstruct(Ie,I);
%imshow(Iobr)
%title('Opening-by-Reconstruction')

Ioc = imclose(Io,se);
%imshow(Ioc)
%title('Opening-Closing')

Iobrd = imdilate(Iobr,se);
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
%imshow(Iobrcbr)
%title('Opening-Closing by Reconstruction')

fgm = imregionalmax(Iobrcbr);
%imshow(fgm)
%title('Regional Maxima of Opening-Closing by Reconstruction')

I2 = labeloverlay(I,fgm);
%imshow(I2)
%title('Regional Maxima Superimposed on Original Image')

se2 = strel(ones(5,5));
fgm2 = imclose(fgm,se2);
fgm3 = imerode(fgm2,se2);

fgm4 = bwareaopen(fgm3,20);
I3 = labeloverlay(I,fgm4);
%imshow(I3)
%title('Modified Regional Maxima Superimposed on Original Image')

bw = imbinarize(Iobrcbr);
figure
montage({I,bw}, 'Size', [1 2])
%title('Thresholded Opening-Closing by Reconstruction')
