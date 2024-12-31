function x = minWristVel(dq,q)
global xhat yhat zhat
global rbR_hat ruR_hat rlR_hat rbL_hat ruL_hat rlL_hat
n = length(q);
% Angular velocities
wb = zhat*dq(1);
wuR = wb + R1(q)*xhat*dq(2) + R2(q)*yhat*dq(3) + R3(q)*zhat*dq(4);
wlR = wuR + R4(q)*xhat*dq(5) + R5(q)*zhat*dq(6);
whR = wlR + R6(q)*yhat*dq(7) + R7(q)*xhat*dq(8);
wuL = wb + R1(q)*yhat*dq(9) + R9(q)*xhat*dq(10) + R10(q)*zhat*dq(11);
wlL = wuL + R11(q)*yhat*dq(12) + R12(q)*zhat*dq(13);
whL = wlL + R13(q)*xhat*dq(14) + R14(q)*yhat*dq(15);
% Joint positions
rbR = R1(q)*rbR_hat;
reR = rbR + R4(q)*ruR_hat;
rwR = reR + R6(q)*rlR_hat;
rbL = R1(q)*rbL_hat;
reL = rbL + R11(q)*ruL_hat;
rwL = reL + R13(q)*rlL_hat;
% Joint velocities
drbR = cross(wb,rbR);
dreR = drbR + cross(wuR,reR-rbR);
drwR = dreR + cross(wlR,rwR-reR);
drbL = cross(wb,rbL);
dreL = drbL + cross(wuL,reL-rbL);
drwL = dreL + cross(wlL,rwL-reL);
%% Jacobians
% Angular velocities
dwbdq = zeros(3,n);
dwuRdq = dwbdq + m3times(dR1(q),xhat)*dq(2) + m3times(dR2(q),yhat)*dq(3) + m3times(dR3(q),zhat)*dq(4);
dwlRdq = dwuRdq + m3times(dR4(q),xhat)*dq(5) + m3times(dR5(q),zhat)*dq(6);
dwhRdq = dwlRdq + m3times(dR6(q),yhat)*dq(7) + m3times(dR7(q),xhat)*dq(8);
dwuLdq = dwbdq + m3times(dR1(q),yhat)*dq(9) + m3times(dR9(q),xhat)*dq(10) + m3times(dR10(q),zhat)*dq(11);
dwlLdq = dwuLdq + m3times(dR11(q),yhat)*dq(12) + m3times(dR12(q),zhat)*dq(13);
dwhLdq = dwlLdq + m3times(dR13(q),xhat)*dq(14) + m3times(dR14(q),yhat)*dq(15);
% Joint positions
drbRdq = m3times(dR1(q),rbR_hat);
dreRdq = drbRdq + m3times(dR4(q),ruR_hat);
drwRdq = dreRdq + m3times(dR6(q),rlR_hat);
drbLdq = m3times(dR1(q),rbL_hat);
dreLdq = drbLdq + m3times(dR11(q),ruL_hat);
drwLdq = dreLdq + m3times(dR13(q),rlL_hat);
% Joint velocities
ddrbRdq = crossM(dwbdq,rbR) + crossM(wb,drbRdq);
ddreRdq = ddrbRdq + crossM(dwuRdq,reR-rbR) + crossM(wuR,dreRdq-drbRdq);
ddrwRdq = ddreRdq + crossM(dwlRdq,rwR-reR) + crossM(wlR,drwRdq-dreRdq);
ddrbLdq = crossM(dwbdq,rbL) + crossM(wb,drbLdq);
ddreLdq = ddrbLdq + crossM(dwuLdq,reL-rbL) + crossM(wuL,dreLdq-drbLdq);
ddrwLdq = ddreLdq + crossM(dwlLdq,rwL-reL) + crossM(wlL,drwLdq-dreLdq);
%% Gradient
X = [1 0 0;0 1 0;0 0 0];
% J = -1/2*(drwR'*X*drwR + drwL'*X*drwL)
% x = k0*dJ/dq 
k0 = .02;
x = -k0*(ddrwRdq'*X*drwR + ddrwLdq'*X*drwL);