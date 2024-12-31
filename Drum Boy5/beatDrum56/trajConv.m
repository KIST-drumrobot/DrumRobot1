function [d2x,dx,x] = trajConv(d2y,dy,y,h)

d2x = zeros(6,1);
dx = zeros(6,1);
x = zeros(7,1);

d2x(1:3) = d2y(1:3);
dx(1:3) = dy(1:3);
x(1:3) = y(1:3);

phi = y(4);
theta = y(5);
dphi = dy(4);
dtheta = dy(5);
d2phi = d2y(4);
d2theta = d2y(5);

Rd = RS(phi,theta,h);
dRd = dRS(dphi,dtheta,phi,theta,h);
d2Rd = d2RS(d2phi,d2theta,dphi,dtheta,phi,theta,h);

x(4:7) = R2quat(Rd);
dx(4:6) = R2omega(dRd,Rd);
d2x(4:6) = R2domega(d2Rd,dRd,Rd);