function [ tracks ] = newTgts( tracks, frameTgts, usedTgts, numOfTgts, timestamp )

if ~isempty(tracks)
    isTracks = size( tracks(1).timestamp, 2 ) > 0;
else
    isTracks = 0;
end
if isTracks
    
    newTrackNum = size(tracks,2);
    
else
    
    newTrackNum = 0;
    
end

for target = 1 : 1 : numOfTgts
    
    if usedTgts( target, 1 ) == 0
        
        newTrackNum = newTrackNum + 1;
        tracks(newTrackNum).active = 2;
        tracks(newTrackNum).timestamp = timestamp;
        tracks(newTrackNum).X = [ frameTgts( target, 1 ) ; frameTgts( target, 2 ) ];
                
    end
    
end

end