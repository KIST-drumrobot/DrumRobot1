function xT = reTarget(iSwing,xT,xi,q,n)

iLim = 200;
v = xT(1:2)-xi(1:2);
d = norm(v);
if iSwing < iLim && d > 0.2
    v = v/d;
    u = R2d(q(1))*[1;0];
%     if v(1)*u(2)-v(2)*u(1) < 0 && v'*u > cos(pi/180*30)
    if v'*u > cos(pi/180*30)
%         iSwing1 = 150;
%         slope = .15/(iSwing1-iLim);
%         yIntercept = 1-slope*iLim;
%         y = slope*iSwing+yIntercept;
%         dmax = .2;.2153;
        d = d-0.2;
        i = iLim-iSwing;
        s = 1/3*sqrt((d/0.2)^2+(i/100)^2);1/3*sqrt((d/0.2)^2+(i/100)^2);
        xT(1:2) = (1+s)*xT(1:2);
%         n
%         i
%         d
%         s
    end
end