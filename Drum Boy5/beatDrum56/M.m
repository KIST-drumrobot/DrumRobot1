function x = M(q)
global taulim dqlim qmax qmin qm
n = length(q);
x = Jm(q)'*Mx(q)*Jm(q);

% Forced symmetry
for i = 1:n
    for j = i:n
        if i ~= j
            x(i,j) = x(j,i);
        end
    end
end

% x = eig(x,'matrix');

% ---------- Diagonal ---------- %
x = diag(diag(x));
% x = sparse(x);
% x = diag(diag(x)./dqlim(1:n));
% x = diag(diag(x).*(1+abs((q-qm(1:n))./(qmax(1:n)-qmin(1:n)))));

% ---------- Identity ---------- %
% x = eye(n);

% ---------- Torque capacity ---------- %
% x = diag(1./taulim(1:n))*x;

% ---------- Simple mass-weighted ---------- %
% msum = mb+2*mu+2*ml+2*mh+mc;
% xu = (mu+ml+mh)/msum*eye(3);
% xl = (ml+mh)/msum*eye(2);
% xh = mh/msum*eye(2);
% xc = mc/msum*eye(2);
% x = blkdiag(1,xu,xl,xh, ...
%     xu,xl,xh,xc);

% ---------- dCOM-weighted ---------- %
% msum = mb+2*mu+2*ml+2*mh+mc;
% X = 1/(msum^2)*(G'*G);
% Jcom = Jm(q);
% Jcom = Jcom(1:8*3,:);
% x = Jcom'*X*Jcom;


%% Symmetric positive definite?
% issym = issymmetric(x);
% d = eig(x);
% isposdef = all(d > 0);
% issymposdef = issym*isposdef