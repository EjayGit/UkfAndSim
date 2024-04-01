function [ simStats ] = trackTgts( associate, ukf )

global simWidth simHeight simPositions simTgtAllocate simMeasurements;

finalIteration = 200;
storeTgtMeas = [];

% Initialise tracks.
tracks.active = [];
tracks.confidence = [];
tracks.timestamp = [];
tracks.X = [];
tracks.XPred = [];
tracks.CPred = [];

% % Load first frame.
% for frame = 1 : 1 : video.startFrame
%     video.RGBframe1 = readFrame( video.file );
% end
% 
% % Turn RGBframe 1 into valueFrame 1.
% [ valueFrame1 ] = RGB2Val( video.RGBframe1 );

% Start for loop for length of required frames.
for timestamp = 1 : 1 : finalIteration
    
%     % Load second frame data.
%     video.RGBframe2 = readFrame( video.file );
%     
%     % Turn RGBframe 2 into valueFrame 2.
%     [ valueFrame2 ] = RGB2Val( video.RGBframe2 );
%     
%     % Register image.
%     [ frameShift, tracks ] = registerFrames( valueFrame1, valueFrame2, video, tracks );
%     
%     % Find detections.
%     [ frameTgts ] = detectTgts( valueFrame1, valueFrame2, detect, frameShift );
    
% Sim info.
    [ frameTgts ] = simTgtTestbed_01a( timestamp );
% Sim info end.

    % Associate detections.
    [ tracks, delete ] = associateTgts( tracks, frameTgts, associate, timestamp );
    
    if ~isempty(tracks)
        isTracks = size( tracks(1).timestamp, 2 ) > 0;
    else
        isTracks = 0;
    end
    if isTracks

        % State Estimation.
        [ tracks ] = stateEstimate( ukf, tracks );

% Sim info.
        simInfoUpdate_01a( tracks );
% Sim info end.  

        [ tracks ] = deleteTracks( tracks, delete );

% Sim info.
        simDelete_01a( delete );
        simStoreInfo_01a( tracks );
% Sim info end.
        
% % TEST AREA   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% %   TURN THIS INTO A PLOT AREA AND USE 'HANDLES' AND 'SET' COMMANDS INSTEAD
% %   OF LOOPING 'PLOT'.
% %         imshow(video.RGBframe2);         
        figure(1);
        subplot('Position', [0.05 0.57 0.3 0.3]);
        hold on;
        title('Track Measurements held on');
        axis([-100 simWidth+100 -100 simHeight+100]);
        if ~isempty(frameTgts)
            cla
            for tgtMeas = 1 : 1 : size(simTgtAllocate,1)
                storeTgtMeas = cat(1,storeTgtMeas, simMeasurements(tgtMeas,:));
            end
            plot(storeTgtMeas(:,2), storeTgtMeas(:,1), 'bx');
            
            if isempty(simTgtAllocate)
                fAStart = 1;
            else
                fAStart = size(simTgtAllocate,1);
            end
            if ~isempty(simMeasurements)
                storefalseAlarms = [];
                for falseAlarm = fAStart : 1 : size(simMeasurements,1)
                    storefalseAlarms = cat(1,storefalseAlarms, simMeasurements(falseAlarm,:));
                end
            end
            plot(storefalseAlarms(:,2), storefalseAlarms(:,1), 'bx');
        end
        hold off;
        
        subplot('Position', [0.58 0.73 0.2 0.2]);
        hold on;
        title('All Iteration Measurements');
        axis([-100 simWidth+100 -100 simHeight+100]);
        cla
        if ~isempty(simMeasurements)
            plot(simMeasurements(:,2),simMeasurements(:,1),'bx');
        end
        hold off;

        subplot('Position', [0.05 0.12 0.3 0.3]);
        hold on;
        title('Active Track Measurement and State Estimations');
        axis([-100 simWidth+100 -100 simHeight+100]);
        for track = 1 : 1 : size(tracks,2)
            if tracks(track).active(1, size(tracks(track).active,2)) == 1
                lenXPred = size(tracks(track).XPred,2);
                if lenXPred > 30
                    plotXPred = tracks(track).XPred(:,(lenXPred-30):lenXPred);
                else
                    plotXPred = tracks(track).XPred;
                end
                plot(plotXPred(3,:), plotXPred(1,:), '-r');
                plot(plotXPred(3,:), plotXPred(1,:), 'or');
                lenX = size(tracks(track).X,2);
                if lenX > 30
                    plotX = tracks(track).X(:,(lenX-30):lenX);
                else
                    plotX = tracks(track).X;
                end
                plot(plotX(2,:), plotX(1,:), 'xb');
            end
        end
        hold off;
        
        subplot('Position', [0.43 0.12 0.5 0.5]);
        hold on;
        title('Targets, their Measurements, and Active Tracks');
        axis([-100 simWidth+100 -100 simHeight+100]);
        if ~isempty(simPositions)
            plot(simPositions(:,2), simPositions(:,1), 'gx');
        end
        plot(storeTgtMeas(:,2), storeTgtMeas(:,1), 'bx');
        for track = 1 : 1 : size(tracks,2)
            if tracks(track).active(1, size(tracks(track).active,2)) == 1
                lenXPred = size(tracks(track).XPred,2);
                if lenXPred > 30
                    plotXPred = tracks(track).XPred(:,(lenXPred-30):lenXPred);
                else
                    plotXPred = tracks(track).XPred;
                end
                plot(plotXPred(3,:), plotXPred(1,:), '-r');
            end
        end
        hold off;
        pause(0.1);
% %
% % TEST AREA END   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end
    
%     % Transfer frame 2 information into frame 1 information.
%     valueFrame1 = valueFrame2;
    
% End for loop.
end

% Sim info.
[ simStats ] = simShowStats;
% Sim info end.

end

