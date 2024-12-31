function [d2xd,dxd,xd] = parablendrcsv(iDuration,di1,dxT,xT,dxd,xd)
global T
diT = iDuration-di1;
i1T = iDuration-1/2*(di1+diT);
dx1T = ((xT-1/2*diT*T*dxT)-(xd+1/2*di1*T*dxd))/(i1T*T);

% Parabolic blend
d2xd = (dx1T - dxd)/(di1*T);
dxd = dxd + d2xd*T;
xd = xd + dxd*T + 1/2*d2xd*T^2;