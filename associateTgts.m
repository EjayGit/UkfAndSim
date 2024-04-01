function [ tracks, delete ] = associateTgts( tracks, frameTgts, associate, timestamp )

numOfTracks = size( tracks, 2 );
numOfTgts = size( frameTgts, 1 );
if ~isempty(tracks)
    isTracks = size( tracks(1).timestamp, 2 ) > 0;
else
    isTracks = 0;
end
isTgts = numOfTgts > 0;

if ( isTgts ) && ( isTracks )
    
    usedTgts = zeros( numOfTgts, 1 );
    
    % For each track. 
    for track = 1 : 1 : numOfTracks
        
        % C1 = distance. C2 = detection number.
        tempTgtAssoc = [ associate.maxRange, 0 ];
        
        % Consider the detection.
        for target = 1 : 1 : numOfTgts
            
            % Change to Mahalanobis.
            
            % Find max distance permitted (prev measurement to new
            % measurement.
            testMaxDistance = sqrt( ( frameTgts(target, 1) - tracks(track).X(1, size(tracks(track).X, 2)) )^2 + ( frameTgts(target, 2) - tracks(track).X(2, size(tracks(track).X, 2)) )^2);
            
            % Find distance between new measurement and estimated
            % measurement
            distance = sqrt( ( frameTgts(target, 1) - tracks(track).XPred(1, size(tracks(track).XPred, 2)) )^2 + ( frameTgts(target, 2) - tracks(track).XPred(3, size(tracks(track).XPred, 2)) )^2);
            
            % If the distance between the detection and the state estimate is smaller than the max range or previous record made, overwrite new minimum distance and mark detection.
            if ( testMaxDistance < associate.maxRange ) && ( distance < tempTgtAssoc( 1, 1 ) )
                
                % Insert new distance.
                tempTgtAssoc( 1, 1 ) = distance;
                
                % Mark detection.
                tempTgtAssoc( 1, 2 ) = target;
                
            end
            
        end
        
        % Mark tgts used by track so unassociated tgts can be identified.
        if tempTgtAssoc( 1, 2 ) ~= 0
            
            usedTgts( tempTgtAssoc( 1, 2 ), 1 ) = 1;
            % Insert Tgt.
            [ tracks ] = insertTgt( tracks, track, frameTgts( tempTgtAssoc( 1, 2 ), : ), timestamp );
            
        elseif tempTgtAssoc( 1, 2 ) ~= 1
            
            tracks(track).timestamp = cat(2, tracks(track).timestamp, timestamp );
            
        end
        
    end

    % Deal with unassociated tgts.
    [ tracks ] = newTgts( tracks, frameTgts, usedTgts, numOfTgts, timestamp );

elseif ( isTgts ) && ( ~isTracks )
    
    % Mark all tgts as unassociated.
    usedTgts = zeros( numOfTgts, 1 );
    
    % Deal with unassociated tgts.
    [ tracks ] = newTgts( tracks, frameTgts, usedTgts, numOfTgts, timestamp );
    
    
elseif ( ~isTgts ) && ( isTracks )
    
    % Update track timestamps
    [ tracks ] = noTgts( tracks, numOfTracks, timestamp );
        
end

% Maintain tracks
[ tracks, delete ] = trackMaintenance( associate, tracks );

end

