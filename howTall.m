function [outputImage, heightString] = howTall(inputImage)
    input = imread(inputImage);
    imwrite(input,'input.pgm');
    input = imread('input.pgm');
    id = imread('idphoto.jpg');
    imwrite(id,'idphoto.pgm');
    match('input.pgm', 'idphoto.pgm');
    
    %Image thresolding stuff
    %bw = imbinarize(input);
    %imshow(bw);
    %bw = bwareaopen(bw,30);
    %figure;
    %imshow(bw);
    
    %se = strel('square',2);
   % bw = imclose(bw,se);
    %figure;
    %imshow(bw);
    %bw = imfill(bw, 'holes');
    %figure;
    %imshow(bw);
    %[B,L] = bwboundaries(bw,'noholes');
    
%     hold on
%     for k = 1:length(B)
%         boundary = B(k);
%         plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
%     end
    outputImage = inputImage;
    heightString = "This person is very tall";

%https://www.mathworks.com/help/images/identifying-round-objects.html#d120e26688
%https://www.mathworks.com/matlabcentral/answers/116793-how-to-classify-shapes-of-this-image-as-square-rectangle-triangle-and-circle

