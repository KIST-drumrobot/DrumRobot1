function x = dJm(q,i)
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

ddwb = zeros(3,n,n);
ddwuR = zeros(3,n,n);
ddwlR = zeros(3,n,n);
ddwhR = zeros(3,n,n);
ddwuL = zeros(3,n,n);
ddwlL = zeros(3,n,n);
ddwhL = zeros(3,n,n);
ddwc = zeros(3,n,n);

ddwuR(:,2,:) = m3times(dR1(q),xhat);
ddwuR(:,3,:) = m3times(dR2(q),yhat);
ddwuR(:,4,:) = m3times(dR3(q),zhat);

ddwlR(:,2,:) = ddwuR(:,2,:);
ddwlR(:,3,:) = ddwuR(:,3,:);
ddwlR(:,4,:) = ddwuR(:,4,:);
ddwlR(:,5,:) = m3times(dR4(q),xhat);
ddwlR(:,6,:) = m3times(dR5(q),zhat);

ddwhR(:,2,:) = ddwlR(:,2,:);
ddwhR(:,3,:) = ddwlR(:,3,:);
ddwhR(:,4,:) = ddwlR(:,4,:);
ddwhR(:,5,:) = ddwlR(:,5,:);
ddwhR(:,6,:) = ddwlR(:,6,:);
ddwhR(:,7,:) = m3times(dR6(q),yhat);
ddwhR(:,8,:) = m3times(dR7(q),xhat);

ddwuL(:,9,:) = m3times(dR1(q),yhat);
ddwuL(:,10,:) = m3times(dR9(q),xhat);
ddwuL(:,11,:) = m3times(dR10(q),zhat);

ddwlL(:,9,:) = ddwuL(:,9,:);
ddwlL(:,10,:) = ddwuL(:,10,:);
ddwlL(:,11,:) = ddwuL(:,11,:);
ddwlL(:,12,:) = m3times(dR11(q),yhat);
ddwlL(:,13,:) = m3times(dR12(q),zhat);

ddwhL(:,9,:) = ddwlL(:,9,:);
ddwhL(:,10,:) = ddwlL(:,10,:);
ddwhL(:,11,:) = ddwlL(:,11,:);
ddwhL(:,12,:) = ddwlL(:,12,:);
ddwhL(:,13,:) = ddwlL(:,13,:);
ddwhL(:,14,:) = m3times(dR13(q),xhat);
ddwhL(:,15,:) = m3times(dR14(q),yhat);

ddwc(:,16,:) = m3times(dR1(q),Rz(-pi/4)*xhat);
ddwc(:,17,:) = m3times(dR16(q),zhat);


%% Jacobians for velocities
% Joint positions
ddrbR = d2R1(q,rbR_hat);
ddreR = ddrbR + d2R4(q,ruR_hat);
ddrwR = ddreR + d2R6(q,rlR_hat);
ddrbL = d2R1(q,rbL_hat);
ddreL = ddrbL + d2R11(q,ruL_hat);
ddrwL = ddreL + d2R13(q,rlL_hat);
ddrn = d2R1(q,rn_hat);

% COM positions
ddrb = d2R1(q,rbc_hat);
ddruR = ddrbR + d2R4(q,rucR_hat);
ddrlR = ddreR + d2R6(q,rlcR_hat);
ddrhR = ddrwR + d2R8(q,rhcR_hat);
ddruL = ddrbL + d2R11(q,rucL_hat);
ddrlL = ddreL + d2R13(q,rlcL_hat);
ddrhL = ddrwL + d2R15(q,rhcL_hat);
ddrc = ddrn + d2R17(q,rcc_hat);


%% Jacobian matrix
dJr = [ddrb(:,:,i);
    ddruR(:,:,i);
    ddrlR(:,:,i);
    ddrhR(:,:,i);
    ddruL(:,:,i);
    ddrlL(:,:,i);
    ddrhL(:,:,i);
    ddrc(:,:,i)];
dJw = [ddwb(:,:,i);
    ddwuR(:,:,i);
    ddwlR(:,:,i);
    ddwhR(:,:,i);
    ddwuL(:,:,i);
    ddwlL(:,:,i);
    ddwhL(:,:,i);
    ddwc(:,:,i)];
x = [dJr;dJw];