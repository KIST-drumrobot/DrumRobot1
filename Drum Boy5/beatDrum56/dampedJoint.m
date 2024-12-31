function d2w = dampedJoint(dqd,qd,dq,q)
kd = [10;10;10;10;10;30;10;10];
kp = 100;

n = length(dq);
% G = g*eye(n);
Kd = 10*eye(n);
Kp = zeros(n);

for i = [6 7]
    Kd(i,i) = kd(i);
    Kd(i+7,i+7) = kd(i);

    Kp(i,i) = kp;
    Kp(i+7,i+7) = kp;
end
% Kd(16:17,16:17) = eye(2);

% d2w = Kd*(dqd - dq) + Kp*(qd - q);
% d2w = Kd*(dqd - dq);
d2w = Kd*(0 - dq);