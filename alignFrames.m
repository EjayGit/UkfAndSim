function [ valueFrame1, valueFrame2 ] = alignFrames( valueFrame1, valueFrame2, frameShift )
% Returns the two valueFrame's with a fill of NaN's approprately placed so
% that the two valueFrame's can be mounted over each other where the image
% co-ordinates will match.


% Identify the number of columns in valueFrame so that the fill can be
% sized appropriately.
[ ~, cols, ~ ] = size(valueFrame1);

% Build the fill of NaN's.
fill = NaN( [ abs(frameShift.y), cols ] );

% Place the fill appropriately.
if frameShift.y < 0
    valueFrame1 = cat(1, fill, valueFrame1);
    valueFrame2 = cat(1, valueFrame2, fill);

else
    valueFrame1 = cat(1, valueFrame1, fill);
    valueFrame2 = cat(1, fill, valueFrame2);
end

% Identify the number of rows in valueFrame so that the fill can be
% sized appropriately. This will take into account any fill used as a
% result of any vertical shift.
[ rows, ~, ~ ] = size(valueFrame1);

% Build the fill of NaN's.
fill = NaN( [ rows, abs(frameShift.x)] );

% Place the fill appropriately.
if frameShift.x < 0
    valueFrame1 = cat(2, fill, valueFrame1);
    valueFrame2 = cat(2, valueFrame2, fill);
else
    valueFrame1 = cat(2, valueFrame1, fill);
    valueFrame2 = cat(2, fill, valueFrame2);
end

end