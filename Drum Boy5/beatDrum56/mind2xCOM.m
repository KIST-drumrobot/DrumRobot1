function x = mind2xCOM(d2q,dq,q)
global g xhat yhat zhat
global mb mu ml mh mc Ib_hat IuR_hat IlR_hat IhR_hat IuL_hat IlL_hat IhL_hat Ic_hat
global rbR_hat ruR_hat rlR_hat rbL_hat ruL_hat rlL_hat rn_hat rc_hat
global rbc_hat rucR_hat rlcR_hat rhcR_hat rucL_hat rlcL_hat rhcL_hat rcc_hat
n = length(q);


%% Positions
% Joint positions
rbR = R1(q)*rbR_hat;
reR = rbR + R4(q)*ruR_hat;
rwR = reR + R6(q)*rlR_hat;
rbL = R1(q)*rbL_hat;
reL = rbL + R11(q)*ruL_hat;
rwL = reL + R13(q)*rlL_hat;
rn = R1(q)*rn_hat;

% COM positions
rb = R1(q)*rbc_hat;
ruR = rbR + R4(q)*rucR_hat;
rlR = reR + R6(q)*rlcR_hat;
rhR = rwR + R8(q)*rhcR_hat;
ruL = rbL + R11(q)*rucL_hat;
rlL = reL + R13(q)*rlcL_hat;
rhL = rwL + R15(q)*rhcL_hat;
rc = rn + R17(q)*rcc_hat;


%% Angular velocities
wb = zhat*dq(1);
wuR = wb + R1(q)*xhat*dq(2) + R2(q)*yhat*dq(3) + R3(q)*zhat*dq(4);
wlR = wuR + R4(q)*xhat*dq(5) + R5(q)*zhat*dq(6);
whR = wlR + R6(q)*yhat*dq(7) + R7(q)*xhat*dq(8);
wuL = wb + R1(q)*yhat*dq(9) + R9(q)*xhat*dq(10) + R10(q)*zhat*dq(11);
wlL = wuL + R11(q)*yhat*dq(12) + R12(q)*zhat*dq(13);
whL = wlL + R13(q)*xhat*dq(14) + R14(q)*yhat*dq(15);
wc = wb + R1(q)*Rz(-pi/4)*xhat*dq(16) + R16(q)*zhat*dq(17);


%% Velocities
% Joint velocities
drbR = cross(wb,rbR);
dreR = drbR + cross(wuR,reR-rbR);
drwR = dreR + cross(wlR,rwR-reR);
drbL = cross(wb,rbL);
dreL = drbL + cross(wuL,reL-rbL);
drwL = dreL + cross(wlL,rwL-reL);
drn = cross(wb,rn);

% COM velocities
drb = cross(wb,rb);
druR = drbR + cross(wuR,ruR-rbR);
drlR = dreR + cross(wlR,rlR-reR);
drhR = drwR + cross(whR,rhR-rwR);
druL = drbL + cross(wuL,ruL-rbL);
drlL = dreL + cross(wlL,rlL-reL);
drhL = drwL + cross(whL,rhL-rwL);
drc = drn + cross(wc,rc-rn);


