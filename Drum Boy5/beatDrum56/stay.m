function [d2xd,dxd,xd,d2xi,dxi,xi] = stay(i,iend,iC,dxT,dxd,xd,d2xi,dxi,xi,s)
global T l
d2xd = -10*abs(xd-xi).*dxd;
for k = [3 5]
    if i <= iend-iC
        j = round((k-1)/2);
            
        dS = .01*[1;s*8/l]; % desired stay displacement
        xS = xi(k) + dS(j); % desired stay position
        
        iS = min(floor(2*(xS-xi(k))/(dxi(k)*T)),iend-iC);
        if i <= iS
            d2xd(k) = -dxi(k)/(iS*T);
        end
    else
        if i == iend-iC+1
            dxi(k) = dxd(k);
        end
        d2xd(k) = (dxT(k)-dxi(k))/(iC*T);    % boost-up for lift
    end
end
dxd = dxd + d2xd*T;
xd = xd + dxd*T + .5*d2xd*T^2;
%% Save last for next phase
if i == iend
    d2xi = d2xd;
    dxi = dxd;
    xi = xd;
end