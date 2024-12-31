tC = 0.02;
r = 0.*pi/tC;

dx0 = [0.0143;0.0861;-2.0281];
x0 = [0.3031;0.5252;-0.3481];
xT = dx0/(pi/tC) + x0;

T = 0.0001;
L = 1000;
t = 0:T:T*(L-1);

d2x = zeros(3,L);
dx = zeros(3,L);
x = zeros(3,L);
for k = 1:L
    [d2x(:,k),dx(:,k),x(:,k)] = vi(t(k),tC,r,dx0,x0,xT);
end

figure;
plot(t,x(3,:));