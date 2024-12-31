function x = fk(q)
global rbR_hat ruR_hat rlR_hat rbL_hat ruL_hat rlL_hat

rR = R1(q)*rbR_hat + R4(q)*ruR_hat + R6(q)*rlR_hat;    
rL = R1(q)*rbL_hat + R11(q)*ruL_hat + R13(q)*rlL_hat;
oR = R2quat(R8(q));
oL = R2quat(R15(q));
oC = R2quat(R17(q));

x = [rR;oR;rL;oL;oC];