function x = dJdt(q,dq)
global xhat yhat zhat Pyz
global rbR_hat ruR_hat rlR_hat rbL_hat ruL_hat rlL_hat rc_hat

% drRdq = m3times(dR1(q),rbR_hat) + m3times(dR4(q),ruR_hat) + m3times(dR6(q),rlR_hat);
% drLdq = m3times(dR1(q),rbL_hat) + m3times(dR11(q),ruL_hat) + m3times(dR13(q),rlL_hat);
% doRdq = [zhat R1(q)*xhat R2(q)*yhat R3(q)*zhat R4(q)*xhat R5(q)*zhat R6(q)*yhat R7(q)*xhat zeros(3,9)];
% doLdq = [zhat zeros(3,7) R1(q)*yhat R9(q)*xhat R10(q)*zhat R11(q)*yhat R12(q)*zhat R13(q)*xhat R14(q)*yhat zeros(3,2)];
% doCdq = Pyz*m3times(dR17(q),(rc_hat.*yhat));

dJrR = m3times(d2R1(q,rbR_hat),dq) + m3times(d2R4(q,ruR_hat),dq) + m3times(d2R6(q,rlR_hat),dq);
dJrL = m3times(d2R1(q,rbL_hat),dq) + m3times(d2R11(q,ruL_hat),dq) + m3times(d2R13(q,rlL_hat),dq);
dJoR = [0*zhat m3times(dR1(q),xhat)*dq m3times(dR2(q),yhat)*dq m3times(dR3(q),zhat)*dq ...
    m3times(dR4(q),xhat)*dq m3times(dR5(q),zhat)*dq m3times(dR6(q),yhat)*dq m3times(dR7(q),xhat)*dq ...
    zeros(3,9)];
dJoL = [0*zhat zeros(3,7) ...
    m3times(dR1(q),yhat)*dq m3times(dR9(q),xhat)*dq m3times(dR10(q),zhat)*dq ...
    m3times(dR11(q),yhat)*dq m3times(dR12(q),zhat)*dq m3times(dR13(q),xhat)*dq m3times(dR14(q),yhat)*dq ...
    zeros(3,2)];
dJoC = Pyz*m3times(d2R17(q,rc_hat.*yhat),dq);

x = [dJrR;dJoR;dJrL;dJoL;dJoC];