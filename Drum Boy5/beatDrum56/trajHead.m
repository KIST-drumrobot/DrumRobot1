function [d2x,dx,x] = trajHead(dy,y,q,k,iQ,flR,thetaT)
global T
global rbR_hat ruR_hat rlR_hat rhR_hat rn_hat rc_hat ...
    rbL_hat ruL_hat rlL_hat rhL_hat
% ----- Follow the target(right stick) ----- %
rR = R1(q)*rbR_hat + R4(q)*ruR_hat + R6(q)*rlR_hat + R8(q)*rhR_hat;
% rR = R1(q)*rbL_hat + R11(q)*ruL_hat + R13(q)*rlL_hat + R15(q)*rhL_hat;
% ------- Bad Guy -------- %
% rR = [-1;3;-1]; % for male(turn left)
% rR = [2;-1;-1]; % for female(turn right)
% ------------------------ %
rH = R1(q)*rn_hat + R17(q)*rc_hat;
r = rR - rH;
% Desired frame (rotation matrix)
ry = r/norm(r);
rx = cross(rR,rH);
rx = rx/norm(rx);
rz = cross(rx,ry);
R = [rx ry rz];
% Transformation from frame to Euler angles
[phi,theta] = R2phiThetaHead(R);
if ~flR
    theta = .3*theta + q(18);   % Nod to bass
else
    theta = 1.5*theta + pi/180*35 - thetaT; % Nod to stick
end
theta = min(theta,pi/180*-2);
theta = max(theta,pi/180*-35);
% Saturation
% phi = saturation(phi,-pi/4,pi/180*20);
% theta = saturation(theta,pi/180*-75,pi/180*15);
xd = [phi;theta];
% Low-pass filtering
w = 2*pi/(2*iQ*T);
x = LF1(T,w,xd,y);
% Initial smoothing
a = sigmoid(k*T,1);
x = a*x + (1 - a)*y;

dx = (x - y)/T;
d2x = (dx - dy)/T;