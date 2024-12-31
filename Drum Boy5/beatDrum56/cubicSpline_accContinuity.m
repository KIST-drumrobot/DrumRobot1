function [d2q,dq,q] = cubicSpline_accContinuity(t,t6,t4,dq1,dq6,q1,q6,q4)
global T
%% Control variables
t1 = 0;
ds = max(round(((t4 - t1)/32)/T)*T,T);

t2 = t1 + ds;
t3 = t4 - ds;
t5 = t6 - ds;

d2q1 = 0;
d2q6 = 0;


%% Time intervals
dt1 = t2 - t1;
dt2 = t3 - t2;
dt3 = t4 - t3;
dt4 = t5 - t4;
dt5 = t6 - t5;


%% Parameter computation
% x = [a2 a3 a4 a5 q2 q3 q5]';
A = zeros(7,7);
A(1,:) = [1/3*(dt2+dt1) dt2/6 0 0 (1/dt2+1/dt1) -1/dt2 0];
A(2,:) = [dt2/6 1/3*(dt3+dt2) dt3/6 0 -1/dt2 (1/dt3+1/dt2) 0];
A(3,:) = [0 dt3/6 dt3/3 0 0 -1/dt3 0];
A(4,:) = [0 0 -dt4/3 -dt4/6 0 0 1/dt4];
A(5,:) = [0 0 dt4/6 1/3*(dt5+dt4) 0 0 (1/dt5+1/dt4)];
A(6,:) = [-dt1/6 0 0 0 1/dt1 0 0];
A(7,:) = [0 0 0 dt5/6 0 0 -1/dt5];

b = zeros(7,1);
b(1) = 1/dt1*q1-dt1/6*d2q1;
b(2) = 1/dt3*q4;
b(3) = -1/dt3*q4;
b(4) = 1/dt4*q4;
b(5) = 1/dt5*q6+1/dt4*q4;
b(6) = dq1+1/dt1*q1+dt1/3*d2q1;
b(7) = dq6-1/dt5*q6-dt5/3*d2q6;

x = A\b;


%% Trajectory generation
if t >= t1 && t < t2
    q = d2q1/(6*dt1)*(t2-t)^3 + x(1)/(6*dt1)*(t-t1)^3 + ...
        (x(5)/dt1-dt1*x(1)/6)*(t-t1) + (q1/dt1-dt1*d2q1/6)*(t2-t);
    dq = -d2q1/(2*dt1)*(t2-t)^2 + x(1)/(2*dt1)*(t-t1)^2 + ...
        (x(5)/dt1-dt1*x(1)/6) - (q1/dt1-dt1*d2q1/6);
    d2q = d2q1/dt1*(t2-t) + x(1)/dt1*(t-t1);
elseif t >= t2 && t < t3
    q = x(1)/(6*dt2)*(t3-t)^3 + x(2)/(6*dt2)*(t-t2)^3 + ...
        (x(6)/dt2-dt2*x(2)/6)*(t-t2) + (x(5)/dt2-dt2*x(1)/6)*(t3-t);
    dq = -x(1)/(2*dt2)*(t3-t)^2 + x(2)/(2*dt2)*(t-t2)^2 + ...
        (x(6)/dt2-dt2*x(2)/6) - (x(5)/dt2-dt2*x(1)/6);
    d2q = x(1)/dt2*(t3-t) + x(2)/dt2*(t-t2);
elseif t >= t3 && t < t4
    q = x(2)/(6*dt3)*(t4-t)^3 + x(3)/(6*dt3)*(t-t3)^3 + ...
        (q4/dt3-dt3*x(3)/6)*(t-t3) + (x(6)/dt3-dt3*x(2)/6)*(t4-t);
    dq = -x(2)/(2*dt3)*(t4-t)^2 + x(3)/(2*dt3)*(t-t3)^2 + ...
        (q4/dt3-dt3*x(3)/6) - (x(6)/dt3-dt3*x(2)/6);
    d2q = x(2)/dt3*(t4-t) + x(3)/dt3*(t-t3);
elseif t >= t4 && t < t5
    q = x(3)/(6*dt4)*(t5-t)^3 + x(4)/(6*dt4)*(t-t4)^3 + ...
        (x(7)/dt4-dt4*x(4)/6)*(t-t4) + (q4/dt4-dt4*x(3)/6)*(t5-t);
    dq = -x(3)/(2*dt4)*(t5-t)^2 + x(4)/(2*dt4)*(t-t4)^2 + ...
        (x(7)/dt4-dt4*x(4)/6) - (q4/dt4-dt4*x(3)/6);
    d2q = x(3)/dt4*(t5-t) + x(4)/dt4*(t-t4);
else
    q = x(4)/(6*dt5)*(t6-t)^3 + d2q6/(6*dt5)*(t-t5)^3 + ...
        (q6/dt5-dt5*d2q6/6)*(t-t5) + (x(7)/dt5-dt5*x(4)/6)*(t6-t);
    dq = -x(4)/(2*dt5)*(t6-t)^2 + d2q6/(2*dt5)*(t-t5)^2 + ...
        (q6/dt5-dt5*d2q6/6) - (x(7)/dt5-dt5*x(4)/6);
    d2q = x(4)/dt5*(t6-t) + d2q6/dt5*(t-t5);
end