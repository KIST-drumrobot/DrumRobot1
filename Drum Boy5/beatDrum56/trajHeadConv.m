function [d2x,dx,x] = trajHeadConv(d2y,dy,y)
phi = y(1);
theta = y(2);
dphi = dy(1);
dtheta = dy(2);
d2phi = d2y(1);
d2theta = d2y(2);

Rd = RS(phi,theta,"R");
dRd = dRS(dphi,dtheta,phi,theta,"R");
d2Rd = d2RS(d2phi,d2theta,dphi,dtheta,phi,theta,"R");

x = R2quat(Rd);
dx = R2omega(dRd,Rd);
d2x = R2domega(d2Rd,dRd,Rd);