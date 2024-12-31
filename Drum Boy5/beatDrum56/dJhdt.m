function x = dJhdt(q,dq)
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

% Time derivative
dJwb = zeros(3,n);
dJwuR = zeros(3,n);
dJwlR = zeros(3,n);
dJwhR = zeros(3,n);
dJwuL = zeros(3,n);
dJwlL = zeros(3,n);
dJwhL = zeros(3,n);
dJwc = zeros(3,n);

dJwb(:,1) = 0*zhat;

dJwuR(:,1) = dJwb(:,1);
dJwuR(:,2) = m3times(dR1(q),xhat)*dq;
dJwuR(:,3) = m3times(dR2(q),yhat)*dq;
dJwuR(:,4) = m3times(dR3(q),zhat)*dq;

dJwlR(:,1) = dJwuR(:,1);
dJwlR(:,2) = dJwuR(:,2);
dJwlR(:,3) = dJwuR(:,3);
dJwlR(:,4) = dJwuR(:,4);
dJwlR(:,5) = m3times(dR4(q),xhat)*dq;
dJwlR(:,6) = m3times(dR5(q),zhat)*dq;

dJwhR(:,1) = dJwlR(:,1);
dJwhR(:,2) = dJwlR(:,2);
dJwhR(:,3) = dJwlR(:,3);
dJwhR(:,4) = dJwlR(:,4);
dJwhR(:,5) = dJwlR(:,5);
dJwhR(:,6) = dJwlR(:,6);
dJwhR(:,7) = m3times(dR6(q),yhat)*dq;
dJwhR(:,8) = m3times(dR7(q),xhat)*dq;

dJwuL(:,1) = dJwb(:,1);
dJwuL(:,9) = m3times(dR1(q),yhat)*dq;
dJwuL(:,10) = m3times(dR9(q),xhat)*dq;
dJwuL(:,11) = m3times(dR10(q),zhat)*dq;

dJwlL(:,1) = dJwuL(:,1);
dJwlL(:,9) = dJwuL(:,9);
dJwlL(:,10) = dJwuL(:,10);
dJwlL(:,11) = dJwuL(:,11);
dJwlL(:,12) = m3times(dR11(q),yhat)*dq;
dJwlL(:,13) = m3times(dR12(q),zhat)*dq;

dJwhL(:,1) = dJwlL(:,1);
dJwhL(:,9) = dJwlL(:,9);
dJwhL(:,10) = dJwlL(:,10);
dJwhL(:,11) = dJwlL(:,11);
dJwhL(:,12) = dJwlL(:,12);
dJwhL(:,13) = dJwlL(:,13);
dJwhL(:,14) = m3times(dR13(q),xhat)*dq;
dJwhL(:,15) = m3times(dR14(q),yhat)*dq;

dJwc(:,1) = dJwb(:,1);
dJwc(:,16) = m3times(dR1(q),Rz(-pi/4)*xhat)*dq;
dJwc(:,17) = m3times(dR16(q),zhat)*dq;

% Inertia matrix from inertial(global) frame
Ib = R1(q)*Ib_hat*R1(q)';
IuR = R4(q)*IuR_hat*R4(q)';
IlR = R6(q)*IlR_hat*R6(q)';
IhR = R8(q)*IhR_hat*R8(q)';
IuL = R11(q)*IuL_hat*R11(q)';
IlL = R13(q)*IlL_hat*R13(q)';
IhL = R15(q)*IhL_hat*R15(q)';
Ic = R17(q)*Ic_hat*R17(q)';

% Time derivative
dIb = dRdt(dR1(q),dq)*Ib_hat*R1(q)' + R1(q)*Ib_hat*dRdt(dR1(q),dq)';
dIuR = dRdt(dR4(q),dq)*IuR_hat*R4(q)' + R4(q)*IuR_hat*dRdt(dR4(q),dq)';
dIlR = dRdt(dR6(q),dq)*IlR_hat*R6(q)' + R6(q)*IlR_hat*dRdt(dR6(q),dq)';
dIhR = dRdt(dR8(q),dq)*IhR_hat*R8(q)' + R8(q)*IhR_hat*dRdt(dR8(q),dq)';
dIuL = dRdt(dR11(q),dq)*IuL_hat*R11(q)' + R11(q)*IuL_hat*dRdt(dR11(q),dq)';
dIlL = dRdt(dR13(q),dq)*IlL_hat*R13(q)' + R13(q)*IlL_hat*dRdt(dR13(q),dq)';
dIhL = dRdt(dR15(q),dq)*IhL_hat*R15(q)' + R15(q)*IhL_hat*dRdt(dR15(q),dq)';
dIc = dRdt(dR17(q),dq)*Ic_hat*R17(q)' + R17(q)*Ic_hat*dRdt(dR17(q),dq)';


%% Jacobians for velocities
% Joint positions
d2rbRdq = m3times(d2R1(q,rbR_hat),dq);
d2reRdq = d2rbRdq + m3times(d2R4(q,ruR_hat),dq);
d2rwRdq = d2reRdq + m3times(d2R6(q,rlR_hat),dq);
d2rbLdq = m3times(d2R1(q,rbL_hat),dq);
d2reLdq = d2rbLdq + m3times(d2R11(q,ruL_hat),dq);
d2rwLdq = d2reLdq + m3times(d2R13(q,rlL_hat),dq);
d2rndq = m3times(d2R1(q,rn_hat),dq);

% COM positions
d2rbdq = m3times(d2R1(q,rbc_hat),dq);
d2ruRdq = d2rbRdq + m3times(d2R4(q,rucR_hat),dq);
d2rlRdq = d2reRdq + m3times(d2R6(q,rlcR_hat),dq);
d2rhRdq = d2rwRdq + m3times(d2R8(q,rhcR_hat),dq);
d2ruLdq = d2rbLdq + m3times(d2R11(q,rucL_hat),dq);
d2rlLdq = d2reLdq + m3times(d2R13(q,rlcL_hat),dq);
d2rhLdq = d2rwLdq + m3times(d2R15(q,rhcL_hat),dq);
d2rcdq = d2rndq + m3times(d2R17(q,rcc_hat),dq);


%% Differential Jacobian matrix
x = [mb*d2rbdq+mu*d2ruRdq+ml*d2rlRdq+mh*d2rhRdq+mu*d2ruLdq+ml*d2rlLdq+mh*d2rhLdq+mc*d2rcdq;
    Ib*dJwb+IuR*dJwuR+IlR*dJwlR+IhR*dJwhR+IuL*dJwuL+IlL*dJwlL+IhL*dJwhL+Ic*dJwc+...
    dIb*Jwb+dIuR*JwuR+dIlR*JwlR+dIhR*JwhR+dIuL*JwuL+dIlL*JwlL+dIhL*JwhL+dIc*Jwc];
% x = [mb*d2rbdq+mu*d2ruRdq+ml*d2rlRdq+mh*d2rhRdq+mu*d2ruLdq+ml*d2rlLdq+mh*d2rhLdq+mc*d2rcdq];