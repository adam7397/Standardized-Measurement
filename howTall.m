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
    
    se = strel('square',2);
    bw = imclose(bw,se);
    %imshow(bw);
    bw = imfill(bw, 'holes');
    figure;
    imshow(bw);
    [B,L] = bwboundaries(bw,'noholes');
    
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
        height = bboxes(4); 
    end
    
    
    %image boundaries from matlab forums
    axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
    hold on;
    boundaries = bwboundaries(bw);
    numberOfBoundaries = size(boundaries, 1);
    for k = 1 : numberOfBoundaries
        thisBoundary = boundaries{k};
        plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
    end
    hold off;




    
%     hold on
%     for k = 1:length(B)
%         boundary = B(k);
%         plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
%     end
    outputImage = foundPeople;
    if (height == 0)
         heightString = "Person not found in photo.";
    else
         heightString = "This person is " + height +" pixels tall";
    end
    
   

%https://www.mathworks.com/help/images/identifying-round-objects.html#d120e26688
%https://www.mathworks.com/matlabcentral/answers/116793-how-to-classify-shapes-of-this-image-as-square-rectangle-triangle-and-circle

