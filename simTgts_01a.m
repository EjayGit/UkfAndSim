% This function creates the global variables:
% - 

% MOTION MODELS
%
% Constant velocity (1). motion = [speed, direction]
% Speed = (rand * 19) + 1 %%% 1 - 20 pixels per frame.
% Direction = 1 = 0 degrees
%             2 = 45 degrees
%             3 = 90 degrees
%             4 = 135 degrees
%             5 = 180 degrees
%             6 = 225 degrees
%             7 = 270 degrees
%             8 = 315 degrees

function [ measurements ] = simTgts_01a( iteration )

%randomise seed using the date and time
s = RandStream('mt19937ar','Seed','shuffle');
RandStream.setGlobalStream(s);

global simPositions simMotion simMotionType simNumNewTgts simNumFalseAlarms simKeepTgt simDetectProb simTgtAllocate simWidth simHeight simInfoTracks simMeasurements simTrackNumber simStoreDist simStoreDetect;

% Initialise start targets.
if iteration == 1
    display('Entering a blank field shall return the default value, [x]');
    simWidth = input('Enter the screen width in pixels [640]: ');
    if isempty(simWidth)
        simWidth = 640;
    end
    simHeight = input('Enter the screen height in pixels [480]: ');
    if isempty(simHeight)
        simHeight = 480;
    end
    numStartTgts = input('Enter the expected number of targets at start [5]: ');
    if isempty(numStartTgts)
        numStartTgts = 5;
    end
    simNumNewTgts = input('Enter the expected number of new targets [0.3]: ');
    if isempty(simNumNewTgts)
        simNumNewTgts = 0.3;
    end
    simNumFalseAlarms = input('Enter the expected number of false alarms [4]: ');
    if isempty(simNumFalseAlarms)
        simNumFalseAlarms = 4;
    end
    simKeepTgt = input('Enter the probability of a tgt remaining [0, 1] [0.95]: ');
    if isempty(simKeepTgt)
        simKeepTgt = 0.95;
    end
    simDetectProb = input('Enter the detection probability [0, 1] [0.9]: ');
    if isempty(simDetectProb)
        simDetectProb = 0.9;
    end
    simMotionType = input('Enter the motion type [1]: ');
    if isempty(simMotionType)
        simMotionType = 1;
    end
    startTgts = poissrnd(numStartTgts);
    simPositions = [];
    simMotion = [];
    measurements = [];
    simTgtAllocate = [];
    simInfoTracks.trackNum = []; % Not to be considered related to the variable 'tracks'.
    simInfoTracks.tgtValid = [];
    simInfoTracks.tgtPos = [];
    simInfoTracks.measValid = [];
    simInfoTracks.meas = [];
    simInfoTracks.assocTgt = [];
    simInfoTracks.XPred = [];
    simInfoTracks.PrevXPred = [];
    simTrackNumber = 1;
    simStoreDist.trackNum = [];
    simStoreDist.tgtPos = [];
    simStoreDist.assocTgt = [];
    simStoreDist.assocCheck = [];
    simStoreDist.XMeas = []; % Distance between target and associated measurement when measurement made.
    simStoreDist.XPredMeas = []; % Distance between target and predicted measurement when measurement made.
    simStoreDist.XNoMeas = []; % Distance between target and associated measurement when measurement not made.
    simStoreDist.XPredNoMeas = []; % Distance between target and predicted measurement when measurement not made.
    simStoreDetect = zeros(2,1); % Detection probability. [cumulative detection probability ; cumulative number of detections].
    for x = 1 : 1 : startTgts
        row = double(int16(rand * simHeight));
        col = double(int16(rand * simWidth));
        tempDet = [row, col];
        simPositions = cat(1, simPositions, tempDet);
        measurements = cat(1, measurements, tempDet);
        simTgtAllocate = cat(1,simTgtAllocate, x);
        switch simMotionType
            case 1
                simMotion = cat(1, simMotion, [ (int8(rand * 19) + 1), (int8(rand * 7) + 1) ]);
        end
    end
    simMeasurements = measurements;
    return
end

% Delete targets above a given threshold.
ind2remove = [];
for x = 1 : 1 : size(simPositions,1)
    if rand > simKeepTgt
        ind2remove = cat(2, ind2remove, x);
    end
end
if (~isempty(ind2remove))
    simPositions(ind2remove,:) = [];
    simMotion(ind2remove,:) = [];
