function [d2q,dq,q] = clac_opt(Kd,Kp,d2xd,de,e,dq,q)
global T
global dqlim qmin qmax
n = length(q);

A = [];
b = [];
Aeq = [];
beq = [];
lb = [];
ub = [];
options = optimoptions("fmincon",...
    "Algorithm","interior-point",...
    "EnableFeasibilityMode",true,...
    "SubproblemAlgorithm","cg");

w0 = 0.5*ones(n,1);
w = fmincon(@(w)fun(w,Kd,Kp,d2xd,de,e,dq,q),w0,...
    A,b,Aeq,beq,lb,ub,...
    @(w)nonlcon(w,Kd,Kp,d2xd,de,e,dq,q),options);
W = diag(w);

% Weighted Jacobian and Jacobian derivative
JW = J(q)*W^(1/2);
MW = (W^(1/2))'*M(q)*W^(1/2);

% Psuedo inverse of Jacobian
Jp = MW^-1*JW'*(JW*MW^-1*JW')^-1;

% Closed-loop resolved-acceleration control
d2q = W^(1/2)*Jp*(d2xd + Kd*de + Kp*e - dJdt(q,dq)*dq);
dq = dq + d2q*T;
q = q + dq*T + 1/2*d2q*T^2;


    %% Cost function
    function f = fun(w,Kd,Kp,d2xd,de,e,dq,q)
        W = diag(w);
    
        % Weighted Jacobian and Jacobian derivative
        JW = J(q)*W^(1/2);
        MW = (W^(1/2))'*M(q)*W^(1/2);
        
        % Psuedo inverse of Jacobian
        Jp = MW^-1*JW'*(JW*MW^-1*JW')^-1;
        
        % Closed-loop resolved-acceleration control
        d2q = W^(1/2)*Jp*(d2xd + Kd*de + Kp*e - dJdt(q,dq)*dq);
        
        % Cost value
        f = 1/2*d2q'*M(q)*d2q;
    end

    %% Nonlinear constraint
    function [c,ceq] = nonlcon(w,Kd,Kp,d2xd,de,e,dq,q)
        W = diag(w);
    
        % Weighted Jacobian and Jacobian derivative
        JW = J(q)*W^(1/2);
        MW = (W^(1/2))'*M(q)*W^(1/2);
        
        % Psuedo inverse of Jacobian
        Jp = MW^-1*JW'*(JW*MW^-1*JW')^-1;
        
        % Closed-loop resolved-acceleration control
        d2q = W^(1/2)*Jp*(d2xd + Kd*de + Kp*e - dJdt(q,dq)*dq);

        % Nonlinear constraints
        c1 = dq + d2q*T - dqlim(1:n);
        c2 = -dqlim(1:n) - (dq + d2q*T);
        c3 = q + dq*T + 1/2*d2q*T^2 - qmax(1:n);
        c4 = qmin(1:n) - (q + dq*T + 1/2*d2q*T^2);
        c = [c1;c2;c3;c4];
        ceq = [];
    end

end