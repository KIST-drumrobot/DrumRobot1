function [d2xd,dxd,xd,d2xi,dxi,xi] = swing(i,iSwing,iL,dxT,xT,d2xd,dxd,xd,d2xi,dxi,xi,fl)
global T
% NOTE: 'i' starts from '1'
for k = 1:length(xi)
    if ismember(k,[3 5])
        j = round((k-1)/2);

        %% [phase #1] lift
        if i <= iL(j)
    
            d2xd(k) = -dxi(k)/(iL(j)*T);
    
        %% [phase #2] hit or float
        else
    
            if ~fl      % hit
                
                xP = xi(k)+.5*dxi(k)*(iL(j)*T); % position x at apex
                dxT(k) = (xT(k)-xP)/(.5*(iSwing-iL(j))*T); % target hit velocity
    
%                 X = coeffB5((iSwing-iL(j))*T,0,dxT(k),xT(k),-dxi(k)/(iL(j)*T),0,xP);
                X = coeffB5((iSwing-iL(j))*T,0,dxT(k),xT(k),0,0,xP);
                d2xd(k) = d2B((i-iL(j))*T,(iSwing-iL(j))*T,X);
    
            else        % float
                iF = iL(j)+floor(.3*(iSwing-iL(j))); % transition point
                if i <= iF
    
                    d2xd(k) = (xT(k)-(xi(k)+.5*dxi(k)*(iL(j)*T)))/...
                        (.5*((iF-iL(j))*T)*((iSwing-iL(j))*T));
    
                else
    
                    d2xd(k) = ((xi(k)+.5*dxi(k)*(iL(j)*T))-xT(k))/...
                        (.5*((iSwing-iF)*T)*((iSwing-iL(j))*T));
    
                end
            end
    
        end

        dxd(k) = dxd(k) + d2xd(k)*T;
        xd(k) = xd(k) + dxd(k)*T + .5*d2xd(k)*T^2;

    else

        X = coeffB5((iSwing-i+1)*T,0,dxT(k),xT(k),d2xd(k),dxd(k),xd(k));
        [d2xd(k),dxd(k),xd(k)] = pathGen(1*T,(iSwing-i+1)*T,X);

    end
end

%% update initials
if i == iSwing
    d2xi = d2xd;
    dxi = dxd;
    xi = xd;
end