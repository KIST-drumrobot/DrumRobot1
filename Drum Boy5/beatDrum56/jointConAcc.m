function w = jointConAcc(dq,q)
global qmin qmax
n = length(q);
w = eye(n);

for i = 1:n
    b = jointConAccPenalty(qmin(i),qmax(i),q(i),0.1);

    if (q(i) - (qmax(i)-qmin(i))/2)*dq(i) > 0    % Note: "=" makes q(i) stuck in the limit    
        w(i,i) = 1 - b;
    else
        w(i,i) = 1;
    end
end