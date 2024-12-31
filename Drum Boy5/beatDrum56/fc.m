function [d2q,dq,q] = fc(dxd,dq,dq1,q)
global T

W = jointCon(dq,q,'f');

dq = W*dxd;
q = q + dq*T;
d2q = (dq - dq1)/T;