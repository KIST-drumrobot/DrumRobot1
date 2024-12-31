function dw = minInertia(dq,q)
% global zhat
n = length(q);
X = J(q)*M(q)^-1*J(q)';

% End effector's inertia
Lambda = X^-1;

% Minimizing inertia direction
dx = J(q)*dq;
v = dx/norm(dx);

% Cost function
w = -v'*Lambda*v;

% Gradient
k0 = 100;
dw = zeros(n,1);
for i = 1:n
    dX = dJ(q,i)*M(q)^-1*J(q)' + J(q)*(-M(q)^-1*dM(q,i)*M(q)^-1)*J(q)' + J(q)*M(q)^-1*dJ(q,i)';
    dw(i) = -v'*(-Lambda*dX*Lambda)*v;
    dw(i) = k0*dw(i);
end