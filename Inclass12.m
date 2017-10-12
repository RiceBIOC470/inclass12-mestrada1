%Inclass 12. 

% Continue with the set of images you used for inclass 11, the same time 
% point (t = 30)

file1 = '011917-wntDose-esi017-RI_f0016.tif';
reader = bfGetReader(file1);

time = 30;
zplane = 1;
chan1 = 1;
chan2 = 2;

iplane1 = reader.getIndex(zplane-1, chan1-1, time-1) + 1;
iplane2 = reader.getIndex(zplane-1, chan2-1, time-1) + 1;

img1 = bfGetPlane(reader, iplane1);
imshow(img1, [500 5000]);

img2 = bfGetPlane(reader, iplane2);
imshow(img2, [500 1500]);

img2show = cat(3, imadjust(img1), imadjust(img2), zeros(size(img1)));
imshow(img2show);

% 1. Use the channel that marks the cell nuclei. Produce an appropriately
% smoothed image with the background subtracted. 

img2_sm = imfilter(img2,fspecial('gaussian',4,2));
img2_bg = imopen(img2_sm, strel('disk',100));
img2_sm_bgsub = imsubtract(img2_sm, img2_bg);
imshow(img2_sm_bgsub, [0 600]);

% 2. threshold this image to get a mask that marks the cell nuclei. 

threshold = 90;
img_bw = img2_sm_bgsub > threshold;
imshow(img_bw);

% 3. Use any morphological operations you like to improve this mask (i.e.
% no holes in nuclei, no tiny fragments etc.)

img2_open = imopen(img_bw, strel('disk',5));
imshow(img2_open);

% 4. Use the mask together with the images to find the mean intensity for
% each cell nucleus in each of the two channels. Make a plot where each data point 
% represents one nucleus and these two values are plotted against each other

% Channel/Image 2
cell_properties = regionprops(img2_open, img2_sm_bgsub, 'MeanIntensity', 'MaxIntensity', 'PixelValues', 'Area', 'Centroid');
intensities = [cell_properties.MeanIntensity];
areas = [cell_properties.Area];
plot(areas, intensities, 'r.', 'MarkerSize', 18);
hold on;

% Channel/Image 1 
cell_properties2 = regionprops(img2_open, img1, 'MeanIntensity', 'MaxIntensity', 'PixelValues', 'Area', 'Centroid');
intensities2 = [cell_properties2.MeanIntensity];
areas2 = [cell_properties.Area];
plot(areas2, intensities2, 'g.', 'MarkerSize', 18);
xlabel('Areas', 'FontSize', 28);
ylabel('Intensities', 'FontSize', 28);

% Plotting intensity values against each other
plot(intensities, intensities2, 'b.', 'MarkerSize', 18);
xlabel('Intensities1', 'FontSize', 28);
ylabel('Intensities2', 'FontSize', 28);
