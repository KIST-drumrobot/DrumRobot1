function [phi,theta] = R2phiThetaHead(R)

% Rxz
% phi = atan2(-R(1,2),R(1,1));
% theta = atan2(-R(2,3),R(3,3));

% Rzx
phi = atan2(R(2,1),R(1,1));
theta = atan2(R(3,2),R(3,3));