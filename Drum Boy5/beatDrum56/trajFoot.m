function [cnt,d2xd,dxd,xd,dxi,xi] = trajFoot(cnt,dxi,xi,iQ,k,code,h)
global T qm
% iN = round(code(cnt,3)/T);
% iB = round(code(cnt,6)/T);
iN = code(cnt,3);
iB = code(cnt,6);

i = internalTimer(k,cnt,code);
if h == "R"
    % :::::::: Bass pedal :::::::: % 
    xO = qm(18);        % Offset (= pre-load)
    xT = pi/180*-33;    % Target pedal angle
    %% Recovery
    if i < iB && cnt > 1
        xdr = (xi-xO) - (xi-xO)*0.5*(1-cos(pi/iB*i));
        dxdr = -(xi-xO)*0.5*pi/(iB*T)*sin(pi/iB*i);
        d2xdr = -(xi-xO)*0.5*(pi/(iB*T))^2*cos(pi/iB*i);
    else
        xdr = 0;
        dxdr = 0;
        d2xdr = 0;
    end
    %% Hit
    iHit = round(iQ/12); % hit time
    if iHit > iB/2
        iHit = round(iB/2);
    end
    if i >= iN-iHit
        xds = (xT-xO)*0.5*(1-cos(pi/iHit*(i-(iN-iHit))));
        dxds = (xT-xO)*0.5*pi/(iHit*T)*sin(pi/iHit*(i-(iN-iHit)));
        d2xds = (xT-xO)*0.5*(pi/(iHit*T))^2*cos(pi/iHit*(i-(iN-iHit)));
    else
        xds = 0;
        dxds = 0;
        d2xds = 0;
    end
    
    xd = xdr + xds + xO;
    dxd = dxdr + dxds;
    d2xd = d2xdr + d2xds;

elseif h == "L"
    % :::::::: HH pedal :::::::: % 
    xO = qm(19);            % Offset (= pre-load)
    xT = pi/180*-21;        % Target pedal angle
    switch code(cnt,4)      % Target drum
        case 1
            %% Close
            xd = xi;
            dxd = 0;
            d2xd = 0;
            if i >= iN-iB
                xd = xd + (xT-xi)*0.5*(1-cos(pi/iB*(i-(iN-iB))));
                dxd = xd +(xT-xi)*0.5*pi/(iB*T)*sin(pi/iB*(i-(iN-iB)));
                d2xd = xd + (xT-xi)*0.5*(pi/(iB*T))^2*cos(pi/iB*(i-(iN-iB)));
            end
        case 2
            %% Open
            if i < iB
                xd = (xi-xO) - (xi-xO)*0.5*(1-cos(pi/iB*i));
                dxd = -(xi-xO)*0.5*pi/(iB*T)*sin(pi/iB*i);
                d2xd = -(xi-xO)*0.5*(pi/(iB*T))^2*cos(pi/iB*i);
            else
                xd = xO;
                dxd = 0;
                d2xd = 0;
            end
        otherwise
            %% Inactive
            xd = xi;
            dxd = dxi;
            d2xd = 0;
    end

end

% Update initials and count
if i == iN
    xi = xd;
    dxi = dxd;
    cnt = cnt+1;
end