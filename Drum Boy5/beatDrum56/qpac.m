function [d2q,dq,q] = qpac(Kd,Kp,d2xd,de,e,dq,q)
global T dqlim qmin qmax
n = length(q);
I = eye(n);

dqu = dqlim(1:n);
qu = qmax(1:n);
ql = qmin(1:n);

H = M(q);
f = [];
A = [1/2*T^2*I;-1/2*T^2*I;T*I;-T*I];
b = [qu-q-dq*T;q+dq*T-ql;dqu-dq;dqu+dq];
Aeq = J(q);
beq = d2xd-dJdt(q,dq)*dq+Kd*de+Kp*e;
lb = [];
ub = [];

options = optimoptions('quadprog','Display','none');
d2q = quadprog(H,f,A,b,Aeq,beq,lb,ub,[],options);
q = q + dq*T + 1/2*d2q*T^2;
dq = dq + d2q*T;