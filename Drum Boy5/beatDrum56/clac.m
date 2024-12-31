function [d2q,dq,q] = clac(Kd,Kp,d2xd,de,e,dq,q,a,d2w)
global T
I = eye(length(q)); % Identity matrix

% Weight matrix
W = M(q);
% W = M(q)'*M(q);
% W = (Jh(q)'*Jh(q))
% x = Jh(q)'*Jh(q)
% rank(x)

% Psuedo inverse of Jacobian
Jp = W^-1*J(q)'*(J(q)*W^-1*J(q)')^-1;

% Closed-loop resolved-acceleration control
d2q = Jp*(d2xd + Kd*de + Kp*e - dJdt(q,dq)*dq); + a*(I - Jp*J(q))*d2w;
% d2q = Jp*(d2xd + Kd*de + Kp*e - dJdt(q,dq)*dq) - ...
%     (I - Jp*J(q))*W*Jh(q)'*dJhdt(q,dq)*dq;
% d2q = Jp*(d2xd + Kd*de + Kp*e - dJdt(q,dq)*dq);
dq = dq + d2q*T;
q = q + dq*T + 1/2*d2q*T^2;