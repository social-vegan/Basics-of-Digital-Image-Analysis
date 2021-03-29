I=imread('img2.gif');
[level,em]=graythresh(I);
imshow(I);
BW = imbinarize(I,level);
figure;
D = bwdist(~BW); % image B (above)
D = -bwdist(~BW); % image C (above)
watershed(D);
BW(L == 0) = 0;
imshow(BW) % Segmented image D (above)