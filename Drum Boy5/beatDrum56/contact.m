function [d2xd,dxd,xd,d2xi,dxi,xi] = contact(i,iC,dxT,dxd,xd,d2xi,dxi,xi)
global T
% d2xd = (dxT-dxi)/(iC*T);
% dxd = dxd + d2xd*T;
% xd = xd + dxd*T + .5*d2xd*T^2;
% NOTE: The above equation satisfies only the target velocity 
% but we want to make the equation satisfying not only the velocity 
% but also the position for z and theta. Therefore..
d2xd = 0*dxd;
for k = 1:length(xd)
    if ismember(k,[3 5])    % (z, theta)

        X = coeffB3((iC-i+1)*T,dxT(k),xi(k),dxd(k),xd(k));
        [d2xd(k),dxd(k),xd(k)] = pathGen(1*T,(iC-i+1)*T,X);
        
    else    % (x, y, phi)

        xd(k) = xd(k) + dxd(k)*T + .5*d2xd(k)*T^2;
        
    end
end
%% update initials
if i == iC
    d2xi = d2xd;
    dxi = dxd;
    xi = xd;
end