function [ detMap ] = valDiff( valueFrame1, valueFrame2, detect )
% Calculate the difference between the two valueFrames and apply a filter
% that returns a '1' when the difference is above, and a '0' when below.


% Find the difference between the two images.
valMapDiff = valueFrame1 - valueFrame2;

% Apply the thresholdFilter.
thresholdFilter = (valMapDiff > detect.difThreshold) | (valMapDiff < -(detect.difThreshold));
detMap = zeros(size(thresholdFilter));
detMap(thresholdFilter) = 1;



% % Exchange NaN's for 0's.
% nanFilter = (isnan(valMapDiff)) | ...
%     ( (valMapDiff < detect.difThreshold) & (valMapDiff > -detect.difThreshold) );
% valMapDiff(nanFilter) = 0;


% %% Test Area Begin
% 
% 
% filterPlus = valMapDiff > 0;
% filterMinus = valMapDiff < 0;
% 
% figure(3);
% imshowpair(filterPlus, filterMinus, 'blend');
% 
% figure(6);
% imshowpair(valueFrame1, valueFrame2, 'diff');
%  figure(1);
%  imshow(detMap);
% 
% % Test Area End


end