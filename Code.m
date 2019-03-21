input = imread('test.jpg');
imshow(input);

I = rgb2gray(input);
bw = imbinarize(input);
imshow(bw);

bw = bwareaopen(bw,30);
imshow(bw);

se = strel('disk',2);
bw = imclose(bw,se);
imshow(bw);

bw = imfill(bw, 'holes');
imshow(bw);

[B,L] = bwboundaries(bw,'noholes');
hold on
for k = 1:length(B)
    boundary = B(k);
    plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
end

%https://www.mathworks.com/help/images/identifying-round-objects.html#d120e26688
%https://www.mathworks.com/matlabcentral/answers/116793-how-to-classify-shapes-of-this-image-as-square-rectangle-triangle-and-circle

