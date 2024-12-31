function d2w = virtWall(dq,q)
global qmin qmax
kp = 1e2;
% kd = 1e2;
kd = 1e3;

n = length(q);
d2w = zeros(n,1);

for i = 1:n
    if q(i) > qmax(i) 
        e = q(i) - qmax(i);
%         d2w(i) = -kd*abs(e)*max(dq(i),0) -kp*e;
        d2w(i) = -kd*max(dq(i),0) -kp*e;
        
    elseif q(i) < qmin(i)
        e = q(i) - qmin(i);
%         d2w(i) = -kd*abs(e)*min(dq(i),0) -kp*e;
        d2w(i) = -kd*min(dq(i),0) -kp*e;
    end
end