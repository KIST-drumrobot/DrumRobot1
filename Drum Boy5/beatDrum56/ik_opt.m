function [d2q,dq,q] = ik_opt(xd,d2q,dq,q)
global T
global dqlim qmin qmax
n = length(q);

A = [];
b = [];
Aeq = [];
beq = [];
lb = max((-dqlim(1:n)-dq)/T,(2*(qmin(1:n)-q-dq*T)/T^2));
ub = min((+dqlim(1:n)-dq)/T,(2*(qmax(1:n)-q-dq*T)/T^2));
options = optimoptions("fmincon",...
    "Algorithm","interior-point",...
    "EnableFeasibilityMode",true,...
    "SubproblemAlgorithm","cg");

d2q0 = d2q;
d2q = fmincon(@(d2q)fun(d2q,dq,q),d2q0,...
    A,b,Aeq,beq,lb,ub,@(d2q)nonlcon(d2q,xd,dq,q),options);

% Acceleration control
dq = dq + d2q*T;
q = q + dq*T + 1/2*d2q*T^2;


    %% Cost function
    function f = fun(d2q,dq,q)
        q = q + dq*T + 1/2*d2q*T^2;

        f = 1/2*d2q'*M(q)*d2q;
    end

    %% Nonlinear constraint
    function [c,ceq] = nonlcon(d2q,xd,dq,q)
        q = q + dq*T + 1/2*d2q*T^2;

        c = [];
        ceq = xd - fk(q);
    end

end