function [ frameShift, tracks ] = registerFrames( valueFrame1, valueFrame2, video, tracks )

corrResult = normxcorr2(valueFrame2, valueFrame1);

[ ~ , maxIndice ] = max(abs(corrResult(:)));
[yPeak, xPeak] = ind2sub(size(corrResult),maxIndice(1));

frameShift.x = xPeak - video.file.Width;
frameShift.y = yPeak - video.file.Height;

if ~isempty(tracks)
    if ~isempty(tracks(1).active)
        for track = 1 : 1 : size(tracks,2)
            tracks(track).X(1,:) = tracks(track).X(1,:) - frameShift.x;
            tracks(track).X(2,:) = tracks(track).X(2,:) - frameShift.y;
            tracks(track).XPred(1,:) = tracks(track).XPred(1,:) - frameShift.x;
            tracks(track).XPred(3,:) = tracks(track).XPred(3,:) - frameShift.y;
        end
    end
end

end