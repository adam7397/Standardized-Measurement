function [outputImage, heightString] = howTall(inputImage)
    input = imread(inputImage);
    inputJPG = input;
    imwrite(input,'input.pgm');
    input = imread('input.pgm');
    id = imread('idphoto.jpg');
    imwrite(id,'idphoto.pgm');
    input = imrotate(input, 270);
    
    %Image thresolding stuff
    bw = imbinarize(input);
    %imshow(bw);
    bw = bwareaopen(bw,30);
    %imshow(bw);
    
    se = strel('square',8);
    bw = imclose(bw,se);
    %imshow(bw);
    %bw = imfill(bw, 'holes');
    figure;
    imshow(bw);
    [B,L] = bwboundaries(bw,'noholes');
    
    %blob image or something
    labeledimage = bwlabel(bw, 8);
    figure;
    imshow(labeledimage);
    coloredLabels = label2rgb (labeledimage, 'hsv', 'k', 'shuffle');
    imshow(coloredLabels);
    
    % Get all the blob properties.  Can only pass in originalImage in version R2008a and later.
    blobMeasurements = regionprops(labeledimage, input, 'all');
    numberOfBlobs = size(blobMeasurements, 1);
    
    idHeight = 0;
    idWidth = 0;
    for k=1:length(blobMeasurements)
        
        curBlob = blobMeasurements(k);
        ratio = curBlob.MajorAxisLength/curBlob.MinorAxisLength;
        
        %credit card ratio is 1.585
        if(ratio > 1.485 && ratio < 1.685)
            idHeight = curBlob.MajorAxisLength;
            idWidth = curBlob.MinorAxisLength;
        end
        
    
    end
   
    
    
    peopleDetector = vision.PeopleDetector;
    [bboxes, scores] = peopleDetector(input);
    height = 0;
    if(isempty(bboxes) || isempty(scores))
        foundPeople = input;
    else
        foundPeople = insertObjectAnnotation(input,'rectangle',bboxes, scores);
        figure;
        imshow(foundPeople);
        title('Detected people and detection scores');
        height = bboxes(4) - 110; 
    end
    
    
    %image boundaries from matlab forums
    %axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
    %hold on;
    %boundaries = bwboundaries(bw);
    %numberOfBoundaries = size(boundaries, 1);
    %for k = 1 : numberOfBoundaries
    %    thisBoundary = boundaries{k};
    %    plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
    %end
    %hold off;




    
%     hold on
%     for k = 1:length(B)
%         boundary = B(k);
%         plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
%     end
    outputImage = foundPeople;
    if (height == 0)
         heightString = "Person not found in photo.";
    end
    if(idHeight == 0)
        heightString = "ID/CreditCard not found in photo";
    end
    
    if(height > 0 && idHeight > 0)
        height = height * (3.75 / idHeight);
        feet = floor(height / 12) ;
        inches = round(((height / 12) - feet) * 12, 0);
        heightString = "This person is " + feet +"'' " + inches + "' tall";
    end
    
    
    
    
    if(height > 0 && idHeight > 0)
        height = height * (3.75 / idHeight);
        feet = floor(height / 12) ;
        inches = round(((height / 12) - feet) * 12, 0);
        heightString = "This person is " + feet +"' " + inches + "'' tall";
    end
    
    
  

%https://www.mathworks.com/help/images/identifying-round-objects.html#d120e26688
%https://www.mathworks.com/matlabcentral/answers/116793-how-to-classify-shapes-of-this-image-as-square-rectangle-triangle-and-circle
%https://www.mathworks.com/matlabcentral/fileexchange/25157-image-segmentation-tutorial
