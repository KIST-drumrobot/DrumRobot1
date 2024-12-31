function x = JwL(q)
global n xhat yhat zhat
x = zeros(3,n);

x(:,1) = zhat;
x(:,9) = Rz(q(1))*xhat;
x(:,10) = Rz(q(1))*Ry(q(9))*xhat;
x(:,11) = Rz(q(1))*Ry(q(9))*Rx(q(10))*zhat;
x(:,12) = Rz(q(1))*Ry(q(9))*Rx(q(10))*Rz(q(11))*yhat;
x(:,13) = Rz(q(1))*Ry(q(9))*Rx(q(10))*Rz(q(11))*Ry(q(12))*zhat;
x(:,14) = Rz(q(1))*Ry(q(9))*Rx(q(10))*Rz(q(11))*Ry(q(12))*Rz(q(13))*Ry(-pi/6)*xhat;
x(:,15) = Rz(q(1))*Ry(q(9))*Rx(q(10))*Rz(q(11))*Ry(q(12))*Rz(q(13))*Ry(-pi/6)*Rx(q(14))*yhat;