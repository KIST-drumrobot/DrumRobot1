function [cnt,xT,d2xd,dxd,xd,d2xi,dxi,xi,fl] = ...
    traj(cnt,xT,d2xd,dxd,xd,d2xi,dxi,xi,q,k,code,dmT,iC,h)
global SN TT MT FT HH RD CCr CCl
global SNnon SNcen SNoff SNrim0 SNrim SNgst SNhld HHoff FToff CCroff SS
global rhR_hat rhL_hat
iN = code(cnt,3);
iB = code(cnt,6);
iQ = code(cnt,7);
iSwing = iB-iC;

a = code(cnt,5);  % sound level
n = code(cnt,4);  % target drum

cnt1 = min(cnt+1,length(code(:,1)));
iN1 = code(cnt1,3);
iB1 = code(cnt1,6);
n1 = code(cnt1,4);  % next target drum
% n1 = code(max(1,cnt-1),4);     % previous target drum
% previous target drum
if cnt > 1
    n0 = code(cnt-1,4);
else
    n0 = SNnon;
end
%% float
% sticks being floated without hitting the drum; sticks often need to move 
% without hitting to prevent themselves from crossing each other
% 11 = float after tom, 91 = float after cymbal, 
% 61 = float for rimshot, 65 = float for HH(rimshot), 
% 14 = float for TT, 19 = float stick, 59 = stick-up at HH
nfl = [1:8]+10;
fl = ismember(n,nfl);
fl0 = ismember(n0,nfl);
%% trajectory generation
i = internalTimer(k,cnt,code);  % internal time stamp in strike time [1 iN]
if cnt > 1
    %% i) strike time > swing time
    if iN > iB
        % starting from "hit"
        if ~fl0
            if i <= iC
                status = "contact-stay";
                ix = i;
            elseif i > iC && i <= iN-iSwing
                status = "stay";
                ix = i-iC;
                iStay = iN-iC-iSwing;
            else
                status = "swing";
                ix = i-(iN-iSwing);
            end
        % starting from "float"
        else
            if i <= iN-iSwing
                status = "stay";
                ix = i;
                iStay = iN-iSwing;
            else
                status = "swing";
                ix = i-(iN-iSwing);
            end
        end
    %% ii) strike time = swing time
    elseif iN == iB
        if i <= iC
            status = "contact";
            ix = i;
        else
            status = "swing";
            ix = i-iC;
        end
    end
else
    %% very first time
    if i <= iN-iSwing
        status = "stay";
        ix = i;
        iStay = iN-iSwing;
    else
        status = "swing";
        ix = i-(iN-iSwing);
    end
end
% target value
[xT,dxT,dxil,il,s] = targetVal(status,iSwing,iN1,iB1,iQ,iC,xd,xi,q,dmT,n,n1,n0,a,fl,h);
% state machine
switch status
    case {"contact","contact-stay"}
        [d2xd,dxd,xd,d2xi,dxi,xi] = contact(ix,iC,dxil,dxd,xd,d2xi,dxi,xi);
    case "stay"
        [d2xd,dxd,xd,d2xi,dxi,xi] = stay(ix,iStay,iC,dxil,dxd,xd,d2xi,dxi,xi,s);
    case "swing"
        [d2xd,dxd,xd,d2xi,dxi,xi] = swing(ix,iSwing,il,dxT,xT,d2xd,dxd,xd,d2xi,dxi,xi,fl);
end
%% update strike count
if i == iN
    cnt = cnt+1;
end