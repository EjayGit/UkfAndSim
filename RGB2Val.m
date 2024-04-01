function [ valueFrame1 ] = RGB2Val( RGBframe1 )

% Acquire HSV from frame 1.
RGBColourMap1 = single(RGBframe1) / 255;
HSVColourMap1 = rgb2hsv(RGBColourMap1);

% % Acquire HSV from frame 2.
% RGBColourMap2 = single(RGBframe2) / 255;
% HSVColourMap2 = rgb2hsv(RGBColourMap2);

% Specify Value data for comparison
valueFrame1 = HSVColourMap1(:,:,3);
% valueFrame2 = HSVColourMap2(:,:,3);

end