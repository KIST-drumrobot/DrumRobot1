clear
close all
clc

syms l [1 5] positive real;
syms t q1(t) q2(t) q3(t) q4(t) q5(t) q6(t) q7(t);
syms dq [1 7] real;

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

rE = Rx(q1)*Ry(q2)*Rz(q3)*r2;
rW = rE + Rx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*r3;
r = rW + Rx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*Rz(q5)*Rx(q6)*Rz(q7)*(r4 + r5);
dr = diff(rW,t);
dr = subs(dr,{diff(q1(t), t),diff(q2(t), t),diff(q3(t), t),diff(q4(t), t),diff(q5(t), t),diff(q6(t), t),diff(q7(t), t)},{dq1,dq2,dq3,dq4,dq5,dq6,dq7});
dr = simplify(dr);

w1 = xhat*dq1;
w2 = Rx(q1)*yhat*dq2;
w3 = Rx(q1)*Ry(q2)*zhat*dq3;
w4 = Rx(q1)*Ry(q2)*Rz(q3)*xhat*dq4;
w5 = Rx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*zhat*dq5;
w6 = Rx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*Rz(q5)*xhat*dq6;
w7 = Rx(q1)*Ry(q2)*Rz(q3)*Rx(q4)*Rz(q5)*Rx(q6)*zhat*dq7;

wS = w1 + w2 + w3;
wE = wS + w4;
wW = wE + w5 + w6 + w7;

v = cross(wS,rE) + cross(wE,rW-rE);% + cross(wW,r-rW);
v = simplify(v);

% This should be zero
simplify(dr - v)


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