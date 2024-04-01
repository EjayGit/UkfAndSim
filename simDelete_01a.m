function simDelete_01a( delete )

global simInfoTracks;

if (~isempty(delete))

    simInfoTracks([delete]) = [];

end

end

