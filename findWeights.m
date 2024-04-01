function [ Wm0, Wc0, Wi ] = findWeights( ukf )

Wm0 = ukf.lambda / (ukf.dim + ukf.lambda);

Wc0 = Wm0 + ( 1 - (ukf.alpha^2) + ukf.beta );

Wi = 1 / (2 * (ukf.dim + ukf.lambda));

end

