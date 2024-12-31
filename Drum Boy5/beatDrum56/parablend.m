function [d2xd,dxd,xd] = parablend(i,iDuration,s,dxd,xd,dxT,xT,dxi,xi)
global T
% iDuration = iDuration-1;
di1 = floor(s*iDuration);
diT = iDuration-di1;
i1T = iDuration-1/2*(di1+diT);
dx1T = ((xT-1/2*diT*T*dxT)-(xi+1/2*di1*T*dxi))/(i1T*T);

% Parabolic blend
if i <= di1
    d2xd = (dx1T - dxi)/(di1*T);
elseif i > iDuration-diT
    d2xd = (dxT - dx1T)/(diT*T);
else
    d2xd = 0*dxd;
end
dxd = dxd + d2xd*T;
xd = xd + dxd*T + 1/2*d2xd*T^2;