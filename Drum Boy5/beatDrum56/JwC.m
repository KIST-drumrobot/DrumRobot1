function x = JwC(q)
global n xhat yhat zhat
x = zeros(3,n);

x(:,1) = zhat;
x(:,16) = Rz(q(1))*Rz(-pi/4)*xhat;
x(:,17) = Rz(q(1))*Rz(-pi/4)*Rx(q(16))*zhat;