%% Angular accelerations
dwb = zhat*d2q(1);
dwuR = dwb + m3times(dR1(q),xhat)*dq*dq(2) + m3times(dR2(q),yhat)*dq*dq(3) + m3times(dR3(q),zhat)*dq*dq(4) + R1(q)*xhat*d2q(2) + R2(q)*yhat*d2q(3) + R3(q)*zhat*d2q(4);
dwlR = dwuR + m3times(dR4(q),xhat)*dq*dq(5) + m3times(dR5(q),zhat)*dq*dq(6) + R4(q)*xhat*d2q(5) + R5(q)*zhat*d2q(6);
dwhR = dwlR + m3times(dR6(q),yhat)*dq*dq(7) + m3times(dR7(q),xhat)*dq*dq(8) + R6(q)*yhat*d2q(7) + R7(q)*xhat*d2q(8);
dwuL = dwb + m3times(dR1(q),yhat)*dq*dq(9) + m3times(dR9(q),xhat)*dq*dq(10) + m3times(dR10(q),zhat)*dq*dq(11) + R1(q)*yhat*d2q(9) + R9(q)*xhat*d2q(10) + R10(q)*zhat*d2q(11);
dwlL = dwuL + m3times(dR11(q),yhat)*dq*dq(12) + m3times(dR12(q),zhat)*dq*dq(13) + R11(q)*yhat*d2q(12) + R12(q)*zhat*d2q(13);
dwhL = dwlL + m3times(dR13(q),xhat)*dq*dq(14) + m3times(dR14(q),yhat)*dq*dq(15) + R13(q)*xhat*d2q(14) + R14(q)*yhat*d2q(15);
dwc = dwb + dRz(q(1))*Rz(-pi/4)*xhat*dq(1)*dq(16) + m3times(dR16(q),zhat)*dq*dq(17) + R1(q)*Rz(-pi/4)*xhat*d2q(16) + R16(q)*zhat*d2q(17);


%% Accelerations
% Joint accelerations
d2rbR = cross(dwb,rbR) + cross(wb,drbR);
d2reR = d2rbR + cross(dwuR,reR-rbR) + cross(wuR,dreR-drbR);
d2rwR = d2reR + cross(dwlR,rwR-reR) + cross(wlR,drwR-dreR);
d2rbL = cross(dwb,rbL) + cross(wb,drbL);
d2reL = d2rbL + cross(dwuL,reL-rbL) + cross(wuL,dreL-drbL);
d2rwL = d2reL + cross(dwlL,rwL-reL) + cross(wlL,drwL-dreL);
d2rn = cross(dwb,rn) + cross(wb,drn);

% COM accelerations
d2rb = cross(dwb,rb) + cross(wb,drb);
d2ruR = d2rbR + cross(dwuR,ruR-rbR) + cross(wuR,druR-drbR);
d2rlR = d2reR + cross(dwlR,rlR-reR) + cross(wlR,drlR-dreR);
d2rhR = d2rwR + cross(dwhR,rhR-rwR) + cross(whR,drhR-drwR);
d2ruL = d2rbL + cross(dwuL,ruL-rbL) + cross(wuL,druL-drbL);
d2rlL = d2reL + cross(dwlL,rlL-reL) + cross(wlL,drlL-dreL);
d2rhL = d2rwL + cross(dwhL,rhL-rwL) + cross(whL,drhL-drwL);
d2rc = d2rn + cross(dwc,rc-rn) + cross(wc,drc-drn);


%% Total COM acceleration
d2xCOM = 1/((mu + ml + mh)*2 + mc)*(mu*d2ruR + ml*d2rlR + mh*d2rhR + mu*d2ruL + ml*d2rlL + mh*d2rhL + mc*d2rc);
w = d2xCOM'*d2xCOM;


%% Jacobians
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

% Angular velocities
dwbdq = zeros(3,n);
dwuRdq = dwbdq + m3times(dR1(q),xhat)*dq(2) + m3times(dR2(q),yhat)*dq(3) + m3times(dR3(q),zhat)*dq(4);
dwlRdq = dwuRdq + m3times(dR4(q),xhat)*dq(5) + m3times(dR5(q),zhat)*dq(6);
dwhRdq = dwlRdq + m3times(dR6(q),yhat)*dq(7) + m3times(dR7(q),xhat)*dq(8);
dwuLdq = dwbdq + m3times(dR1(q),yhat)*dq(9) + m3times(dR9(q),xhat)*dq(10) + m3times(dR10(q),zhat)*dq(11);
dwlLdq = dwuLdq + m3times(dR11(q),yhat)*dq(12) + m3times(dR12(q),zhat)*dq(13);
dwhLdq = dwlLdq + m3times(dR13(q),xhat)*dq(14) + m3times(dR14(q),yhat)*dq(15);
dwcdq = dwbdq + m3times(dR16(q),zhat)*dq(17);
dwcdq(:,1) = dwcdq(:,1) + dRz(q(1))*Rz(-pi/4)*xhat*dq(16);

