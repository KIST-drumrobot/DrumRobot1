function dx = dM(q,i)
n = length(q);
dx = dJm(q,i)'*Mx(q)*Jm(q) + Jm(q)'*dMx(q,i)*Jm(q) + Jm(q)'*Mx(q)*dJm(q,i);

% Forced symmetry
for i = 1:n
    for j = i:n
        if i ~= j
            dx(i,j) = dx(j,i);
        end
    end
end

% ---------- Diagonal ---------- %
dx = diag(diag(dx));


%% Symmetric positive definite?
% issym = issymmetric(x);
% d = eig(x);
% isposdef = all(d > 0);
% issymposdef = issym*isposdef