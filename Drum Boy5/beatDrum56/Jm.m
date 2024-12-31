function x = Jm(q)
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

dwb = zeros(3,n);
dwuR = zeros(3,n);
dwlR = zeros(3,n);
dwhR = zeros(3,n);
dwuL = zeros(3,n);
dwlL = zeros(3,n);
dwhL = zeros(3,n);
dwc = zeros(3,n);

dwb(:,1) = zhat;

dwuR(:,1) = dwb(:,1);
dwuR(:,2) = R1(q)*xhat;
dwuR(:,3) = R2(q)*yhat;
dwuR(:,4) = R3(q)*zhat;

dwlR(:,1) = dwuR(:,1);
dwlR(:,2) = dwuR(:,2);
dwlR(:,3) = dwuR(:,3);
dwlR(:,4) = dwuR(:,4);
dwlR(:,5) = R4(q)*xhat;
dwlR(:,6) = R5(q)*zhat;

dwhR(:,1) = dwlR(:,1);
dwhR(:,2) = dwlR(:,2);
dwhR(:,3) = dwlR(:,3);
dwhR(:,4) = dwlR(:,4);
dwhR(:,5) = dwlR(:,5);
dwhR(:,6) = dwlR(:,6);
dwhR(:,7) = R6(q)*yhat;
dwhR(:,8) = R7(q)*xhat;

dwuL(:,1) = dwb(:,1);
dwuL(:,9) = R1(q)*yhat;
dwuL(:,10) = R9(q)*xhat;
dwuL(:,11) = R10(q)*zhat;

dwlL(:,1) = dwuL(:,1);
dwlL(:,9) = dwuL(:,9);
dwlL(:,10) = dwuL(:,10);
dwlL(:,11) = dwuL(:,11);
dwlL(:,12) = R11(q)*yhat;
dwlL(:,13) = R12(q)*zhat;

dwhL(:,1) = dwlL(:,1);
dwhL(:,9) = dwlL(:,9);
dwhL(:,10) = dwlL(:,10);
dwhL(:,11) = dwlL(:,11);
dwhL(:,12) = dwlL(:,12);
dwhL(:,13) = dwlL(:,13);
dwhL(:,14) = R13(q)*xhat;
dwhL(:,15) = R14(q)*yhat;

dwc(:,1) = dwb(:,1);
dwc(:,16) = R1(q)*Rz(-pi/4)*xhat;
dwc(:,17) = R16(q)*zhat;


%% Jacobians for velocities
% Joint positions
drbR = m3times(dR1(q),rbR_hat);
dreR = drbR + m3times(dR4(q),ruR_hat);
drwR = dreR + m3times(dR6(q),rlR_hat);
drbL = m3times(dR1(q),rbL_hat);
dreL = drbL + m3times(dR11(q),ruL_hat);
drwL = dreL + m3times(dR13(q),rlL_hat);
drn = m3times(dR1(q),rn_hat);

% COM positions
drb = m3times(dR1(q),rbc_hat);
druR = drbR + m3times(dR4(q),rucR_hat);
drlR = dreR + m3times(dR6(q),rlcR_hat);
drhR = drwR + m3times(dR8(q),rhcR_hat);
druL = drbL + m3times(dR11(q),rucL_hat);
drlL = dreL + m3times(dR13(q),rlcL_hat);
drhL = drwL + m3times(dR15(q),rhcL_hat);
drc = drn + m3times(dR17(q),rcc_hat);


%% Jacobian matrix
Jr = [drb;druR;drlR;drhR;druL;drlL;drhL;drc];
Jw = [dwb;dwuR;dwlR;dwhR;dwuL;dwlL;dwhL;dwc];
x = [Jr;Jw];
% x = sparse(x);
% x = Jr;