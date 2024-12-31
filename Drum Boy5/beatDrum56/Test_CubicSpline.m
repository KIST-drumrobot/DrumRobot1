clear
close all
clc

tp = [0 1 5 7 10];
p = [1 10 -4 8 1];
theta = zeros(1,5);
theta(2) = 10;
theta(3) = 10;

T = 0.001;
t = 0:T:tp(end);
L = length(t);
x = zeros(1,L);
for k = 1:L
% 	x(k) = CubicSpline((k-1)*T,tp,p);
    x(k) = CubicSpline2((k-1)*T,tp,p,theta);
end

figure;
plot(tp,p,'ko','MarkerSize',6);
hold on;
plot(t,x);
xlabel('Time [s]');
ylabel('Position [m]');
grid on;