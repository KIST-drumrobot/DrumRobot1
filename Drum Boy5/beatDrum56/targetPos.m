function [xT,f,s] = targetPos(iB,iQ,xd,q,dmT,n,n0,h)
global l rbR_hat rbL_hat rhR_hat rhL_hat
P = [1 0 0;0 1 0];
if h == "R"
    s = 1;
    p = 1:3;
    rbhat = rbR_hat;
    rhhat = rhR_hat;
elseif h == "L"
    s = -1;
    p = 4:6;
    rbhat = rbL_hat;
    rhhat = rhL_hat;
end
f = 1;
nr = rem(n,10);             % Target drum(remainder)
nq = floor(n/10);           % Target drum deviation(quotient)
rT = dmT(p,min(nr,8));      % Target drum position
rTc = .5*(dmT(1:3,min(nr,8))+dmT(4:6,min(nr,8)));      % Center drum position
%% Target strike angle
switch nr
    % :::::::::: Snare (SN) :::::::::: %
    case 1
        thetaT = pi/180*-23;
        % Deviation
        switch nq
            case 1  % float: after hitting toms
                rT(3) = rT(3) - l*sin(thetaT);
                thetaT = thetaT+pi/180*10;
                rT(3) = rT(3) + l*sin(thetaT);
            case 8  % ghost note
                f = f*.35;
            case 7  % rim shot
                f = f*.8;
                if h == "L"
                    b = 0.17;
                    m = R2d(pi*-5/6)*(rT(1:2)-rTc(1:2));
                elseif h == "R"
                    b = 0.09;
                    m = R2d(pi*-1/12)*(rT(1:2)-rTc(1:2));
                end
                m = m/norm(m);
                rT(1:2) = rT(1:2) + b*m;
                thetaT = pi/180*-15;
            case 6  % ready for rim shot

            case 2  % offset float
                rT(3) = rT(3) - l*sin(thetaT);
                thetaT = pi/180*-13;
                rT(3) = rT(3) + l*sin(thetaT);

                b = 0.03;
                m = R2d(-s*pi/4)*(rT(1:2)-rTc(1:2));
                m = m/norm(m);
                rT(1:2) = rT(1:2) + b*m;
            case 4  % offset
                b = 0.05;
                m = R2d(-s*pi/10)*(rT(1:2)-rTc(1:2));
                m = m/norm(m);
                rT(1:2) = rTc(1:2) + b*m;
            case 5  % hold

        end
    % :::::::::: Floor Tom (FT) :::::::::: %
    case 2
        thetaT = pi/180*-23;
        switch nq
            case 4  % offset
                b = 0.05;
                m = R2d(s*pi/6)*(rT(1:2)-rTc(1:2));
                m = m/norm(m);
                rT(1:2) = rTc(1:2) + b*m;
        end
    % :::::::::: Mid Tom (MT) :::::::::: %
    case 3
        thetaT = pi/180*-5;
        switch nq
            case 4  % ghost note
                f = f*.5;
        end
    % :::::::::: Top Tom (TT) :::::::::: %
    case 4
        thetaT = pi/180*-5;
        switch nq
            case 1  % float
                thetaT = pi/180*5;
                rT(1:2) = rT(1:2)*.93;
                rT(3) = rT(3)+.1;
        end
    % :::::::::: Hi-Hat (HH) :::::::::: %
    case 5
        thetaT = pi/180*-2.5;
        rT(3) = rT(3)-.01;  % HH closed

