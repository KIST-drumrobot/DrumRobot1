function [xT,dxT,dxil,il,s] = targetVal(status,iSwing,iN1,iB1,iQ,iC,xd,xi,q,dmT,n,n1,n0,a,fl,h)
global T l
%% target position : xT = [x;y;z;phi;theta]
[xT,f,s] = targetPos(iSwing,iQ,xd,q,dmT,n,n0,h);
[xT1,f1,s1] = targetPos(iSwing,iQ,xd,q,dmT,n1,n,h);
% NOTE: f = strength (max.f = 1)
%% lift time
r = .60;            % lift phase wrt swing time
delta = .15;        % apex time difference wrt swing time
z = .05;            % base wrist apex height
% z = .1;   % exaggerating
if iSwing >= iQ-iC
    r = .70;
    z = 2*z;
end
% g = .48/z;          % speed ratio of stick tip to wrist joint
g = .4/z;

% lift time length for (z,theta)
il = floor(iSwing*[r r+delta]);

% lift time correction (float)
if fl
    z = .05;
    g = .4/z;
    p = .6;
    g = g*p;
    il = floor(il*p);
end
%% initial lift velocity
d = rem(a,1);   % lift damping
hz0 = z*(1-d)*f;

% swing time compensation
iSwing0 = 375;  % reference swing time length
sSwing = .0003;    % sSwing ~ 0 
m = 1 - sSwing*(iSwing0 - iSwing);
hz0 = hz0*m;   % swing time compensation

% apex height and initial lift velocity
L = length(xi);
dxil = zeros(L,1);
dxT = zeros(L,1);

alpha = [1 s];
beta = [1 g/l];
for k = 1:L

    if ismember(k,[3 5])    % (z,theta)

        j = round((k-1)/2);

        ha = alpha(j)*(beta(j)*hz0 + max(0,alpha(j)*(xT(k)-xi(k))));

        dxil(k) = ha/(.5*il(j)*T);
        if strcmp(status,"stay")
            dxil(k) = ha/(.5*(il(j)+iC)*T);
            % NOTE: ha = .5*dxilc*(iC*T) + .5*dxilc*(iL*T)
        end

    else    % (x,y,phi)

        dxil(k) = (xT(k)-xi(k))/(iSwing*T);
        if fl
            dxil(k) = (xT(k)-xi(k))/(.5*iSwing*T);
        end
        if strcmp(status,"contact-stay")
            dxil(k) = 0;
        end

%         if ~(iN1 > iB1 || rem(n,10) == rem(n1,10) || rem(n,10) == rem(n0,10))
%             if (xT(k)-xi(k))*(xT1(k)-xT(k)) > 0 
%                 dxT(k) = (xT1(k)-xT(k))/((iB1-iC)*T);
%             end
%         end

        if ~(rem(n,10) == rem(n1,10) || rem(n,10) == rem(n0,10))
            if (xT(k)-xi(k))*(xT1(k)-xT(k)) > 0 
                dxT(k) = (xT1(k)-xT(k))/((iB1-iC)*T);
            end
        end

    end

end