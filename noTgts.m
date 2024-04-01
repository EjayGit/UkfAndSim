function [ tracks ] = noTgts( tracks, numOfTracks, timestamp )

for track = 1 : 1 : numOfTracks
    
    tracks(track).timestamp = cat(2, tracks(track).timestamp, timestamp );
    
end

end