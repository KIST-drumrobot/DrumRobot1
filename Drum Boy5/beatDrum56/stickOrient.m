function phiT = stickOrient(rT,rb_hat,q,h)
g = .5;
b = atan2(rT(2),rT(1)) - pi/4;
rb = Rz(g*b+(1-g)*q(1))*rb_hat;     % vector from center to shoulder: 
% **g*b+(1-g)*q(1) = the rational sum of the angle at which the robot will 
% face head-on and the initial angle of the body
rbT = rT - rb;                      % vector from shoulder to target drum
if h == "R"
    phiT = atan2(-rbT(1),rbT(2));
elseif h == "L"
    phiT = atan2(rbT(2),rbT(1));
end