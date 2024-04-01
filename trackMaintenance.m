function [ tracks, delete ] = trackMaintenance( associate, tracks )

trackDelete = zeros(size( tracks, 2 ), 1);

% For each track.
for track = 1 : 1 : size( tracks, 2 )
    
    % Find length of track data.
    trackTime = size(tracks(track).timestamp,2);
    
    % If the size of a track is less than 'x', tracks(current).active = 2.
    if trackTime < associate.deactivateNum

        tracks(track).active(1, trackTime) = 2;
        
        % Check if the corresponding .X is empty, then fill it with the
        % tracks(current - 1).XPred(R1&3, C_Last), and set
        % tracks(current).active = 2.
        if size(tracks(track).X, 2) ~= size(tracks(track).timestamp, 2)
            
            tracks(track).X = cat(2, tracks(track).X, [tracks(track).XPred(1, size(tracks(track).XPred, 2)); tracks(track).XPred(3, size(tracks(track).XPred, 2)) ]);
            
        end

    else
        
        % Make .active = 1.
        tracks(track).active(1, trackTime) = 1;
        
        % If the corresponding .X is empty, then fill it with the
        % tracks(current - 1).XPred(R1&3, C_Last), and set
        % tracks(current).active = 2.
        if size(tracks(track).X, 2) ~= size(tracks(track).timestamp, 2)
            
            tracks(track).X = cat(2, tracks(track).X, [tracks(track).XPred(1, size(tracks(track).XPred, 2)); tracks(track).XPred(3, size(tracks(track).XPred, 2)) ]);
            tracks(track).active(1, trackTime) = 2;
            
        end
        
        % If the previous 'x' timestamps all have '2' associated in their
        % corresponding .active fields, then delete track.
        check2 = 0;
        for count = 0 : 1 : ( associate.deactivateNum - 1 )

            if tracks(track).active( 1, trackTime - count ) == 2

                check2 = check2 + 1;

            end
            
        end
        if check2 == ( associate.deactivateNum )
            
            % Set mark for track deletion.
            trackDelete(track, 1) = 1;
            
        end
        
    end
    
    % Identify confidence level (sum all '1' and '3' and
    % divide by size of .confidence) if the confidence level is lower than
    % a preset threshold, then set .active to '3'.
    value = 0;
    for count = 1 : 1 : size(tracks(track).active,2)
        if (tracks(track).active(1,count) == 1) || (tracks(track).active(1,count) == 3)
            value = value + 1;
        end
    end
    tracks(track).confidence = (value)/size(tracks(track).active,2);
    if tracks(track).active(1,size(tracks(track).active,2)) == 1
        if tracks(track).confidence < associate.confidence
            tracks(track).active(1, trackTime) = 3;
        end
    end    
end

% Identify tracks that have the same last '2' measurements as another
% track, and mark 'trackDelete' for all of those tracks except for the
% one that has the lowest value in memory slot
% 'tracks(track).timestamp(1,1)'.

% For each track.

    % Create variable, zeros(trackNum,2) so that each track's measurements
    % can be marked whether it is the same as the current track.

    % If the current track has '2' or more measurements (> 1).
    
            % Then for every other track.
            
                % If the other track has more than '2' measurements.
                
                    % If the '2' most recent measurements are the
                    % same.
                    
                        % Then check the value of
                        % 'tracks(track).timestamp(1,1)' for both tracks.
                        
                            % Delete the track that has the largest value
                            % (smallest time). (Mark trackDelete).
                            
                            
                            % If the value is the same, then delete the
                            % tracks with the lowest confidence. (Keep the
                            % highest).
                            
                            
                            % If the confidence is the same, then delete
                            % all but one.



% Delete marked tracks
delete = [];
for track = 1 : 1 : size( tracks, 2 )
    
    if trackDelete(track) == 1
        
        delete = cat(2, delete, track);
        
    end
    
end

end

