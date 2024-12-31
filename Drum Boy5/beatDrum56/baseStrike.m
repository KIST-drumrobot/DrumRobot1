function [cnt,d2xd,dxd,xd,dxi,xi,xT,X] = baseStrike(cnt,d2xd,dxd,xd,dxi,xi,xT,X,i,iB,iC,n,a,q,h)
global T
% NOTE: 'i' should start from '1'

if i > 0
    iSwing = iB-iC;
    if i <= iSwing
        % 1) Strike
        if i == 1
            [d2xT,dxT,xT] = targetPos(n,a,q,h);
            
            % Cubic Bezier curve
%             X(:,1) = xd;
%             X(:,4) = xT;
%             X(:,2) = X(:,1) + dxd*iSwing*T/3;
%             X(:,3) = X(:,4) - dxT*iSwing*T/3;
            
            % 5th-order Bezier curve
            X(:,1) = xd;
            X(:,6) = xT;
            X(:,2) = X(:,1) + dxd*iSwing*T/5;
            X(:,5) = X(:,6) - dxT*iSwing*T/5;
            X(:,3) = 2*X(:,2) - X(:,1) + d2xd*iSwing*T/20;
            X(:,4) = 2*X(:,5) - X(:,6) + d2xT*iSwing*T/20;
        end
        [d2xd,dxd,xd] = pathGen(i*T,iSwing*T,X);
        
        % ----- Update ver.1 ----- %
%         if length(xd) > 3 
%             [d2xd(3),dxd(3),xd(3)] = pathGen4wristZdir(i*T,iSwing*T,X(3,1),X(3,6),n,a);
%         end
        % NOTICE: Wrist z-direction trajectory smoothed, i.e., acceleration
        % and velocity are zeros at the initial and last moment.

        if i == iSwing
            % Save initial values for contact
            dxi = dxd;
            xi = xd;
        end
    else
        % 2) Contact - First half
        [d2xd,dxd,xd] = vi((i-iSwing)*T,iC*T,0,dxi,xi,xi);

        if i == iSwing+iC/2
            cnt = cnt + 1;
        end
    end
end