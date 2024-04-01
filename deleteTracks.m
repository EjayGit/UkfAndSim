function [ tracks ] = deleteTracks( tracks, delete )

if (~isempty(delete))

    tracks([delete]) = [];

end

end

