function x = minWristVelRel(dq,q)
global xhat yhat zhat
global ruR_hat rlR_hat ruL_hat rlL_hat
% Angular velocities
wuR = R1(q)*xhat*dq(2) + R2(q)*yhat*dq(3) + R3(q)*zhat*dq(4);
wlR = wuR + R4(q)*xhat*dq(5) + R5(q)*zhat*dq(6);
wuL = R1(q)*yhat*dq(9) + R9(q)*xhat*dq(10) + R10(q)*zhat*dq(11);
wlL = wuL + R11(q)*yhat*dq(12) + R12(q)*zhat*dq(13);
% Joint positions
reR = R4(q)*ruR_hat;
rwR = reR + R6(q)*rlR_hat;
reL = R11(q)*ruL_hat;
rwL = reL + R13(q)*rlL_hat;
% Joint velocities
dreR = cross(wuR,reR);
drwR = dreR + cross(wlR,rwR-reR);
dreL = cross(wuL,reL);
drwL = dreL + cross(wlL,rwL-reL);
%% Jacobians
% Angular velocities
dwuRdq = m3times(dR1(q),xhat)*dq(2) + m3times(dR2(q),yhat)*dq(3) + m3times(dR3(q),zhat)*dq(4);
dwlRdq = dwuRdq + m3times(dR4(q),xhat)*dq(5) + m3times(dR5(q),zhat)*dq(6);
dwuLdq = m3times(dR1(q),yhat)*dq(9) + m3times(dR9(q),xhat)*dq(10) + m3times(dR10(q),zhat)*dq(11);
dwlLdq = dwuLdq + m3times(dR11(q),yhat)*dq(12) + m3times(dR12(q),zhat)*dq(13);
% Joint positions
dreRdq = m3times(dR4(q),ruR_hat);
drwRdq = dreRdq + m3times(dR6(q),rlR_hat);
dreLdq = m3times(dR11(q),ruL_hat);
drwLdq = dreLdq + m3times(dR13(q),rlL_hat);
% Joint velocities
ddreRdq = crossM(dwuRdq,reR) + crossM(wuR,dreRdq);
ddrwRdq = ddreRdq + crossM(dwlRdq,rwR-reR) + crossM(wlR,drwRdq-dreRdq);
ddreLdq = crossM(dwuLdq,reL) + crossM(wuL,dreLdq);
ddrwLdq = ddreLdq + crossM(dwlLdq,rwL-reL) + crossM(wlL,drwLdq-dreLdq);
%% Gradient
X = [1 0 0;0 1 0;0 0 0];
% J = -1/2*(drwR'*X*drwR + drwL'*X*drwL)
% x = k0*dJ/dq 
k0 = 10;
x = -k0*(ddrwRdq'*X*drwR + ddrwLdq'*X*drwL);