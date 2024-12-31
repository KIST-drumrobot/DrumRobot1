function x = Mx(q)
global mb mu ml mh mc 
global Ib_hat IuR_hat IlR_hat IhR_hat IuL_hat IlL_hat IhL_hat Ic_hat

% Mass matrix
Gb = mb*eye(3);
GuR = mu*eye(3);
GlR = ml*eye(3);
GhR = mh*eye(3);
GuL = mu*eye(3);
GlL = ml*eye(3);
GhL = mh*eye(3);
Gc = mc*eye(3);

% Inertia matrix
Ib = R1(q)*Ib_hat*R1(q)';
IuR = R4(q)*IuR_hat*R4(q)';
IlR = R6(q)*IlR_hat*R6(q)';
IhR = R8(q)*IhR_hat*R8(q)';
IuL = R11(q)*IuL_hat*R11(q)';
IlL = R13(q)*IlL_hat*R13(q)';
IhL = R15(q)*IhL_hat*R15(q)';
Ic = R17(q)*Ic_hat*R17(q)';

G = blkdiag(Gb,GuR,GlR,GhR,GuL,GlL,GhL,Gc);
I = blkdiag(Ib,IuR,IlR,IhR,IuL,IlL,IhL,Ic);
x = blkdiag(G,I);
% x = sparse(x);
% x = G;