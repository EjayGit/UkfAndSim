function [ SigmaY ] = runFunc( SigmaX, func )

SigmaY = zeros(size(func,1));

for i = 1 : 1 : size(SigmaX,2)
    SigmaY(:,i) = func * SigmaX(:,i);
end

end

