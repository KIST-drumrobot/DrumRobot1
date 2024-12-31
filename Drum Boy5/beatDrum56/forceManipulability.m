function dw = forceManipulability(q)
global n xhat yhat zhat

% urR = [0;0;1];
% urL = [0;0;1];
urR = R6(q)*zhat;
urL = R13(q)*zhat;
% uwR = Rz(phi(1))*xhat;
% uwL = Rz(phi(2))*yhat;
uwR = R7(q)*xhat;
uwL = R14(q)*yhat;
u = [urR;urL;uwR;uwL;0;0;0;0];
u = u/norm(u);  % Unit force direction vector
w = (u'*(J(q)*J(q)')*u)^(-1/2); % Force transformation ratio

k0 = .1;
dw = zeros(n,1);
for i = 1:n
    dw(i) = -1/2*k0*w^3*u'*(dJ(q,i)*J(q)' + J(q)*dJ(q,i)')*u;
end