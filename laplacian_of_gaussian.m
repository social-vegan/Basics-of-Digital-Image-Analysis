img=imread('img7.png');
img=rgb2gray(img);
img = double(img);
Log_filter = fspecial('log', [5,5], 4.0); % fspecial creat predefined filter.Return a filter.
                                        % 25X25 Gaussian filter with SD =25 is created.
img_LOG = imfilter(img, Log_filter, 'symmetric', 'conv');
figure, imshow(img_LOG, []),title('Laplacian of Gaussian');

[level,em1]=graythresh(img_LOG);
BW = imbinarize(img_LOG,level);
figure, imshowpair(img,BW,'montage');
