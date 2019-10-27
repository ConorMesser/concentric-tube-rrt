function g=variable_expmap(theta,Gammahat)

if theta==0
    g           =diag([1 1 1 1])+Gammahat;
else
    g           =diag([1 1 1 1])+Gammahat+...
                 ((1-cos(theta))/(theta^2))*Gammahat^2+...
                 ((theta-sin(theta))/(theta^3))*Gammahat^3;
end

% eof