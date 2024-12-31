function de = dx2de(dx,e)

dxR = dx(4:5);
dxL = dx(9:10);
dxC = dx(11:12);

phiR = e(1);
thetaR = e(2);
phiL = e(3);
thetaL = e(4);
phiC = e(5);
thetaC = e(6);

% deR = (Pyz*[dRz(phiR)*Rx(thetaR)*rsR_hat Rz(phiR)*dRx(thetaR)*rsR_hat])\dxR;
% deL = (Pyz*[dRz(phiL)*Ry(thetaL)*rsL_hat Rz(phiL)*dRy(thetaL)*rsL_hat])\dxL;
% deC = (Pyz*[dRz(phiC)*Rx(thetaC)*rc_hat Rz(phiC)*dRx(thetaC)*rc_hat])\dxC;

dRR = [dRz(phiR)*Rx(thetaR)*dphiR Rz(phiR)*dRx(thetaR)*rsR_hat])\dxR;
deL = (Pyz*[dRz(phiL)*Ry(thetaL)*rsL_hat Rz(phiL)*dRy(thetaL)*rsL_hat])\dxL;
deC = (Pyz*[dRz(phiC)*Rx(thetaC)*rc_hat Rz(phiC)*dRx(thetaC)*rc_hat])\dxC;

de = [deR;deL;deC];