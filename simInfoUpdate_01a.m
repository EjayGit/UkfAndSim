function simInfoUpdate_01a( tracks )

global simInfoTracks simPositions simTgtAllocate simMeasurements simTrackNumber;

if (isempty(tracks) && isempty(simInfoTracks))
    return;
end
if ~isempty(simInfoTracks)
    if isempty(simInfoTracks(1).tgtValid)
        newTrack = 1;
    else
        newTrack = size(simInfoTracks,2) + 1;
    end
else
    newTrack = 1;
end

%%%%%%%%%%%%%%%%%%%%%
if ~isempty(tracks)
        isTracks = size( tracks(1).timestamp, 2 ) > 0;
    else
        isTracks = 0;
    end
    if isTracks
%%%%%%%%%%%%%%%%%%%%%

% Ensure that any infoTracks that have .tgtValid == 0 are checked to see if
% they are following any targets (simMeasurements) and administrate them
% appropriately.
for track = 1 : 1 : size(simInfoTracks,2)
    if simInfoTracks(track).tgtValid == 0
        for x = 1 : 1 : size(simTgtAllocate,1)
            if tracks(track).X(:,size(tracks(track).X,2)) == simMeasurements(x,:)'
                simInfoTracks(track).tgtValid = x;
                simInfoTracks(track).tgtPos = simPositions((simTgtAllocate(x)),:)';
                simInfoTracks(track).assocTgt(:, size(simInfoTracks(track).assocTgt,2)) = simMeasurements(x,:)';
                simInfoTracks(track).measValid = 1;
                simInfoTracks(track).meas = simInfoTracks(track).assocTgt;
                break
            end
        end
    end
end

% Generate information for simInfoTracks.
if ~isempty(tracks) % If this is empty and simInfoTracks is not empty, then an error has occurred.
    for track = 1 : 1 : size(tracks,2)
        if track < newTrack
            % For exisiting infoTracks.
            if simInfoTracks(track).tgtValid == 0
                for x = 1 : 1 : size(simTgtAllocate,1)
                    if simInfoTracks(track).assocTgt(:, size(simInfoTracks(track).assocTgt,2)) == simMeasurements(x,:)'
                        % If so, validate.
                        simInfoTracks(track).measValid = 1;
                        simInfoTracks(track).meas = simInfoTracks(track).assocTgt;
                        simInfoTracks(track).tgtValid = simTgtAllocate(x);
                        simInfoTracks(track).tgtPos = simPositions((simTgtAllocate(x)),:)';
                        break;
                    end
                end
            end
            if simInfoTracks(track).tgtValid > 0
                simInfoTracks(track).tgtPos = simPositions(simInfoTracks(track).tgtValid,:)';
                simInfoTracks(track).assocTgt = tracks(track).X(:,size(tracks(track).X,2));
                simInfoTracks(track).PrevXPred = simInfoTracks(track).XPred;
                simInfoTracks(track).XPred = tracks(track).XPred(:,size(tracks(track).XPred,2));
                if simInfoTracks(track).measValid == 1
                    for x = 1 : 1 : size(simTgtAllocate)
                        if simInfoTracks(track).tgtValid == simTgtAllocate(x)
                            simInfoTracks(track).meas = simMeasurements(x,:)';
                            break;
                        end
                    end
                end
            end
        else
            % For new infoTracks.
            simInfoTracks(track).trackNum = simTrackNumber;
            simInfoTracks(track).assocTgt = tracks(track).X(:,size(tracks(track).X,2));
            simInfoTracks(track).PrevXPred = simInfoTracks(track).XPred;
            simInfoTracks(track).XPred = tracks(track).XPred(:,size(tracks(track).XPred,2));
            simInfoTracks(track).tgtValid = 0;
            simInfoTracks(track).measValid = 0;
            for x = 1 : 1 : size(simTgtAllocate,1)
                if simInfoTracks(track).assocTgt(:, size(simInfoTracks(track).assocTgt,2)) == simMeasurements(x,:)'
                    % If so, validate.
                    simInfoTracks(track).measValid = 1;
                    simInfoTracks(track).meas = simInfoTracks(track).assocTgt;
                    simInfoTracks(track).tgtValid = simTgtAllocate(x);
                    simInfoTracks(track).tgtPos = simPositions((simTgtAllocate(x)),:)';
                    break;
                end
            end
            simTrackNumber = simTrackNumber + 1;
        end
    end    
end

end