% Joint velocities
ddrbRdq = crossM(dwbdq,rbR) + crossM(wb,drbRdq);
ddreRdq = ddrbRdq + crossM(dwuRdq,reR-rbR) + crossM(wuR,dreRdq-drbRdq);
ddrwRdq = ddreRdq + crossM(dwlRdq,rwR-reR) + crossM(wlR,drwRdq-dreRdq);
ddrbLdq = crossM(dwbdq,rbL) + crossM(wb,drbLdq);
ddreLdq = ddrbLdq + crossM(dwuLdq,reL-rbL) + crossM(wuL,dreLdq-drbLdq);
ddrwLdq = ddreLdq + crossM(dwlLdq,rwL-reL) + crossM(wlL,drwLdq-dreLdq);
ddrndq = crossM(dwbdq,rn) + crossM(wb,drndq);

% COM velocities
ddrbdq = crossM(dwbdq,rb) + crossM(wb,drbdq);
ddruRdq = ddrbRdq + crossM(dwuRdq,ruR-rbR) + crossM(wuR,druRdq-drbRdq);
ddrlRdq = ddreRdq + crossM(dwlRdq,rlR-reR) + crossM(wlR,drlRdq-dreRdq);
ddrhRdq = ddrwRdq + crossM(dwhRdq,rhR-rwR) + crossM(whR,drhRdq-drwRdq);
ddruLdq = ddrbLdq + crossM(dwuLdq,ruL-rbL) + crossM(wuL,druLdq-drbLdq);
ddrlLdq = ddreLdq + crossM(dwlLdq,rlL-reL) + crossM(wlL,drlLdq-dreLdq);
ddrhLdq = ddrwLdq + crossM(dwhLdq,rhL-rwL) + crossM(whL,drhLdq-drwLdq);
ddrcdq = ddrndq + crossM(dwcdq,rc-rn) + crossM(wc,drcdq-drndq);

% Angular accelerations
ddwbdq = zeros(3,n);
ddwuRdq = ddwbdq + m3times(d2R1(q,xhat),dq)*dq(2) + m3times(d2R2(q,yhat),dq)*dq(3) + m3times(d2R3(q,zhat),dq)*dq(4) + m3times(dR1(q),xhat)*d2q(2) + m3times(dR2(q),yhat)*d2q(3) + m3times(dR3(q),zhat)*d2q(4); 
ddwlRdq = ddwuRdq + m3times(d2R4(q,xhat),dq)*dq(5) + m3times(d2R5(q,zhat),dq)*dq(6) + m3times(dR4(q),xhat)*d2q(5) + m3times(dR5(q),zhat)*d2q(6);
ddwhRdq = ddwlRdq + m3times(d2R6(q,yhat),dq)*dq(7) + m3times(d2R7(q,xhat),dq)*dq(8) + m3times(dR6(q),yhat)*d2q(7) + m3times(dR7(q),xhat)*d2q(8);
ddwuLdq = ddwbdq + m3times(d2R1(q,yhat),dq)*dq(9) + m3times(d2R9(q,xhat),dq)*dq(10) + m3times(d2R10(q,zhat),dq)*dq(11) + R1(q)*yhat*d2q(9) + R9(q)*xhat*d2q(10) + R10(q)*zhat*d2q(11);
ddwlLdq = ddwuLdq + m3times(d2R11(q,yhat),dq)*dq(12) + m3times(d2R12(q,zhat),dq)*dq(13) + R11(q)*yhat*d2q(12) + R12(q)*zhat*d2q(13);
ddwhLdq = ddwlLdq + m3times(d2R13(q,xhat),dq)*dq(14) + m3times(d2R14(q,yhat),dq)*dq(15) + R13(q)*xhat*d2q(14) + R14(q)*yhat*d2q(15);
ddwcdq = ddwbdq + m3times(d2R16(q,zhat),dq)*dq(17) + R1(q)*Rz(-pi/4)*xhat*d2q(16) + R16(q)*zhat*d2q(17);
ddwcdq(:,1) = ddwbdq(:,1) + d2Rz(q(1))*Rz(-pi/4)*xhat*dq(1)*dq(16);

