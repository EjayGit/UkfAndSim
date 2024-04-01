function [ XPred, CPred ] = UKFilter( ukf, meas )

% Prediction

[ sigmaProcX ] = findSigmas( ukf, ukf.XPred, ukf.CPred );

[ sigmaProcY ] = runFunc( sigmaProcX, ukf.procFunc );

[ Wm0, Wc0, Wi ] = findWeights( ukf );

[ XPredY ] = newMean( Wm0, Wi, sigmaProcY );

[ CPredY ] = newCov( Wc0, Wi, sigmaProcY, XPredY, ukf.Q );

% Correction

sigmaMeasY = findSigmas( ukf, XPredY, CPredY );

sigmaMeasZ = runFunc( sigmaMeasY, ukf.measFunc );

[ XPredZ ] = newMean( Wm0, Wi, sigmaMeasZ );

[ measCov ] = newCov( Wc0, Wi, sigmaMeasZ, XPredZ, ukf.R );

covYZ = covPM( Wc0, Wi, sigmaProcY, XPredY, sigmaMeasZ, XPredZ );

K = covYZ * inv(measCov);

XPred = XPredY + K*(meas - XPredZ);

CPred = CPredY - ( K * measCov * K' );

end

