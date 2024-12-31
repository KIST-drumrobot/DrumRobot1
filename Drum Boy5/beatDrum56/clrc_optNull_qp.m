function [d2q,dq,q] = clrc_optNull_qp(Kp,dxd,e,dq,q,alpha)
global T dqlim
n = length(q);
dq1 = dq;

% Joint constraints
W = jointCon(dq,q,'b');

% Weighted Jacobian and Jacobian derivative
JW = J(q)*W^(1/2);

% Psuedo inverse of Jacobian
Jp = M(q)^-1*JW'*(JW*M(q)^-1*JW')^-1;

% Closed-loop resolved-rate control
dq = W^(1/2)*Jp*(dxd + Kp*e);

% Quadratic programming
c = dq - dq1;
D = alpha*W^(1/2)*(eye(n) - Jp*JW)*W^(1/2);

H = 1/T^2*(D'*M(q)*D);
H = (H+H')/2;
f = 1/T^2*D'*M(q)*c;

% H = 1/T^2*(D'*D);
% f = 1/T^2*D'*c;

A1 = D;
A2 = -D;
b1 = dqlim(1:n) - dq;
b2 = dqlim(1:n) + dq;
A = [A1;A2];
b = [b1;b2];
Aeq = [];
beq = [];
lb = [];
ub = [];

options = optimoptions('quadprog');
% options = optimoptions('quadprog','Display','none');
dw = quadprog(H,f,A,b,Aeq,beq,lb,ub,[],options);
dq = dq + D*0.99*dw;
d2q = (dq - dq1)/T;
q = q + dq*T;