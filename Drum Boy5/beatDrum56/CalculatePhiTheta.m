clear
close all
clc

syms q [1 8] real;
syms dq [1 8] real;
syms phi theta dphi dtheta real;

xhat = [1;0;0];
yhat = [0;1;0];
zhat = [0;0;1];

% Angular velocity
% R = Rz(phi)*Rx(theta);
% dR = dRz(phi)*Rx(theta)*dphi + Rz(phi)*dRx(theta)*dtheta;
% wx = dR*R';

R = Rz(phi)*Ry(theta);
dR = dRz(phi)*Ry(theta)*dphi + Rz(phi)*dRy(theta)*dtheta;
wx = dR*R';

simplify(wx)


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