close all;
clear all;

im = imread('Number Plate Images/image1.png');
figure, imshow(im), title('Original Image');

imgray = rgb2gray(im);
figure, imshow(imgray), title('Grayscale Image');

imbin = imbinarize(imgray);
figure, imshow(imbin), title('Binary Image');

%imshow(imbin);
im = edge(imgray, 'prewitt');
figure, imshow(im), title('Detected Edges Using Prewitt Operator');

figure, imshow(im), title('Object Detection');
%Below steps are to find location of number plate
Iprops=regionprops(im,'BoundingBox','Area', 'Image');
count = numel(Iprops);
for i = 1:count
    rectangle('Position', Iprops(i).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
end
%Finding Object With Maximum Area
maxa = Iprops.Area;
boundingBox = Iprops.BoundingBox;
for i=1:count
   if maxa<Iprops(i).Area
       maxa=Iprops(i).Area;
       boundingBox=Iprops(i).BoundingBox;
   end
end    


im = imcrop(imbin, boundingBox);%crop the number plate area
figure, imshow(im), title('Cropped image');
im = bwareaopen(~im, 500); %remove some object if it width is too long or too small than 500
figure, imshow(im), title('After complementing and removing smaller objects');

 [h, w] = size(im);%get width
figure, imshow(im), title('Character Detection');

Iprops=regionprops(im,'BoundingBox','Area', 'Image'); %read letter
count = numel(Iprops);

for i = 1:count
    rectangle('Position', Iprops(i).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
end

noPlate=[]; % Initializing the variable of number plate string.

for i=1:count
   ow = length(Iprops(i).Image(1,:));
   oh = length(Iprops(i).Image(:,1));
   if ow<(h/2) & oh>(h/3)
       letter=Letter_detection(Iprops(i).Image); % Reading the letter corresponding the binary image 'N'.
       noPlate=[noPlate letter] % Appending every subsequent character in noPlate variable.
   end
end
