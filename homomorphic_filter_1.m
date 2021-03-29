clc; close all; clear all;
d=10; order=2;
I=imread('img2.gif');
%K=rgb2gray(I);
im_original=double(I);
[r,c]=size(im_original);
im_e=homofil(im_original,d,r,c,order);
figure 
montage({(im_original./255),im_e}, 'Size', [1 2])
%% Gradient Magnitude
clc; close all; clear all;
I = imread('img5.png');
I = rgb2gray(I);
gmag = imgradient(I);
imshow(gmag,[])
title('Gradient Magnitude')
%%
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
%%
uu=imread('ref1.jpg');
%uu=rgb2gray(uu);
uu=imbinarize(uu);
imshow(uu)
%%
clc;
I1 = imread('img2.gif');
P0 = imnoise(I1,'salt & pepper',0.06);
K = medfilt2(P0);
I=im2double(K);
[r,c]=size(K);
x=r/2; y=c/2;
J = regiongrowing(I,x,y,0.14);
figure
montage({P0,K,imbinarize(I+J)},'Size',[1 3]);
[Accuracy, Sensitivity, Fmeasure, Precision, MCC, Dice, Jaccard, Specitivity]=EvaluateImageSegmentationScores(bw, imbinarize(I+J))


%% FUNCTIONS

function im_e=homofil(im,d,r,c,n)
    A=zeros(r,c);
    H=zeros(r,c);
    for i=1:r
        for j=1:c
            A(i,j)=(((i-r/2).^2+(j-c/2).^2)).^(.5);
            H(i,j)=1/(1+((d/A(i,j))^(2*n)));
        end
    end
    alphaL=0.12; alphaH=1.12;
    H=((alphaH-alphaL).*H)+alphaL;
    H=1-H;
    im_l=log(1+im);
    im_f=fft2(im_l,r,c);
    im_nf=H.*im_f;
    im_n=abs(ifft2(im_nf));
    im_n=im_n(1:size(im,1),1:size(im,2));
    im_e=exp(im_n)-1;
end

function J=regiongrowing(I,x,y,reg_maxdist)
% This function performs "region growing" in an image from a specified
% seedpoint (x,y)
%
% J = regiongrowing(I,x,y,t) 
% 
% I : input image 
% J : logical output image of region
% x,y : the position of the seedpoint (if not given uses function getpts)
% t : maximum intensity distance (defaults to 0.2)
%
% The region is iteratively grown by comparing all unallocated neighbouring pixels to the region. 
% The difference between a pixel's intensity value and the region's mean, 
% is used as a measure of similarity. The pixel with the smallest difference 
% measured this way is allocated to the respective region. 
% This process stops when the intensity difference between region mean and
% new pixel become larger than a certain treshold (t)
%
% Example:
%
% I = im2double(imread('medtest.png'));
% x=198; y=359;
% J = regiongrowing(I,x,y,0.2); 
% figure, imshow(I+J);
%
% Author: D. Kroon, University of Twente
    if(exist('reg_maxdist','var')==0), reg_maxdist=0.2; end
    if(exist('y','var')==0), figure, imshow(I,[]); [y,x]=getpts; y=round(y(1)); x=round(x(1)); end
    J = zeros(size(I)); % Output 
    Isizes = size(I); % Dimensions of input image
    reg_mean = I(x,y); % The mean of the segmented region
    reg_size = 1; % Number of pixels in region
% Free memory to store neighbours of the (segmented) region
    neg_free = 10000; neg_pos=0;
    neg_list = zeros(neg_free,3); 
    pixdist=0; % Distance of the region newest pixel to the regio mean
% Neighbor locations (footprint)
    neigb=[-1 0; 1 0; 0 -1;0 1];
% Start regiogrowing until distance between regio and posible new pixels become
% higher than a certain treshold
    while(pixdist<reg_maxdist&&reg_size<numel(I))
    % Add new neighbors pixels
        for j=1:4,
        % Calculate the neighbour coordinate
            xn = x +neigb(j,1); yn = y +neigb(j,2);
        
        % Check if neighbour is inside or outside the image
            ins=(xn>=1)&&(yn>=1)&&(xn<=Isizes(1))&&(yn<=Isizes(2));
        
        % Add neighbor if inside and not already part of the segmented area
            if(ins&&(J(xn,yn)==0)) 
                neg_pos = neg_pos+1;
                neg_list(neg_pos,:) = [xn yn I(xn,yn)]; J(xn,yn)=1;
            end
        end
    % Add a new block of free memory
        if(neg_pos+10>neg_free), neg_free=neg_free+10000; neg_list((neg_pos+1):neg_free,:)=0; end
    
    % Add pixel with intensity nearest to the mean of the region, to the region
        dist = abs(neg_list(1:neg_pos,3)-reg_mean);
        [pixdist, index] = min(dist);
        J(x,y)=2; reg_size=reg_size+1;
    
    % Calculate the new mean of the region
        reg_mean= (reg_mean*reg_size + neg_list(index,3))/(reg_size+1);
    
    % Save the x and y coordinates of the pixel (for the neighbour add proccess)
        x = neg_list(index,1); y = neg_list(index,2);
    
    % Remove the pixel from the neighbour (check) list
        neg_list(index,:)=neg_list(neg_pos,:); neg_pos=neg_pos-1;
    end
% Return the segmented area as logical matrix
    J=J>1;
end

function [Accuracy, Sensitivity, Fmeasure, Precision, MCC, Dice, Jaccard, Specitivity] = EvaluateImageSegmentationScores(A, B)
    % Copyright 2019 by Dang N. H. Thanh. Email: thanh.dnh.cs@gmail.com
    % Visit my site: https://sites.google.com/view/crx/sdm
    % You need to install the image processing toolbox
    % ===================================================================
    % A and B need to be binary images
    % A is the ground truth, B is the segmented result.
    % MCC - Matthews correlation coefficient
    % Note: Sensitivity = Recall
    % TP - true positive, FP - false positive, 
    % TN - true negative, FN - false negative
    
    % If A, B are binary images, but uint8 (0, 255),
    % Need to convert to logical images.
    if(isa(A,'logical'))
        X = A;
    else
        X = imbinarize(A);
    end
    if(isa(B,'logical'))
        Y = B;
    else
        Y = imbinarize(B);
    end
    
    % Evaluate TP, TN, FP, FN
    sumindex = X + Y;
    TP = length(find(sumindex == 2));
    TN = length(find(sumindex == 0));
    substractindex = X - Y;
    FP = length(find(substractindex == -1));
    FN = length(find(substractindex == 1));
    Accuracy = (TP+TN)/(FN+FP+TP+TN);
    Sensitivity = TP/(TP+FN);
    Precision = TP/(TP+FP);
    Fmeasure = 2*TP/(2*TP+FP+FN);
    MCC = (TP*TN-FP*FN)/sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
    
    % If you use MATLAB2017b+, you can call: Dice = dice(A, B), but A, B
    % need to be converted to the logical form
    % If you use MATLAB2017b+, you can call: Jaccard = jaccard(A, B), but
    % A, B need to be converted to the logical form
    Dice = 2*TP/(2*TP+FP+FN);
    Jaccard = Dice/(2-Dice);
    Specitivity = TN/(TN+FP);
end
