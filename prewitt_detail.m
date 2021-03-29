clc; clear all; close all;
%%
I=(imread('img8.png'));
I=rgb2gray(I);
I=double(I); %read image 
In=I;	 %copy image 
mask=[1, 0, -1;1, 0, -1;1, 0, -1]; 

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
figure, imshow(uint8(I)), title('Prewitt - Vertical'); 

%%
I=(imread('img8.png'));
I=rgb2gray(I);
I=double(I); %read image 

In=I; 
mask=[1, 1, 1;0, 0, 0;-1, -1, -1]; 
mask=flipud(mask); 
mask=fliplr(mask); 
for i=2:size(I, 1)-1
	for j=2:size(I, 2)-1
		neighbour_matrix=mask.*In(i-1:i+1, j-1:j+1); 
		avg_value=sum(neighbour_matrix(:)); 
		I(i, j)=avg_value; 
	end 
end 
figure, imshow(uint8(I)),title('Prewitt - Horizontal'); 
%%
I=(imread('img8.png'));
I=rgb2gray(I);
I=double(I); %read image 
In=I; 

mask=[0, -1, -1;1, 0, -1;1, 1, 0]; 
mask=flipud(mask); 
mask=fliplr(mask); 

for i=2:size(I, 1)-1
	for j=2:size(I, 2)-1
		neighbour_matrix=mask.*In(i-1:i+1, j-1:j+1); 
		avg_value=sum(neighbour_matrix(:)); 
		I(i, j)=avg_value; 
	end 
end 
figure, imshow(uint8(I)),title('Prewitt - Principal Diagonal'); 
%%
I=(imread('img8.png'));
I=rgb2gray(I);
I=double(I); %read image 
In=I; 

mask=[1, 1, 1;0, 0, 0;-1, -1, -1]; 
mask=flipud(mask); 
mask=fliplr(mask); 

for i=2:size(I, 1)-1
	for j=2:size(I, 2)-1
		neighbour_matrix=mask.*In(i-1:i+1, j-1:j+1); 
		avg_value=sum(neighbour_matrix(:)); 
		I(i, j)=avg_value; 
	end 
end 
figure, imshow(uint8(I)),title('Prewitt - Secondary Diagonal'); 
%%
I=(imread('img8.png'));
I=rgb2gray(I);
I=double(I); %read image 
In=I; 
mask1=[1, 0, -1;1, 0, -1;1, 0, -1]; 
mask2=[1, 1, 1;0, 0, 0;-1, -1, -1]; 
mask3=[0, -1, -1;1, 0, -1;1, 1, 0]; 
mask4=[1, 1, 0;1, 0, -1;0, -1, -1]; 

mask1=flipud(mask1); 
mask1=fliplr(mask1); 
mask2=flipud(mask2); 
mask2=fliplr(mask2); 
mask3=flipud(mask3); 
mask3=fliplr(mask3); 
mask4=flipud(mask4); 
mask4=fliplr(mask4); 

for i=2:size(I, 1)-1
	for j=2:size(I, 2)-1
		neighbour_matrix1=mask1.*In(i-1:i+1, j-1:j+1); 
		avg_value1=sum(neighbour_matrix1(:)); 

		neighbour_matrix2=mask2.*In(i-1:i+1, j-1:j+1); 
		avg_value2=sum(neighbour_matrix2(:)); 

		neighbour_matrix3=mask3.*In(i-1:i+1, j-1:j+1); 
		avg_value3=sum(neighbour_matrix3(:)); 

		neighbour_matrix4=mask4.*In(i-1:i+1, j-1:j+1); 
		avg_value4=sum(neighbour_matrix4(:)); 

		%using max function for detection of final edges 
		I(i, j)=max([avg_value1, avg_value2, avg_value3, avg_value4]); 

	end 
end 
figure, imshow(uint8(I)),title('Prewitt - Edge Detected'); 

