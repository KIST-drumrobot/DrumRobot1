clear
close all
clc

syms l [1 5] positive real;
syms t q1(t) q2(t) q3(t) q4(t) q5(t) q6(t) q7(t);
syms dq [1 7] real;
syms d2q [1 7] real;

r1 = [l1 0 0]';
r2 = [0 0 -l2]';
r3 = [0 0 -l3]';
r4 = [0 0 -l4]';
r5 = [0 l5 0]';

xhat = [1;0;0];
yhat = [0;1;0];
zhat = [0;0;1];


%% Jacobian setting
m = 3;
n = 7;      % Degrees of joint (Don't change)

% Velocity
re = Rx(q1)*Ry(q2)*Rz(q3)*r2;
rw = re + Rx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*r3;
r = rw + Rx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*Rz(q5)*Rx(q6)*Rz(q7)*(r4 + r5);
dr = diff(rw,t);
% dr = subs(dr,{diff(q1(t), t),diff(q2(t), t),diff(q3(t), t),diff(q4(t), t),diff(q5(t), t),diff(q6(t), t),diff(q7(t), t)},{dq1,dq2,dq3,dq4,dq5,dq6,dq7});
% dr = simplify(dr);

% Acceleration
d2r = diff(dr,t);
d2r = subs(d2r,{diff(q1(t), t, t),diff(q2(t), t, t),diff(q3(t), t, t),diff(q4(t), t, t),diff(q5(t), t, t),diff(q6(t), t, t),diff(q7(t), t, t),...
    diff(q1(t), t),diff(q2(t), t),diff(q3(t), t),diff(q4(t), t),diff(q5(t), t),diff(q6(t), t),diff(q7(t), t)},{d2q1,d2q2,d2q3,d2q4,d2q5,d2q6,d2q7,dq1,dq2,dq3,dq4,dq5,dq6,dq7});
d2r = simplify(d2r);

% Angular velocity
w1 = xhat*dq1;
w2 = Rx(q1)*yhat*dq2;
w3 = Rx(q1)*Ry(q2)*zhat*dq3;
w4 = Rx(q1)*Ry(q2)*Rz(q3)*xhat*dq4;
w5 = Rx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*zhat*dq5;
w6 = Rx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*Rz(q5)*xhat*dq6;
w7 = Rx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*Rz(q5)*Rx(q6)*zhat*dq7;

wU = w1 + w2 + w3;
wL = wU + w4;
wH = wL + w5 + w6 + w7;

% Angular acceleration
dw1 = xhat*d2q1;
dw2 = dRx(q1)*yhat*dq1*dq2 + Rx(q1)*yhat*d2q2;
dw3 = dRx(q1)*Ry(q2)*zhat*dq1*dq3 + Rx(q1)*dRy(q2)*zhat*dq2*dq3 + Rx(q1)*Ry(q2)*zhat*d2q3;
dw4 = dRx(q1)*Ry(q2)*Rz(q3)*xhat*dq1*dq4 + Rx(q1)*dRy(q2)*Rz(q3)*xhat*dq2*dq4 + Rx(q1)*Ry(q2)*dRz(q3)*xhat*dq3*dq4 + Rx(q1)*Ry(q2)*Rz(q3)*xhat*d2q4;
dw5 = dRx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*zhat*dq1*dq5 + Rx(q1)*dRy(q2)*Rz(q3)*Rx(q4)*zhat*dq2*dq5 + Rx(q1)*Ry(q2)*dRz(q3)*Rx(q4)*zhat*dq3*dq5 + Rx(q1)*Ry(q2)*Rz(q3)*dRx(q4)*zhat*dq4*dq5 + Rx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*zhat*d2q5;
dw6 = dRx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*Rz(q5)*xhat*dq1*dq6 + Rx(q1)*dRy(q2)*Rz(q3)*Rx(q4)*Rz(q5)*xhat*dq2*dq6 + Rx(q1)*Ry(q2)*dRz(q3)*Rx(q4)*Rz(q5)*xhat*dq3*dq6 + Rx(q1)*Ry(q2)*Rz(q3)*dRx(q4)*Rz(q5)*xhat*dq4*dq6 + Rx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*dRz(q5)*xhat*dq5*dq6 + Rx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*Rz(q5)*xhat*d2q6;
dw7 = dRx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*Rz(q5)*Rx(q6)*zhat*dq1*dq7 + Rx(q1)*dRy(q2)*Rz(q3)*Rx(q4)*Rz(q5)*Rx(q6)*zhat*dq2*dq7 + Rx(q1)*Ry(q2)*dRz(q3)*Rx(q4)*Rz(q5)*Rx(q6)*zhat*dq3*dq7 + Rx(q1)*Ry(q2)*Rz(q3)*dRx(q4)*Rz(q5)*Rx(q6)*zhat*dq4*dq7 + Rx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*dRz(q5)*Rx(q6)*zhat*dq5*dq7 + Rx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*Rz(q5)*dRx(q6)*zhat*dq6*dq7 + Rx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*Rz(q5)*Rx(q6)*zhat*d2q7;

dwU = dw1 + dw2 + dw3;
dwL = dwU + dw4;
dwH = dwL + dw5 + dw6 + dw7;

% a = cross(dwU,re) + cross(wU,cross(wU,re));
a = cross(dwU,re) + cross(wU,cross(wU,re)) + cross(dwL,rw-re) + cross(wL,cross(wL,rw-re));

% v = cross(wU,re) + cross(wL,rw-re);% + cross(wW,r-rW);
% v = simplify(v);

% This should be zero
simplify(d2r - a)


%% Functions
function r = Rx(q)
    r = [1 0 0;0 cos(q) -sin(q);0 sin(q) cos(q)];
end

function r = Ry(q)
    r = [cos(q) 0 sin(q);0 1 0;-sin(q) 0 cos(q)];
end

function r = Rz(q)
    r = [cos(q) -sin(q) 0;sin(q) cos(q) 0;0 0 1];
end

function r = dRx(q)
    r = [0 0 0;0 -sin(q) -cos(q);0 cos(q) -sin(q)];
end

function r = dRy(q)
    r = [-sin(q) 0 cos(q);0 0 0;-cos(q) 0 -sin(q)];
end

function r = dRz(q)
    r = [-sin(q) -cos(q) 0;cos(q) -sin(q) 0;0 0 0];
end