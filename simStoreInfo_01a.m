function simStoreInfo_01a( tracks )

global simInfoTracks simStoreDist simStoreDetect simMeasurements simTgtAllocate;

if ~isempty(simInfoTracks)
    
    if isempty(simStoreDist(1).trackNum)
        newTrack = 1;
    else
        newTrack = size(simStoreDist,2) + 1;
    end
    
    for track = 1 : 1 : size(simInfoTracks,2)
        if tracks(track).active(1, size(tracks(track).active,2)) == 1
            if simInfoTracks(track).tgtValid > 0
                match = 0;
                for store = 1 : 1 : size(simStoreDist,2)
                    if simStoreDist(store).trackNum == simInfoTracks(track).trackNum
                        simStoreDist(store).tgtPos = cat(2, simStoreDist(store).tgtPos, simInfoTracks(track).tgtPos);
                        simStoreDist(store).assocTgt = cat(2, simStoreDist(store).assocTgt, simInfoTracks(track).assocTgt);
                        simStoreDist(store).assocCheck = cat(2, simStoreDist(store).assocCheck, 0);
                        if simInfoTracks(track).measValid == 0
                            XNoMeasDistance = sqrt(((simInfoTracks(track).tgtPos(1))-(simInfoTracks(track).assocTgt(1)))^2 + ((simInfoTracks(track).tgtPos(2))-(simInfoTracks(track).assocTgt(2)))^2);
                            simStoreDist(store).XNoMeas = cat(2, simStoreDist(store).XNoMeas, XNoMeasDistance);
                            XPredNoMeasDistance = sqrt(((simInfoTracks(track).tgtPos(1))-(simInfoTracks(track).PrevXPred(1)))^2 + ((simInfoTracks(track).tgtPos(2))-(simInfoTracks(track).PrevXPred(3)))^2);
                            simStoreDist(store).XPredNoMeas = cat(2, simStoreDist(store).XPredNoMeas, XPredNoMeasDistance);
                            match = 1;
                        elseif simInfoTracks(track).measValid == 1
                            XMeasDistance = sqrt(((simInfoTracks(track).tgtPos(1))-(simInfoTracks(track).assocTgt(1)))^2 + ((simInfoTracks(track).tgtPos(2))-(simInfoTracks(track).assocTgt(2)))^2);
                            simStoreDist(store).XMeas = cat(2, simStoreDist(store).XMeas, XMeasDistance);
                            XPredMeasDistance = sqrt(((simInfoTracks(track).tgtPos(1))-(simInfoTracks(track).PrevXPred(1)))^2 + ((simInfoTracks(track).tgtPos(2))-(simInfoTracks(track).PrevXPred(3)))^2);
                            simStoreDist(store).XPredMeas = cat(2, simStoreDist(store).XPredMeas, XPredMeasDistance);
                            match = 1;
                        end
                    end
                    if match == 1
                        break
                    else
                        continue
                    end
                end
                if match == 0
                    simStoreDist(newTrack).trackNum = simInfoTracks(track).trackNum;
                    simStoreDist(newTrack).tgtPos = simInfoTracks(track).tgtPos;
                    simStoreDist(newTrack).assocTgt = simInfoTracks(track).assocTgt;
                    simStoreDist(newTrack).assocCheck = 0;
                    if simInfoTracks(track).measValid == 0
                        XNoMeasDistance = sqrt(((simInfoTracks(track).tgtPos(1))-(simInfoTracks(track).assocTgt(1)))^2 + ((simInfoTracks(track).tgtPos(2))-(simInfoTracks(track).assocTgt(2)))^2);
                        simStoreDist(newTrack).XNoMeas = XNoMeasDistance;
                        XPredNoMeasDistance = sqrt(((simInfoTracks(track).tgtPos(1))-(simInfoTracks(track).PrevXPred(1)))^2 + ((simInfoTracks(track).tgtPos(2))-(simInfoTracks(track).PrevXPred(3)))^2);
                        simStoreDist(newTrack).XPredNoMeas = XPredNoMeasDistance;
                    elseif simInfoTracks(track).measValid == 1
                        XMeasDistance = sqrt(((simInfoTracks(track).tgtPos(1))-(simInfoTracks(track).assocTgt(1)))^2 + ((simInfoTracks(track).tgtPos(2))-(simInfoTracks(track).assocTgt(2)))^2);
                        simStoreDist(newTrack).XMeas = XMeasDistance;
                        XPredMeasDistance = sqrt(((simInfoTracks(track).tgtPos(1))-(simInfoTracks(track).PrevXPred(1)))^2 + ((simInfoTracks(track).tgtPos(2))-(simInfoTracks(track).PrevXPred(3)))^2);
                        simStoreDist(newTrack).XPredMeas = XPredMeasDistance;
                    end
                    newTrack = newTrack + 1;
                end
            end
        end
    end
    
    
    for track = 1 : 1 : size(simInfoTracks,2)
        if tracks(track).active(1, size(tracks(track).active,2)) == 1
            simStoreDetect(2,1) = simStoreDetect(2,1) + 1;
            if simInfoTracks(track).tgtValid > 0
                for meas = 1 : 1 : size(simTgtAllocate,1)
                    if simInfoTracks(track).assocTgt(1) == simMeasurements(meas,1) && simInfoTracks(track).assocTgt(2) == simMeasurements(meas,2)
                        simStoreDetect(1,1) = simStoreDetect(1,1) + 1;
                        for store = 1 : 1 : size(simStoreDist,2)
                            if simStoreDist(store).trackNum == simInfoTracks(track).trackNum
                                simStoreDist(store).assocCheck(1,(size(simStoreDist(store).assocCheck,2))) = 1;
                            end
                        end
                    end
                end
            end
        else
            continue;
        end
    end

end

end
