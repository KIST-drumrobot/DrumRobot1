function [d2xd,dxd,xd] = constAcc(iSwing,dxT,xT,dxi,xi,dxd,xd,s)
global T

if s == "up"
    d2xd = -dxi/(iSwing*T);
elseif s == "down"
%     d2xd = 2/(iSwing*T)^2*(xT-xi-dxi*(iSwing*T));
    d2xd = dxT/(iSwing*T);
end
dxd = dxd + d2xd*T;
xd = xd + dxd*T + 1/2*d2xd*T^2;