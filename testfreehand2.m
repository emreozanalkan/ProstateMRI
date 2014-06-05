% test code

figure(1), 
ii = imread('Image00001.jpg');
ii = uint8(ii);
ii2(:,:,1) = ii;
ii2(:,:,2) = ii;
ii2(:,:,3) = ii;
imshow(ii);
h = imfreehand;
% 0 = background pixels (do not change).
% 1 = foreground pixels (change these colors).
maskImg = h.createMask;
[x,y] = find(maskImg == 1);
%% Now to measure area
AreaofRegion_noofpixels = regionprops(maskImg, 'area');
% AreaofRegion_noofpixels = str2num(AreaofRegion_noofpixels);
% now we have total num of pixels now lets multiply to 
spatialresultion = 0.7891; % same for all images
% Now ou r final area will be 
Areaofregion  = (AreaofRegion_noofpixels.Area) .* spatialresultion;
% Now for volume simply mulitply by slice thickness
% for slice thickness we need to read that from Dicom file
%like this slicethickness = info.SliceThickness;
slicethickness = 1;
volumeofregion = Areaofregion * slicethickness;
%%




ii = ii(x,y);
position = wait(h); 
amountIncrease = 255/2;
 
alphaImg(:,:,1) = zeros(size(maskImg)); % All zeros.
alphaImg(:,:,2) = round(maskImg*(amountIncrease)); % Round since we're dealing with integers.
alphaImg(:,:,3) = zeros(size(maskImg)); % All zeros. 
% Convert alphaImg to have the same range of values (0-255) as the origImg.
alphaImg = uint8(alphaImg);
% alphaImg = rgb2gray(alphaImg);
% 
 blendImg = ii2 + alphaImg;
figure(1), 
% hold on
imshow(blendImg);
%% Now we will male 3d model
figure(2),hold on
for k = 1:0.1:64
   plot3(position(:,1),position(:,2),ones(size(position,1),1)+k)
    
end
axis([1,384,1,308])