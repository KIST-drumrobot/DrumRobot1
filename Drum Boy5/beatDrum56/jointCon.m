function w = jointCon(dq,q,s)
global qmin qmax qm
n = length(q);
w = eye(n);

switch s
    case "b"    % For body
        qMax = qmax;
        qMin = qmin;
        qM = qm;
    case "f"    % For foot
        qMax = qmax(18:19);
        qMin = qmin(18:19);
        qM = qm(18:19);
end

% for i = 1:n
%     [dh,s] = jointConGrad(qmax(i),qmin(i),dq(i),q(i));
% 
%     if s > 0
%         w(i,i) = 1/(1+abs(dh));
%     else
%         w(i,i) = 1;
%     end
% end

for i = 1:n
%     if i == 7 || i == 14
%         s = .1;
%     else
%         s = .5;
%     end
%     b = jointConPenalty(qMin(i),qMax(i),qM(i),q(i),s);
    b = jointConPenalty(qMin(i),qMax(i),qM(i),q(i),.5);
    if (q(i) - qM(i))*dq(i) > 0    % Note: "=" equals that q(i) stuck in the limit    
        w(i,i) = 1 - b;
    else
        w(i,i) = 1;
    end
end