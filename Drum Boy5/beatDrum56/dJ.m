function x = dJ(q,i)
% NOTE: derivative of i-th q
global xhat yhat zhat Pyz
global rbR_hat ruR_hat rlR_hat rbL_hat ruL_hat rlL_hat rc_hat
n = length(q);

% drRdq = m3times(dR1(q),rbR_hat) + m3times(dR4(q),ruR_hat) + m3times(dR6(q),rlR_hat);
% drLdq = m3times(dR1(q),rbL_hat) + m3times(dR11(q),ruL_hat) + m3times(dR13(q),rlL_hat);
% doRdq = [zhat R1(q)*xhat R2(q)*yhat R3(q)*zhat R4(q)*xhat R5(q)*zhat R6(q)*yhat R7(q)*xhat zeros(3,9)];
% doLdq = [zhat zeros(3,7) R1(q)*yhat R9(q)*xhat R10(q)*zhat R11(q)*yhat R12(q)*zhat R13(q)*xhat R14(q)*yhat zeros(3,2)];
% doCdq = Pyz*m3times(dR17(q),rc_hat);
% doFdq = [zeros(2,17) eye(2)];

ddrRdq = d2R1(q,rbR_hat) + d2R4(q,ruR_hat) + d2R6(q,rlR_hat);
ddrLdq = d2R1(q,rbL_hat) + d2R11(q,ruL_hat) + d2R13(q,rlL_hat);

ddoRdq = zeros(3,n,n);
ddoRdq(:,2,:) = m3times(dR1(q),xhat);
ddoRdq(:,3,:) = m3times(dR2(q),yhat);
ddoRdq(:,4,:) = m3times(dR3(q),zhat);
ddoRdq(:,5,:) = m3times(dR4(q),xhat);
ddoRdq(:,6,:) = m3times(dR5(q),zhat);
ddoRdq(:,7,:) = m3times(dR6(q),yhat);
ddoRdq(:,8,:) = m3times(dR7(q),xhat);

ddoLdq = zeros(3,n,n);
ddoLdq(:,9,:) = m3times(dR1(q),yhat);
ddoLdq(:,10,:) = m3times(dR9(q),xhat);
ddoLdq(:,11,:) = m3times(dR10(q),zhat);
ddoLdq(:,12,:) = m3times(dR11(q),yhat);
ddoLdq(:,13,:) = m3times(dR12(q),zhat);
ddoLdq(:,14,:) = m3times(dR13(q),xhat);
ddoLdq(:,15,:) = m3times(dR14(q),yhat);

ddoCdq = d2R17(q,rc_hat);

x = [ddrRdq(:,:,i);
    ddoRdq(:,:,i);
    ddrLdq(:,:,i);
    ddoLdq(:,:,i);
    Pyz*ddoCdq(:,:,i)];