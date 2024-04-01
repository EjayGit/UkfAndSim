function [ detList ] = detectMovement( valueFrame1, valueFrame2, detect, frameShift )

% Return the two valueFrame's with a fill of NaN's approprately placed so
% that the two valueFrame's can be mounted over each other where the image
% co-ordinates will match.
[ valueFrame1, valueFrame2 ] = alignFrames( valueFrame1, valueFrame2, frameShift );

% Calculate the difference between the two valueFrames and apply a filter
% that returns a '1' when the difference is above the modulus, and a '0'
% when below.
[ detMap ] = valDiff( valueFrame1, valueFrame2, detect );

% Identify the centres of interest from the detMap. These are the
% 'detections'.
[ detList ] = detIdent( detMap, detect );


end