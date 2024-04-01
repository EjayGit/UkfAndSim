function [ y, Y, P, Y1 ] = ut( ukf, X, Wm, Wc, Noise )

n = size(Noise,1);
L = size(X,2);
y = zeros(n,1);
Y = zeros(n,L);
for k = 1 : L                   
    Y(:,k) = f(X(:,k));       
    y = y + Wm(k) * Y(:,k);       
end
Y1 = Y - y(:, ones(1,L));
P = Y1 * diag(Wc) * Y1' + Noise;   

end