% Joint accelerations
dd2rbRdq = crossM(ddwbdq,rbR) + crossM(dwbdq,drbR) + crossM(dwb,drbRdq) + crossM(wb,ddrbRdq);
dd2reRdq = dd2rbRdq + crossM(ddwuRdq,reR-rbR) + crossM(dwuRdq,dreR-drbR) + crossM(dwuR,dreRdq-drbRdq) + crossM(wuR,ddreRdq-ddrbRdq);
dd2rwRdq = dd2reRdq + crossM(ddwlRdq,rwR-reR) + crossM(dwlRdq,drwR-dreR) + crossM(dwlR,drwRdq-dreRdq) + crossM(wlR,ddrwRdq-ddreRdq);
dd2rbLdq = crossM(ddwbdq,rbL) + crossM(dwbdq,drbL) + crossM(dwb,drbLdq) + crossM(wb,ddrbLdq);
dd2reLdq = dd2rbLdq + crossM(ddwuLdq,reL-rbL) + crossM(dwuLdq,dreL-drbL) + crossM(dwuL,dreLdq-drbLdq) + crossM(wuL,ddreLdq-ddrbLdq);
dd2rwLdq = dd2reLdq + crossM(ddwlLdq,rwL-reL) + crossM(dwlLdq,drwL-dreL) + crossM(dwlL,drwLdq-dreLdq) + crossM(wlL,ddrwLdq-ddreLdq);
dd2rndq = crossM(ddwbdq,rn) + crossM(dwbdq,drn) + crossM(dwb,drndq) + crossM(wb,ddrndq);

% COM accelerations
dd2rbdq = crossM(ddwbdq,rb) + crossM(dwbdq,drb) + crossM(dwb,drbdq) + crossM(wb,ddrbdq);
dd2ruRdq = dd2rbRdq + crossM(ddwuRdq,ruR-rbR) + crossM(dwuRdq,druR-drbR) + crossM(dwuR,druRdq-drbRdq) + crossM(wuR,ddruRdq-ddrbRdq);
dd2rlRdq = dd2reRdq + crossM(ddwlRdq,rlR-reR) + crossM(dwlRdq,drlR-dreR) + crossM(dwlR,drlRdq-dreRdq) + crossM(wlR,ddrlRdq-ddreRdq);
dd2rhRdq = dd2rwRdq + crossM(ddwhRdq,rhR-rwR) + crossM(dwhRdq,drhR-drwR) + crossM(dwhR,drhRdq-drwRdq) + crossM(whR,ddrhRdq-ddrwRdq);
dd2ruLdq = dd2rbLdq + crossM(ddwuLdq,ruL-rbL) + crossM(dwuLdq,druL-drbL) + crossM(dwuL,druLdq-drbLdq) + crossM(wuL,ddruLdq-ddrbLdq);
dd2rlLdq = dd2reLdq + crossM(ddwlLdq,rlL-reL) + crossM(dwlLdq,drlL-dreL) + crossM(dwlL,drlLdq-dreLdq) + crossM(wlL,ddrlLdq-ddreLdq);
dd2rhLdq = dd2rwLdq + crossM(ddwhLdq,rhL-rwL) + crossM(dwhLdq,drhL-drwL) + crossM(dwhL,drhLdq-drwLdq) + crossM(whL,ddrhLdq-ddrwLdq);
dd2rcdq = dd2rndq + crossM(ddwcdq,rc-rn) + crossM(dwcdq,drc-drn) + crossM(dwc,drcdq-drndq) + crossM(wc,ddrcdq-ddrndq);

% Total COM acceleration
dd2xCOMdq = 1/((mu + ml + mh)*2 + mc)*(mu*dd2ruRdq + ml*dd2rlRdq + mh*dd2rhRdq + mu*dd2ruLdq + ml*dd2rlLdq + mh*dd2rhLdq + mc*dd2rcdq);


%% Null space joint velocities
k0 = 1e-4;
x = -2*k0*dd2xCOMdq'*d2xCOM;