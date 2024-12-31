function iSwing = swingTime(iSwing0,xT,dxi,xi)
global T

% iSwing = T/4*abs((xT-xi)/(dxi*xi));
iSwing = floor(abs((xT-xi)/dxi)/T);
iSwing = min(iSwing,iSwing0);