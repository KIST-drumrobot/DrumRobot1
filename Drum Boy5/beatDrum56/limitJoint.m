function dw = limitJoint(q)
% Cost function to be minimized:
% w = 1/(2*n)*\sum_{i = 1}^n*(q(i)-qm(i))^2/((qmax(i)-qmin(i))^2);
global qmin qmax qm
n = length(q);


%% Conventional
k0 = 10;
dw = zeros(n,1);
for i = 1:n
    dw(i) = 2*k0/n*(q(i)-qm(i))/((qmax(i)-qmin(i))^2);
end
%% Ver. 1
% K0 = k0*eye(n);
% for i = 1:n 
%     if q(i) - qm(i) < 0
%         dw(i) = -1/n*(q(i)-qm(i))/((qmin(i)-qm(i))^2);
%     else
%         dw(i) = -1/n*(q(i)-qm(i))/((qmax(i)-qm(i))^2);
%     end
% end
% dw = K0*dw;
%% Ver. 2
% w = -k0/2*sum((q-q0)^2)
s = 0.2;
k0 = 100;
dw = zeros(n,1);
for i = 1:n
    if q(i) >= qm(i)
        q0 = qmax(i) + s*(qm(i)-qmax(i));

        if q(i) >= q0
            dw(i) = -k0*(q(i)-q0);
        else
            dw(i) = 0;
        end
    else
        q0 = qmin(i) + s*(qm(i)-qmin(i));

        if q(i) < q0
            dw(i) = -k0*(q(i)-q0);
        else
            dw(i) = 0;
        end
    end
end

