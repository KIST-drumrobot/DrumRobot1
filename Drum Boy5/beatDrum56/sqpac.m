function [d2q,dq,q] = sqpac(N,d2xd,dq0,q0)
global T dqlim qmin qmax
n = length(q);
I = eye(n);

ql = qmin(1:n);
qu = [qmax;dqlim];

% N = 10; % Finite horizon

x0 = zeros(n*N,1);

F = [I T*I;zeros(n) I];
H = [1/2*T^2*I;T*I];
xq = [q0;dq0];

AA = zeros(2*n*N,2*n);
AB = zeros(2*n*N,N*n);
for j = 1:N
    AA(1+(j-1)*2*n:j*2*n,:) = F^j;
    for k = 1:j
        AB(1+(j-1)*2*n:j*2*n,1+(k-1)*n:k*n) = F^(j-k)*H;
    end
end
A = [AB;-AB];
b = [qu;-ql] - [AA;-AA]*xq;
Aeq = [];
beq = [];
lb = [];
ub = [];

options = optimoptions('fmincon','Algorithm','sqp','Display','none');
x = fmincon(@costfun,x0,A,b,Aeq,beq,lb,ub,[],options);
d2q = x(1:n);
dq = dq0 + d2q*T;
q = q0 + dq0*T + 1/2*d2q*T^2;

    function f = costfun(x)
        lambda = 0.1;
        f = 0;
        for i = 1:N
            u = x(1+(i-1)*n:i*n);
            xq = F*xq + H*u;
            q = xq(1:n);
            dq = xq(n+1:2*n);

            e = d2xd(:,i)-dJdt(q,dq)*dq-J(q)*u;
            f = f + 1/2*(lambda*(u'*u) + (e'*e));
        end
    end

end