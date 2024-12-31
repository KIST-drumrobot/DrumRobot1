function x = JwR(q)
global n xhat yhat zhat
x = zeros(3,n);

x(:,1) = zhat;
x(:,2) = Rz(q(1))*xhat;
x(:,3) = Rz(q(1))*Rx(q(2))*yhat;
x(:,4) = Rz(q(1))*Rx(q(2))*Ry(q(3))*zhat;
x(:,5) = Rz(q(1))*Rx(q(2))*Ry(q(3))*Rz(q(4))*xhat;
x(:,6) = Rz(q(1))*Rx(q(2))*Ry(q(3))*Rz(q(4))*Rx(q(5))*zhat;
x(:,7) = Rz(q(1))*Rx(q(2))*Ry(q(3))*Rz(q(4))*Rx(q(5))*Rz(q(6))*Rx(pi/6)*yhat;
x(:,8) = Rz(q(1))*Rx(q(2))*Ry(q(3))*Rz(q(4))*Rx(q(5))*Rz(q(6))*Rx(pi/6)*Ry(q(7))*xhat;