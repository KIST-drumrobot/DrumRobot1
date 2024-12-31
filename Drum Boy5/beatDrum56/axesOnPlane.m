function dw = axesOnPlane(q)
global xhat yhat zhat
% Cost function to be maximized: the maximum value is one.
% f = 1/2*((R7(q)*xhat)'*P*(R7(q)*xhat) + (R14(q)*yhat)'*P*(R14(q)*yhat));
P = [xhat yhat 0*zhat];
k0 = 10;
dw = 1/2*k0*(...
    (m3times(dR7(q),xhat))'*P*(R7(q)*xhat) + (m3times(dR7(q),xhat))'*P*(R7(q)*xhat) + ...
    (m3times(dR14(q),yhat))'*P*(R14(q)*yhat) + (m3times(dR14(q),yhat))'*P*(R14(q)*yhat));