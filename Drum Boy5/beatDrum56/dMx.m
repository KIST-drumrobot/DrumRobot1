function dx = dMx(q,i)
global Ib_hat IuR_hat IlR_hat IhR_hat IuL_hat IlL_hat IhL_hat Ic_hat
n = length(q);

% Mass matrix
dGb = zeros(3,3,n);
dGuR = zeros(3,3,n);
dGlR = zeros(3,3,n);
dGhR = zeros(3,3,n);
dGuL = zeros(3,3,n);
dGlL = zeros(3,3,n);
dGhL = zeros(3,3,n);
dGc = zeros(3,3,n);

% Inertia matrix
dIb = m3times(dR1(q),Ib_hat*R1(q)') + m3times(R1(q)*Ib_hat,pagetranspose(dR1(q)));
dIuR = m3times(dR4(q),IuR_hat*R4(q)') + m3times(R4(q)*IuR_hat,pagetranspose(dR4(q)));
dIlR = m3times(dR6(q),IlR_hat*R6(q)') + m3times(R6(q)*IlR_hat,pagetranspose(dR6(q)));
dIhR = m3times(dR8(q),IhR_hat*R8(q)') + m3times(R8(q)*IhR_hat,pagetranspose(dR8(q)));
dIuL = m3times(dR11(q),IuL_hat*R11(q)') + m3times(R11(q)*IuL_hat,pagetranspose(dR11(q)));
dIlL = m3times(dR13(q),IlL_hat*R13(q)') + m3times(R13(q)*IlL_hat,pagetranspose(dR13(q)));
dIhL = m3times(dR15(q),IhL_hat*R15(q)') + m3times(R15(q)*IhL_hat,pagetranspose(dR15(q)));
dIc = m3times(dR17(q),Ic_hat*R17(q)') + m3times(R17(q)*Ic_hat,pagetranspose(dR17(q)));

dG = blkdiag(dGb(:,:,i),dGuR(:,:,i),dGlR(:,:,i),dGhR(:,:,i),dGuL(:,:,i),dGlL(:,:,i),dGhL(:,:,i),dGc(:,:,i));
dI = blkdiag(dIb(:,:,i),dIuR(:,:,i),dIlR(:,:,i),dIhR(:,:,i),dIuL(:,:,i),dIlL(:,:,i),dIhL(:,:,i),dIc(:,:,i));
dx = blkdiag(dG,dI);