%         b = 0.07;
%         m = rT(1:2)-rTc(1:2);
%         m = m/norm(m);
%         rT(1:2) = rTc(1:2) + b*m;
        % Deviation
        switch nq
            case 1  % float
                rT(3) = rT(3) - l*sin(thetaT);
                thetaT = thetaT+pi/180*15;
                rT(3) = rT(3) + l*sin(thetaT);
            case 2  % HH open
                rT(3) = rT(3)+.01;
            case 4  % move to the side a little to avoid collision with left SN
                b = 0.02;
                m = rT(1:2)-rTc(1:2);
                m = m/norm(m);
                rT(1:2) = rTc(1:2) + b*m;
            case 6  % to the RD
                f = .7*f;
            case 7  % for bowshot
                thetaT = thetaT-pi/180*3;
            case 8  % offset for long
                rT(1:2) = rT(1:2)*1.15;
        end
    % :::::::::: Ride Cymbal (RD) :::::::::: %
    case 6
        thetaT = pi/180*2;
        f = .7*f;
        % Deviation
        switch nq
            case 1  % float
                rT(3) = rT(3) - l*sin(thetaT);
                thetaT = thetaT+pi/180*15;
                rT(3) = rT(3) + l*sin(thetaT);
            case 7  % bell
                thetaT = pi/180*5;
                rT = dmT(p,end);
            case 6  % ride favorable to bell
                rT(1:2) = dmT(p(1):p(2),end)+[-.7071;.7071]*.07;
            case 8  % weak
                f = 5/7*f;
        end
    % :::::::::: Crash Cymbal (CCr) :::::::::: %
    case 7
        thetaT = pi/180*20;
        % Deviation
        switch nq
            case 1  % float
                rT(3) = rT(3) - l*sin(thetaT);
                thetaT = thetaT+pi/180*15;
                rT(3) = rT(3) + l*sin(thetaT);
            case 8  % weak
                f = .35*f;
            case 4  % offset
                if h == "R" % due to left moving from MT to FT
                    m = dmT(1:2,nr)-rTc(1:2);
                    b = 0.05;
                end
                m = m/norm(m);
                rT(1:2) = rTc(1:2) + b*m;
        end
    % :::::::::: Crash Cymbal (CC) :::::::::: %
    case 8
        if h == "R"
            thetaT = pi/180*23;
        elseif h == "L"
            thetaT = pi/180*18;
        end
        % Deviation
        switch nq
            case 1  % float
                rT(3) = rT(3) - l*sin(thetaT);
                thetaT = thetaT+pi/180*15;
                rT(3) = rT(3) + l*sin(thetaT);
            case 8  % weak
                f = .2*f;
            case 4  % offset
                if h == "R"
                    m = 1.1*dmT(1:2,nr)-rTc(1:2);
                    b = 0.08;
                end
                m = m/norm(m);
                rT(1:2) = rTc(1:2) + b*m;
        end
    % :::::::::: Stick beat :::::::::: %
    case 9  % Stick
        % Deviation
        switch nq
            case 1  % float at CC/CCr
                thetaT = pi/180*70;
                if h == "L"
                    rT = .8*dmT(p,8);
                elseif h == "R"
                    rT = .8*dmT(p,7);
                end
                rT(3) = .21;
            case 5  % stick-up at HH
                thetaT = pi/180*60;
                if h == "L"
                    rT = .8*dmT(p,5);
                elseif h == "R"
                    rT = .8*dmT(p,7);
                end
                rT(3) = .08;
            case 9  % draw end
%                 thetaT = pi/180*73.88;
                thetaT = pi/180*63.88;
                if h == "L"
                    rT = [0.024361390276832;
                          0.155242025455941;
                          0.028218645216999];
                    rT(1) = rT(1)+.1;
                    rT(2) = rT(2)+.05;
                elseif h == "R"
                    rT = [0.155242025455941;
                          0.024361390276832;
                          0.028218645216999];
                    rT(1) = rT(1)+.05;
                    rT(2) = rT(2)+.1;
                end
        end
end
thetaT = s*thetaT;  % cuz left and right has opposite signs.

phiT = stickOrient(rT,rbhat,q,h);
if ~(nq == 1)
    d = load('distance.txt');
    
%     if d(rem(n0,10),nr)/(iB/iQ) >= 6
%     
%         phiT = fminbnd(@(phi)costfun(phi,rT,thetaT,xd(1:3),rhhat,P,h),-pi/2,pi/2);
% 
%     end
    
    phiT1 = fminbnd(@(phi)costfun(phi,rT,thetaT,xd(1:3),rhhat,P,h),-pi/2,pi/2);
    
    c = [6;6];
    gamma = 1/(1 + exp(-c(1)*(d(rem(n0,10),nr)/(iB/iQ) - c(2))));
    phiT = gamma*phiT1 + (1-gamma)*phiT;

end

rST = RS(phiT,thetaT,h)*rhhat;         % stick's hit vector

% target position
xT = [rT-rST;phiT;thetaT];


function f = costfun(phi,rT,thetaT,xi,rhat,P,h)
    rS = RS(phi,thetaT,h)*rhat;
    x = rT - rS;
    e = P*(xi - x);
    f = 1/2*(e'*e);
end

end