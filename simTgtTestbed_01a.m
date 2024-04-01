%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% It is important that the user ensures that the number of iterations that
% their tracker calls this 'detector createor' is set to go from '1', to
% '200'. There will be a period of 40 iterations where there shall be no
% target output between the 2 tests.
%
% This testbed shall provide two sets of output measurements.
%
% The first shall be a set of pure target positions. Constant speed and
% direction across the diagonal of the 'screen'.
%
% The second shall be a set of pre set measurements of the original target,
% and carry the following characteristics with reference to their distance
% from the actual target position:
%
% - Mean = 1.4512.
% - Variation = 0.4239.
% - Min = 0.2069.
% - Max = 2.9351.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [ measurements ] = simTgtTestbed_01a( iteration )

global simPositions simTgtAllocate simWidth simHeight simInfoTracks simMeasurements simTrackNumber simStoreDist simStoreDetect;

% Initialise start targets.
if iteration == 1
    simWidth = 640;
    simHeight = 480;
    simPositions = [];
    measurements = [];
    simTgtAllocate = [];
    simInfoTracks.trackNum = []; % Not to be considered related to the variable 'tracks'.
    simInfoTracks.tgtValid = [];
    simInfoTracks.tgtPos = [];
    simInfoTracks.measValid = [];
    simInfoTracks.meas = [];
    simInfoTracks.assocTgt = [];
    simInfoTracks.assocCheck = [];
    simInfoTracks.XPred = [];
    simInfoTracks.PrevXPred = [];
    simTrackNumber = 1;
    simStoreDist.trackNum = [];
    simStoreDist.XMeas = []; % Distance between target and associated measurement when measurement made.
    simStoreDist.XPredMeas = []; % Distance between target and predicted measurement when measurement made.
    simStoreDist.XNoMeas = []; % Distance between target and associated measurement when measurement not made.
    simStoreDist.XPredNoMeas = []; % Distance between target and predicted measurement when measurement not made.
    simStoreDetect = zeros(2,1); % Detection probability. [cumulative detection probability ; cumulative number of detections].
end
% testPos = [row,col]

% testPos = [0 1
% 1 1
% 3 1
% 7 1
% 11 1
% 17 1
% 23 1
% 31 1
% 40 1
% 50 1
% 61 1
% 73 1
% 87 1
% 101 1
% 117 1
% 133 1
% 151 1
% 170 1
% 190 1
% 210 1
% 230 1
% 250 1];    

testPos =  [ 1   633
             7   625
            13   617
            19   609
            25   601
            31   593
            37   585
            43   577
            49   569
            55   561
            61   553
            67   545
            73   537
            79   529
            85   521
            91   513
            97   505
           103   497
           109   489
           115   481
           121   473
           127   465
           133   457
           139   449
           145   441
           151   433
           157   425
           163   417
           169   409
           175   401
           181   393
           187   385
           193   377
           199   369
           205   361
           211   353
           217   345
           223   337
           229   329
           235   321
           241   313
           247   305
           253   297
           259   289
           265   281
           271   273
           277   265
           283   257
           289   249
           295   241
           301   233
           307   225
           313   217
           319   209
           325   201
           331   193
           337   185
           343   177
           349   169
           355   161
           361   153
           367   145
           373   137
           379   129
           385   121
           391   113
           397   105
           403    97
           409    89
           415    81
           421    73
           427    65
           433    57
           439    49
           445    41
           451    33
           457    25
           463    17
           469     9
           475     1];

testPos2 = [ 1     1
             7     9
            13    17
            19    25
            25    33
            31    41
            37    49
            43    57
            49    65
            55    73
            61    81
            67    89
            73    97
            79   105
            85   113
            91   121
            97   129
            103   137
            109   145
            115   153
            121   161
            127   169
            133   177
            139   185
            145   193
            151   201
            157   209
            163   217
            169   225
            175   233
            181   241
            187   249
            193   257
            199   265
            205   273
            211   281
            217   289
            223   297
            229   305
            235   313
            241   321
            247   329
            253   337
            259   345
            265   353
            271   361
            277   369
            283   377
            289   385
            295   393
            301   401
            307   409
            313   417
            319   425
            325   433
            331   441
            337   449
            343   457
            349   465
            355   473
            361   481
            367   489
            373   497
            379   505
            385   513
            391   521
            397   529
            403   537
            409   545
            415   553
            421   561
            427   569
            433   577
            439   585
            445   593
            451   601
            457   609
            463   617
            469   625
            475   633];

testMeas = [1.4411    1.7984
            7.5740    9.3844
           13.7963   15.1218
           20.1695   27.6378
           25.1959   34.7164
           29.7782   39.8832
           35.9811   47.6294
           43.8789   56.9969
           51.2339   63.9170
           54.6381   70.1547
           61.5805   81.1861
           68.6225   87.5987
           74.8628   96.7883
           79.2354  107.1634
           85.4476  113.5766
           90.7288  120.6737
           98.4143  130.0611
          102.0148  137.2201
          109.0564  143.5595
          115.8581  153.2022
          120.7615  160.6957
          128.5528  168.4722
          134.0458  175.9687
          138.8900  185.4541
          143.1600  193.3736
          151.8197  201.7782
          156.8362  210.9921
          164.5154  216.5594
          168.3745  226.0024
          175.6337  231.6882
          180.7050  243.0389
          185.8483  249.4300
          192.8008  255.9268
          197.3534  265.8620
          207.0666  271.5687
          211.0882  280.7262
          217.2265  289.3914
          222.9792  295.3781
          229.7362  306.5473
          236.5308  314.0432
          239.4070  320.7885
          246.7569  331.2257
          253.3342  336.1483
          258.6443  343.9251
          264.0481  353.9775
          268.4101  360.9307
          274.9794  368.6987
          283.3136  378.3813
          287.6287  383.7629
          295.5001  392.9857
          303.8922  401.4999
          306.1279  410.4516
          313.9370  417.9293
          319.9461  425.8064
          322.6645  433.2551
          329.9595  441.0438
          339.3681  449.7888
          343.1605  455.6052
          349.4806  465.6802
          355.7362  471.6725
          359.4740  482.5065
          367.9850  490.0806
          372.3474  496.3033
          379.3083  504.8962
          384.9000  511.8657
          391.0006  519.6104
          397.0862  529.2630
          404.1464  537.7792
          408.5030  543.6202
          415.0729  551.7510
          420.3918  560.2956
          427.1674  569.7996
          432.6330  576.0965
          440.3855  584.9391
          443.5541  593.6882
          451.0452  600.7981
          458.2629  607.5382
          464.8489  616.1430
          470.1989  624.5023
          476.5781  632.0379];

if (iteration > 0) && (iteration <81)
    simPositions = [testPos(iteration,1), testPos(iteration,2)];
    simTgtAllocate = 1;
    measurements = [testPos(iteration,1), testPos(iteration,2)];
elseif (iteration > 80) && (iteration < 121)
    simPositions = [];
    simTgtAllocate = [];
    measurements = [];
    for x = 1 : 1 : size(simInfoTracks,2)
        simInfoTracks(x).tgtValid = 0;
    end
elseif (iteration > 120)
    simPositions = [testPos2((iteration-120),1), testPos2((iteration-120),2)];
    simTgtAllocate = 1;
    measurements = [testMeas((iteration-120),1), testMeas((iteration-120),2)];
end

simMeasurements = measurements;

end

