clear all; clc;
%%
%Input image
img = imread ('img3.png');
%Show input image
%{
figure, imshow(img);
img=imread('jump.mat');
I=double(img);
K=wdenoise2(I);
figure, imshow(K);
%}
%%
img = imread('img5.png');
img=rgb2gray(img);
%img = imread ('coins.png');
%img = imread ('img2.gif');
%img = double (img);
BW1 = edge(img,'sobel');
BW2 = edge(img,'canny');
BW3 = edge(img,'log');
BW4 = edge(img,'Prewitt');
BW5 = edge(img,'Roberts');
BW6 = edge(img,'zerocross');
BW7 = edge(img,'approxcanny');

figure, imshow(BW1), title('Sobel');
figure, imshow(BW2);
figure, imshow(BW3);
figure, imshow(BW4);
figure, imshow(BW5);
figure, imshow(BW6);
figure, imshow(BW7);


%montage({BW1,BW2,BW3},'Size',[1 3]);

%%
