function [cnt,d2xd,dxd,xd,dxi,xi,xT,X] = regStrike(cnt,d2xd,dxd,xd,dxi,xi,xT,X,i,iN,iB,iQ,iC,n,a,q,h)
global T
% NOTE: 'i' should start from '1'
if iN > iB
    % Style #1. Critical-damped
    iOffset = iN-(iB-iC/2);
    z = sqrt(1 - 1/((2/iC*(iN - iB) + 1)^2));   

elseif iN == iB
    z = iB/iQ*0.1; % Under-damped (z < 0.1)
    iOffset = floor(iC/(2*sqrt(1 - z^2)));
    iB = iN-(iOffset-iC/2);
end

if i == 1
    dxi = dxd;
    xi = xd;
    
    if length(xd) > 3
        % Wrist initial lifting speed
%         if n == 6 || n == 7 % For cymbals
%             kw = 0.010;
%         else
            kw = 0.005;   % Default
%         end
        dwi = kw*a;
    
        % Cubic Bezier curve
        X(3,1) = xd(3);
        X(3,2) = X(3,1) + dxd(3)*iOffset*T/3;
        X(3,3) = 2*X(3,2) - X(3,1) + d2xd(3)*iOffset*T/6;
        X(3,4) = X(3,3) + dwi*iOffset*T/3;
    end
end


%% Trajectory generation
if i <= iOffset
    % 1) Contact - second half
    [d2xd,dxd,xd] = vi(i*T,iC*T,z,dxi,xi,xT);

    % ----- Update ver.2 ----- %
    if length(xd) > 3
        % Wrist postion trajectory
        [d2xd(3),dxd(3),xd(3)] = pathGen(i*T,iOffset*T,X(3,1:4));
    end
else
    % 2) Strike
    [cnt,d2xd,dxd,xd,dxi,xi,xT,X] = baseStrike(cnt,d2xd,dxd,xd,dxi,xi,xT,X,i-iOffset,iB,iC,n,a,q,h);
end