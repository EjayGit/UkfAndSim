function [ tracks ] = stateEstimate( ukf, tracks )

% For each track.
for track = 1 : 1 : size(tracks,2)

    % Find length of .X
    XLen = size(tracks(track).X, 2);
    
    % Set meas.
    meas = tracks(track).X(:, XLen);
    
    % XPredLen = size(tracks(track).XPred, 2);
    % % If XPredLen ~= XLen - 1, then an error has occured.
    
    if (XLen - 1) < 1
        
        ukf.XPred = [ tracks(track).X(1, XLen) ; 0 ; tracks(track).X(2, XLen) ; 0 ];
        
    else
        
        % Set XPred., taking into account the frameShift.
        ukf.XPred = tracks(track).XPred(:, XLen - 1);
        ukf.CPred = tracks(track).CPred;
    
    end
    
    % CPredLen = size(tracks(track).CPred, 2);
    % % If CPredLen ~= XLen - 1, then an error has occured.
        
    % Set CPred.
    

    % Start Unscented Kalman Filter
    [ ukf.XPred, ukf.CPred ] = UKFilter( ukf, meas );
    
    % Store XPred and CPred into tracks(track)
    tracks(track).XPred = cat(2, tracks(track).XPred, ukf.XPred );
    tracks(track).CPred = ukf.CPred;
    
end