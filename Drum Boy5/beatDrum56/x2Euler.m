function e = x2Euler(q)

RR = R8(q);
RL = R15(q);
RC = R17(q);

[phiR,thetaR] = Rzx2phiTheta(RR);
[phiL,thetaL] = Rzy2phiTheta(RL);
[phiC,thetaC] = R2phiThetaHead(RC);

e = [phiR;thetaR;phiL;thetaL;phiC;thetaC];