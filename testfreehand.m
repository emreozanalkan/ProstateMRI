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

axis([1, 384, 1, 308])