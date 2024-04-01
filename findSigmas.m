function [ sigmas ] = findSigmas( ukf, XPred, CPred )

% Creates a matrix of sigma points of size(L, 2L + 1).

rootLG = sqrt(ukf.dim + ukf.lambda);
rootSigma = chol(CPred)';

sigmas = zeros(ukf.dim, (2 * ukf.dim));

for i = 1 : 1 : (2 * ukf.dim)
    if i <= ukf.dim
        sigmas(:,i) = XPred + (rootLG * rootSigma(:,i));
    elseif i > ukf.dim
        sigmas(:,i) = XPred - (rootLG * rootSigma(:,(i - ukf.dim)));
    end
end

sigmas = cat(2, XPred, sigmas);

end

