function [d2xd,dxd,xd] = pathGenNoAccBnd(t,td,dxi,xi,dxT,xT)

X = zeros(length(xi),6);
X(:,1) = xi;
X(:,6) = xT;
X(:,2) = X(:,1) + dxi*td/5;
X(:,5) = X(:,6) - dxT*td/5;
X(:,3) = 2*X(:,2) - X(:,1);
X(:,4) = 2*X(:,5) - X(:,6);

[d2xd,dxd,xd] = pathGen(t,td,X);