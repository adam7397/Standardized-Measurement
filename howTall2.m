function [outputImage, heightString] = howTall2(inputImage)
    input = imread(inputImage);
    %inputJPG = input;
    %imwrite(input,'input.pgm');
    %input = imread('input.pgm');
    %id = imread('idphoto.jpg');
    %imwrite(id,'idphoto.pgm');
    input = imrotate(input, 270);
    
    frameHSV = rgb2hsv(input);
    % Threshold to obtain binary mask
    bm = thresholdImage(frameHSV);
    % Perform morphological opening to get rid of noise from flowers
    bm = imopen(bm,strel('disk',1));
    bm = imclose(bm,strel('rectangle',[4 3]));
    figure; imshow(bm)
    % Perform blob analysis
    BA = vision.BlobAnalysis('MinimumBlobArea',10);
    [area,centroid,bbox] = step(BA,bm);
    [amax,aidx] = max(area);
    % Overlay bbox onto image
    input = insertShape(input,'Rectangle',bbox(aidx,:));
    % Overlay area of biggest blob onto image
    input = insertShape(input,'FilledRectangle',[centroid(aidx,:) 80 15]);
    TI = vision.TextInserter('Text',['Area = ',num2str(max(area))],'Location',uint16(centroid(aidx,:)));
    input = step(TI,input);
    % View frame
    imshow(input);



end