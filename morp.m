BW1=imread('cameraman.tif');
%figure, imshowpair(I,BW,'montage');

figure, imshow(BW1),title('Original Image - f');
%%
SE = [1,1,1;
      1,1,1;
      1,1,1;];
BW2 = imdilate(BW1,SE);
figure, imshow(BW2),title('dilation - g');
BW3=BW2-BW1;
figure, imshow(BW3),title('(g-f)');
[level,em1]=graythresh(BW3);
BW3 = 1-imbinarize(BW3,level);
figure, imshow(BW3),title('Boundary Extraction [(g-f) thresholded]');
