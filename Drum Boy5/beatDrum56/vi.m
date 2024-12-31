function [d2x,dx,x] = vi(t,tC,zeta,dx0,x0,xT)

wn = pi/tC; % Natural frequency
wd = wn*sqrt(1 - zeta^2);

xO = x0 - xT;   % Initial point offset

x = exp(-zeta*wn*t)*(xO*cos(wd*t) + ((dx0 + zeta*wn*xO)/wd)*sin(wd*t)) + xT;
dx = -zeta*wn*exp(-zeta*wn*t)*(xO*cos(wd*t) + ((dx0 + zeta*wn*xO)/wd)*sin(wd*t)) + ...
    exp(-zeta*wn*t)*(-wd*xO*sin(wd*t) + (dx0 + zeta*wn*xO)*cos(wd*t));
d2x = (-zeta*wn)^2*exp(-zeta*wn*t)*(xO*cos(wd*t) + ((dx0 + zeta*wn*xO)/wd)*sin(wd*t)) + ...
    -zeta*wn*exp(-zeta*wn*t)*(-wd*xO*sin(wd*t) + (dx0 + zeta*wn*xO)*cos(wd*t)) + ...
    -zeta*wn*exp(-zeta*wn*t)*(-wd*xO*sin(wd*t) + wd*((dx0 + zeta*wn*xO)/wd)*cos(wd*t)) + ...
    exp(-zeta*wn*t)*(-wd^2*xO*cos(wd*t) + -wd*(dx0 + zeta*wn*xO)*sin(wd*t));