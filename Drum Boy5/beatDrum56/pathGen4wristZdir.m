function [d2xdw,dxdw,xdw] = pathGen4wristZdir(t,td,xdw,xTw,n,a)

if n == 6 || n == 7
    kw = .02;
else
    kw = .01;
end

X = zeros(1,7);
X(:,1) = xdw;
X(:,7) = xTw;
X(:,2) = X(:,1);
X(:,6) = X(:,7);
X(:,3) = 2*X(:,2) - X(:,1);
X(:,5) = 2*X(:,6) - X(:,7);
X(:,4) = max(xTw,xdw) + kw*td*a;

xdw = B(t,td,X);
dxdw = dB(t,td,X);
d2xdw = d2B(t,td,X);