end
if ~isempty(simInfoTracks)
    for x = 1 : 1 : size(ind2remove,2)
        for y = 1 : 1 : size(simInfoTracks,2)
            if ind2remove(x) == simInfoTracks(y).tgtValid
                simInfoTracks(y).tgtValid = 0;
            elseif simInfoTracks(y).tgtValid > ind2remove(x)
                simInfoTracks(y).tgtValid = simInfoTracks(y).tgtValid - 1;
            else
                continue;
            end
        end
        for z = (x + 1) : 1 : size(ind2remove,2)
            ind2remove(1,z) = ind2remove(1,z) - 1;
        end
    end
end

% Reposition previous detections based on kinematic model.
for x = 1 : 1 : size(simPositions,1)    
    prevRow = simPositions(x,1);
    prevCol = simPositions(x,2);
    switch simMotionType
        case 1
            row = double(int16(simMotion(x,1)) * sin(double((simMotion(x,2) - 1)) * deg2rad(45)));
            col = double(int16(simMotion(x,1)) * cos(double((simMotion(x,2) - 1)) * deg2rad(45)));
            simPositions(x,1) = prevRow + row;
            simPositions(x,2) = prevCol + col;
    end
end

% Delete targets outside of screen width or height.
ind2remove = [];
for x = 1 : 1 : size(simPositions,1)
    % Identify targets outside of width.
    if (simPositions(x,1) < 0) || (simPositions(x,1) > simHeight) || (simPositions(x,2) < 0) || (simPositions(x,2) > simWidth)
        ind2remove = cat(2, ind2remove, x);
    end
end
if (~isempty(ind2remove))
    simPositions(ind2remove,:) = [];
    simMotion(ind2remove,:) = [];
    if ~isempty(simInfoTracks)
        for x = 1 : 1 : size(ind2remove,2)
            for y = 1 : 1 : size(simInfoTracks,2)
                if ind2remove(x) == simInfoTracks(y).tgtValid
                    simInfoTracks(y).tgtValid = 0;
                elseif simInfoTracks(y).tgtValid > ind2remove(x)
                    simInfoTracks(y).tgtValid = simInfoTracks(y).tgtValid - 1;
                else
                    continue;
                end
            end
            for z = (x + 1) : 1 : size(ind2remove,2)
                ind2remove(1,z) = ind2remove(1,z) - 1;
            end
        end
    end
end

% Create new targets.
newTgts = poissrnd(simNumNewTgts);
for x = 1 : 1 : newTgts
    row = double(int16(rand * simHeight));
    col = double(int16(rand * simWidth));
    tempDet = [row, col];
    simPositions = cat(1, simPositions, tempDet);
    switch simMotionType
        case 1
            simMotion = cat(1, simMotion, [ (int8(rand * 19) + 1), (int8(rand * 7) + 1) ]);
    end
end

% Generate measurements.
measurements = [];
simTgtAllocate = [];
for x = 1 : 1 : size(simPositions,1)
    test = rand;
    if test <= simDetectProb
        % Noisy
        rowNoise = randn;
        colNoise = randn;
        measurements = cat(1, measurements, [ simPositions( x, 1 ) + rowNoise, simPositions( x, 2 ) + colNoise ]);
%         % Not noisy.
%         measurements = cat(1, measurements, [ simPositions( x, 1 ), simPositions( x, 2 ) ]);
        simTgtAllocate = cat(1,simTgtAllocate, x);
    end
end
if ~isempty(simInfoTracks)
    for infoTrack = 1 : 1 : size(simInfoTracks,2)
        simInfoTracks(infoTrack).measValid = 0;
    end
    for x = 1 : 1 : size(simPositions,1)
        measCheck = 0;
        for y = 1 : 1 : size(simTgtAllocate,1)
            if x == simTgtAllocate(y)
                for infoTrack = 1 : 1 : size(simInfoTracks,2)
                    if simInfoTracks(infoTrack).tgtValid == x
                        simInfoTracks(infoTrack).measValid = 1; % add check bit and break if req.
                        measCheck = 1;
                    end
                end
            end
            if measCheck == 1
                break
            end
        end
    end
end

% Generate false alarms.
falseTgts = poissrnd(simNumFalseAlarms);
for x = 1 : 1 : falseTgts
    row = double(int16(rand * simHeight));
    col = double(int16(rand * simWidth));
    tempDet = [row, col];
    measurements = cat(1, measurements, tempDet);
end

simMeasurements = measurements;

end

