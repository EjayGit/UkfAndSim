function [ CPred ] = newCov( Wc0, Wi, sigmas, XPred, noise )

CPred = Wc0 * ((sigmas(:,1) - XPred)*(sigmas(:,1) - XPred)');

for i = 2 : 1 : size(sigmas,2)
    CPred = CPred + ( Wi * ((sigmas(:,i) - XPred)*(sigmas(:,i) - XPred)'));
end

CPred = CPred + noise;

end

