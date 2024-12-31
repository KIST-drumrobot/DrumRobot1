function x = Jb(q)
global xhat yhat zhat
global rbR_hat ruR_hat rlR_hat rbL_hat ruL_hat rlL_hat

drRdq = m3times(dR1(q),rbR_hat) + m3times(dR4(q),ruR_hat) + m3times(dR6(q),rlR_hat);
drLdq = m3times(dR1(q),rbL_hat) + m3times(dR11(q),ruL_hat) + m3times(dR13(q),rlL_hat);
doRdq = [zhat R1(q)*xhat R2(q)*yhat R3(q)*zhat R4(q)*xhat R5(q)*zhat R6(q)*yhat R7(q)*xhat zeros(3,7)];
doLdq = [zhat zeros(3,7) R1(q)*yhat R9(q)*xhat R10(q)*zhat R11(q)*yhat R12(q)*zhat R13(q)*xhat R14(q)*yhat];

x = [drRdq;doRdq;drLdq;doLdq];

% Independent of q(1)
x = x(:,2:end);