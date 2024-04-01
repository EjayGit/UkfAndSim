function [ CovYZ ] = covPM( Wc0, Wi, sigmas1, XPred1, sigmas2, XPred2 )

CovYZ = Wc0 * ((sigmas1(:,1) - XPred1)*(sigmas2(:,1) - XPred2)');

for i = 2 : 1 : size(sigmas1,2)
    CovYZ = CovYZ + ( Wi * ((sigmas1(:,i) - XPred1)*(sigmas2(:,i) - XPred2)'));
end

end

