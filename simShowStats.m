function [ showStats ] = simShowStats

global simStoreDist simStoreDetect;

number = size(simStoreDist,2);

showStats.dist.trackNum = [];
showStats.dist.XMeas.mean = [];
showStats.dist.XMeas.var = [];
showStats.dist.XMeas.min = [];
showStats.dist.XMeas.max = [];
showStats.dist.XPredMeas.mean = [];
showStats.dist.XPredMeas.var = [];
showStats.dist.XPredMeas.min = [];
showStats.dist.XPredMeas.max = [];
showStats.dist.XNoMeas.mean = [];
showStats.dist.XNoMeas.var = [];
showStats.dist.XNoMeas.min = [];
showStats.dist.XNoMeas.max = [];
showStats.dist.XPredNoMeas.mean = [];
showStats.dist.XPredNoMeas.var = [];
showStats.dist.XPredNoMeas.min = [];
showStats.dist.XPredNoMeas.max = [];
showStats.detect = [];

for track = 1 : 1 : number
    showStats.dist(track).trackNum = simStoreDist(track).trackNum;
    showStats.dist(track).XMeas.mean = mean(simStoreDist(track).XMeas);
    showStats.dist(track).XMeas.var = var(simStoreDist(track).XMeas);
    showStats.dist(track).XMeas.min = min(simStoreDist(track).XMeas);
    showStats.dist(track).XMeas.max = max(simStoreDist(track).XMeas);
    showStats.dist(track).XPredMeas.mean = mean(simStoreDist(track).XPredMeas);
    showStats.dist(track).XPredMeas.var = var(simStoreDist(track).XPredMeas);
    showStats.dist(track).XPredMeas.min = min(simStoreDist(track).XPredMeas);
    showStats.dist(track).XPredMeas.max = max(simStoreDist(track).XPredMeas);
    showStats.dist(track).XNoMeas.mean = mean(simStoreDist(track).XNoMeas);
    showStats.dist(track).XNoMeas.var = var(simStoreDist(track).XNoMeas);
    showStats.dist(track).XNoMeas.min = min(simStoreDist(track).XNoMeas);
    showStats.dist(track).XNoMeas.max = max(simStoreDist(track).XNoMeas);
    showStats.dist(track).XPredNoMeas.mean = mean(simStoreDist(track).XPredNoMeas);
    showStats.dist(track).XPredNoMeas.var = var(simStoreDist(track).XPredNoMeas);
    showStats.dist(track).XPredNoMeas.min = min(simStoreDist(track).XPredNoMeas);
    showStats.dist(track).XPredNoMeas.max = max(simStoreDist(track).XPredNoMeas);
end

showStats.detect = simStoreDetect(1,1)/simStoreDetect(2,1);

end

