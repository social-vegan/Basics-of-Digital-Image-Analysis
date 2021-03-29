clc; clear all; close all;
I = imread('eight.tif');
%figure, imshow(I);
J1 = imnoise(I,'salt & pepper',0.05);
%J2 = imnoise(I,'gaussian',0,0.020);
K1 = medfilt2(J1);
%K2 = medfilt2(J2);
%K2 = wiener2(J2);
%figure, imshowpair(J1,J2,'montage');
figure, imagesc(K1),colormap(gray),title('Median Filter');
%%
J = imread('eight.tif');
I = imnoise(J,'salt & pepper',0.05);
J=I;
%I=rgb2gray(I);
I=double(I); %read image 
In=I;	 %copy image 
mask=(1/9)*[1, 1, 1;1, 1, 1;1, 1, 1]; 
figure, imagesc(J),colormap(gray),title('Noisy Image');
%Rotate image by 180 degree first flip up to down then left to right 
mask=flipud(mask); 
mask=fliplr(mask); 
for i=2:size(I, 1)-1
	for j=2:size(I, 2)-1

		%multiplying mask value with the corresponding image pixel value 
		neighbour_matrix=mask.*In(i-1:i+1, j-1:j+1); 
		avg_value=sum(neighbour_matrix(:)); 
		I(i, j)=avg_value; 
	end 
end 
figure, imagesc(I),colormap(gray),title('Averaged Image'); 
