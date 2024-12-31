function [d2q,dq,q] = clrc_optNull(Kp,dxd,e,dq,q,alpha)
global T dqlim
n = length(q);
dq1 = dq;

% Joint constraints
W = jointCon(dq,q,'b');

% Weighted Jacobian and Jacobian derivative
JW = J(q)*W^(1/2);

% Psuedo inverse of Jacobian
Jp = M(q)^-1*JW'*(JW*M(q)^-1*JW')^-1;

% Closed-loop resolved-rate control
dq = W^(1/2)*Jp*(dxd + Kp*e);

A1 = alpha*W^(1/2)*(eye(n) - Jp*JW)*W^(1/2);
A2 = -A1;
b1 = dqlim(1:n) - dq;
b2 = dqlim(1:n) + dq;
A = [A1;A2];
b = [b1;b2];
Aeq = [];
beq = [];
lb = [];
ub = [];
options = optimoptions("fmincon",...
    "Algorithm","interior-point",...
    "EnableFeasibilityMode",true,...
    "SubproblemAlgorithm","cg");

dw0 = zeros(n,1);
dw = fmincon(@(dw)fun(dw,dq,dq1),dw0,...
    A,b,Aeq,beq,lb,ub,[],options);

% Closed-loop resolved-rate control with null-space optimization
dq = W^(1/2)*Jp*(dxd + Kp*e) + alpha*W^(1/2)*(eye(17) - Jp*JW)*W^(1/2)*dw;
d2q = (dq - dq1)/T;
q = q + dq*T;


    %% Cost function
    function f = fun(dw,dq,dq1)
        % Closed-loop resolved-rate control
        dq = dq + alpha*W^(1/2)*(eye(17) - Jp*JW)*W^(1/2)*dw;
        d2q = (dq - dq1)/T;
        q = q + dq*T;

        f = 1/2*d2q'*M(q)*d2q;
    end

end