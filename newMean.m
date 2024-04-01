function [ XPredY ] = newMean( Wm0, Wi, SigmaProcY )

XPredY = Wm0 * SigmaProcY(:,1);

for i = 2 : 1 : size(SigmaProcY,2)
    XPredY(:,1) = XPredY(:,1) + ( Wi * SigmaProcY(:,i) );
end

end

