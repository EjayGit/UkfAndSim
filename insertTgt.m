function [ tracks ] = insertTgt( tracks, track, tgtPos, timestamp )

tracks(track).timestamp = cat( 2, tracks( track ).timestamp, timestamp );
tracks(track).X = cat(2, tracks( track ).X, tgtPos' );

end

