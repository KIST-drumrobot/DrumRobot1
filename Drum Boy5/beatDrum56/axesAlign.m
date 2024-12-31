function dw = axesAlign(q)
global xhat yhat
% Cost function to be maximized: the maximum value is one.
% f = 1/2*((R5(q)*xhat)'*(R8(q)*xhat) + (R12(q)*yhat)'*(R15(q)*yhat));
k0 = 100;
dw = 1/2*k0*(...
    (m3times(dR5(q),xhat))'*(R8(q)*xhat) + (m3times(dR8(q),xhat))'*(R5(q)*xhat) + ...
    (m3times(dR12(q),yhat))'*(R15(q)*yhat) + (m3times(dR15(q),yhat))'*(R12(q)*yhat));