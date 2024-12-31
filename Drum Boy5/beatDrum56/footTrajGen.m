function [cnt,d2q,dq,q] = footTrajGen(cnt,k,code,iQ)
global T

a = 1;
iN = round(code(cnt,2)/T);

if cnt > 1
    %% Rest phase
    i = k - round(sum(code(1:cnt-1,2))/T); % internal counter
    
    [cnt,d2q,dq,q,dqi,qi,qT,X] = regStrike(cnt,d2q,dq,q,dqi,qi,qT,X,i,iN,iQ,iC,a);
else
    %% Initial phase
    i = k;

    if iN > iQ/2
        if i > iN-iQ/2
            q = a*0.5*(1 - cos(2*pi/(iQ*T)*(i - (iN-iQ/2))*T));
            [cnt,d2q,dq,q] = baseStrike(cnt,X,(i-(iN-iB+iC/2)),iB,h);
        end
    elseif iN == iQ/2 
        [cnt,d2q,dq,q,dqi,qi,qT,X] = baseStrikeF(cnt,d2q,dq,q,dqi,qi,qT,X,(i-iC/2),iC,a);
    end
end
