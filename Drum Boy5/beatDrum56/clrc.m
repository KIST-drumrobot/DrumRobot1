function [d2q,dq,q] = clrc(Kp,dxd,e,dq,q,alpha,dw)
global T
dq1 = dq;

% Joint constraints
W = jointCon(dq,q,'b');

% Weighted Jacobian and Jacobian derivative
JW = J(q)*W^(1/2);

% Psuedo inverse of Jacobian
Jp = M(q)^-1*JW'*(JW*M(q)^-1*JW')^-1;
% 
% S = JW'*(JW*JW')^-1*(eye(16)-Lambda);
% S = JW'*(JW*JW')^-1*(eye(16)-Lambda)*JW;
% S = (JW'*JW)\JW'*(eye(16)-Lambda)*JW;
% S = JW'*(eye(16)-Lambda)*JW;
% 
% Jp = JW'*Lambda^2*( Lambda*JW*JW'*Lambda + S'*M(q(:,k))*S )^-1;
% Jp = ( JW'*Lambda^2*JW + S'*M(q(:,k))*S ) \ (JW'*Lambda^2);
% Jp = ( JW'*Lambda*JW + M(q(1:17,k)) ) \ JW'*Lambda;
% 
% Jp = (JW'*JW + 0.05*(W^(1/2))'*M(q)*W^(1/2))\JW';

% Closed-loop resolved-rate control
dq = W^(1/2)*Jp*(dxd + Kp*e) + alpha*W^(1/2)*(eye(17) - Jp*JW)*W^(1/2)*dw;
d2q = (dq - dq1)/T;
q = q + dq*T;