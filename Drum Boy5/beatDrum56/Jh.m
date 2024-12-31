function x = Jh(q)
global mb mu ml mh mc 
global Ib_hat IuR_hat IlR_hat IhR_hat IuL_hat IlL_hat IhL_hat Ic_hat
global xhat yhat zhat
global rbR_hat ruR_hat rlR_hat rbL_hat ruL_hat rlL_hat
global rbc_hat rucR_hat rlcR_hat rhcR_hat rucL_hat rlcL_hat rhcL_hat rn_hat rcc_hat
n = length(q);

%% Jacobians for angular velocities
% wb = zhat*dq(1);
% wuR = wb + R1(q)*xhat*dq(2) + R2(q)*yhat*dq(3) + R3(q)*zhat*dq(4);
% wlR = wuR + R4(q)*xhat*dq(5) + R5(q)*zhat*dq(6);
% whR = wlR + R6(q)*yhat*dq(7) + R7(q)*xhat*dq(8);
% wuL = wb + R1(q)*yhat*dq(9) + R9(q)*xhat*dq(10) + R10(q)*zhat*dq(11);
% wlL = wuL + R11(q)*yhat*dq(12) + R12(q)*zhat*dq(13);
% whL = wlL + R13(q)*xhat*dq(14) + R14(q)*yhat*dq(15);
% wc = wb + R1(q)*Rz(-pi/4)*xhat*dq(16) + R16(q)*zhat*dq(17);

Jwb = zeros(3,n);
JwuR = zeros(3,n);
JwlR = zeros(3,n);
JwhR = zeros(3,n);
JwuL = zeros(3,n);
JwlL = zeros(3,n);
JwhL = zeros(3,n);
Jwc = zeros(3,n);

Jwb(:,1) = zhat;

JwuR(:,1) = Jwb(:,1);
JwuR(:,2) = R1(q)*xhat;
JwuR(:,3) = R2(q)*yhat;
JwuR(:,4) = R3(q)*zhat;

JwlR(:,1) = JwuR(:,1);
JwlR(:,2) = JwuR(:,2);
JwlR(:,3) = JwuR(:,3);
JwlR(:,4) = JwuR(:,4);
JwlR(:,5) = R4(q)*xhat;
JwlR(:,6) = R5(q)*zhat;

JwhR(:,1) = JwlR(:,1);
JwhR(:,2) = JwlR(:,2);
JwhR(:,3) = JwlR(:,3);
JwhR(:,4) = JwlR(:,4);
JwhR(:,5) = JwlR(:,5);
JwhR(:,6) = JwlR(:,6);
JwhR(:,7) = R6(q)*yhat;
JwhR(:,8) = R7(q)*xhat;

JwuL(:,1) = Jwb(:,1);
JwuL(:,9) = R1(q)*yhat;
JwuL(:,10) = R9(q)*xhat;
JwuL(:,11) = R10(q)*zhat;

JwlL(:,1) = JwuL(:,1);
JwlL(:,9) = JwuL(:,9);
JwlL(:,10) = JwuL(:,10);
JwlL(:,11) = JwuL(:,11);
JwlL(:,12) = R11(q)*yhat;
JwlL(:,13) = R12(q)*zhat;

JwhL(:,1) = JwlL(:,1);
JwhL(:,9) = JwlL(:,9);
JwhL(:,10) = JwlL(:,10);
JwhL(:,11) = JwlL(:,11);
JwhL(:,12) = JwlL(:,12);
JwhL(:,13) = JwlL(:,13);
JwhL(:,14) = R13(q)*xhat;
JwhL(:,15) = R14(q)*yhat;

Jwc(:,1) = Jwb(:,1);
Jwc(:,16) = R1(q)*Rz(-pi/4)*xhat;
Jwc(:,17) = R16(q)*zhat;

% Inertia matrix from inertial(global) frame
Ib = R1(q)*Ib_hat*R1(q)';
IuR = R4(q)*IuR_hat*R4(q)';
IlR = R6(q)*IlR_hat*R6(q)';
IhR = R8(q)*IhR_hat*R8(q)';
IuL = R11(q)*IuL_hat*R11(q)';
IlL = R13(q)*IlL_hat*R13(q)';
IhL = R15(q)*IhL_hat*R15(q)';
Ic = R17(q)*Ic_hat*R17(q)';


%% Jacobians for velocities
% Joint positions
drbRdq = m3times(dR1(q),rbR_hat);
dreRdq = drbRdq + m3times(dR4(q),ruR_hat);
drwRdq = dreRdq + m3times(dR6(q),rlR_hat);
drbLdq = m3times(dR1(q),rbL_hat);
dreLdq = drbLdq + m3times(dR11(q),ruL_hat);
drwLdq = dreLdq + m3times(dR13(q),rlL_hat);
drndq = m3times(dR1(q),rn_hat);

% COM positions
drbdq = m3times(dR1(q),rbc_hat);
druRdq = drbRdq + m3times(dR4(q),rucR_hat);
drlRdq = dreRdq + m3times(dR6(q),rlcR_hat);
drhRdq = drwRdq + m3times(dR8(q),rhcR_hat);
druLdq = drbLdq + m3times(dR11(q),rucL_hat);
drlLdq = dreLdq + m3times(dR13(q),rlcL_hat);
drhLdq = drwLdq + m3times(dR15(q),rhcL_hat);
drcdq = drndq + m3times(dR17(q),rcc_hat);


%% Jacobian matrix
x = [mb*drbdq+mu*druRdq+ml*drlRdq+mh*drhRdq+mu*druLdq+ml*drlLdq+mh*drhLdq+mc*drcdq;
    Ib*Jwb+IuR*JwuR+IlR*JwlR+IhR*JwhR+IuL*JwuL+IlL*JwlL+IhL*JwhL+Ic*Jwc];
% x = mb*drbdq+mu*druRdq+ml*drlRdq+mh*drhRdq+mu*druLdq+ml*drlLdq+mh*drhLdq+mc*drcdq;