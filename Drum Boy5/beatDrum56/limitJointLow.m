function dw = limitJointLow(q)
% Cost function to be minimized:
% w = 1/(2*n)*\sum_{i = 1}^n*(q(i)-qm(i))^2/((qmax(i)-qmin(i))^2);
global qmin qmax qm
n = length(q);

k0 = 2000;
K0 = k0*eye(n);
dw = zeros(n,1);
% for i = 1:n
%     dw(i) = 2*k0/n*(q(i)-qm(i))/((qmax(i)-qmin(i))^2);
% end

qMin = zeros(n,1);
qMax = zeros(n,1);
qMin(6) = pi/180*-20;
qMax(6) = pi/180*20;
qMin(13) = -qMin(6);
qMax(13) = -qMax(6);

for i = 1:n 
    if i == 6 || i == 13
        if q(i) - qm(i) < 0
            dw(i) = -1/n*(q(i)-qm(i))/((qMin(i)-qm(i))^2);
        else
            dw(i) = -1/n*(q(i)-qm(i))/((qMax(i)-qm(i))^2);
        end
    end
end
% K0(7,7) = 10*k0;
% K0(14,14) = 10*k0;
dw = K0*dw;