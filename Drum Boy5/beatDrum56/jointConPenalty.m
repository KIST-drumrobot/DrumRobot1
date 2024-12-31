function b = jointConPenalty(qmin,qmax,qm,q,s)
qbmax = qm + s*(qmax - qm);
qbmin = qm - s*(qm - qmin);

% Quadratic Bezier
p = 1 - 1e-10;
X = [0 0 p];
if q <= qbmax && q >= qbmin
    b = 0;
else
    if q > qbmax
        b = B(q-qbmax,qmax-qbmax,X);
        if q > qmax
            b = p;
        end
    elseif q < qbmin
        b = B(qbmin-q,qbmin-qmin,X);
        if q < qmin
            b = p;
        end
    end
end

% Test function
% qmin = pi/180*-90;
% qmax = pi/180*10;
% qm = pi/180*-10;
% q = qmin:0.001:qmax;
% L = length(q);
% 
% n = 1;
% i = n;
% s = 0.5;
% b = zeros(1,L);
% X = [0 0 1];
% for k = 1:L 
%     if q(k) <= qm(i) + s*(qmax(i) - qm(i)) && q(k) >= qm(i) - s*(qm(i) - qmin(i))
%         b(k) = 0;
%     else
%         if q(k) > qm(i) + s*(qmax(i) - qm(i))
%             b(k) = B(q(k) - (qm(i) + s*(qmax(i) - qm(i))),qmax(i) - (qm(i) + s*(qmax(i) - qm(i))),X);
%         elseif q(i) < qm(i) - s*(qm(i) - qmin(i))
%             b(k) = B(qm(i) - s*(qm(i) - qmin(i)) - q(k),(qm(i) - s*(qm(i) - qmin(i))) - qmin(i),X);
%         end
%     end
% end
% 
% set(groot,'defaulttextInterpreter','latex');
% set(groot,'defaultAxesTickLabelInterpreter','latex');
% set(groot,'defaultLegendInterpreter','latex');
% 
% figure('Position',[50 50 1280 360],'Color','w'); 
% plot(q*180/pi,b,'k-','LineWidth',2);
% xlabel('$q_i [deg]$');
% ylabel('$\beta_i$');
% xlim([q(1) q(end)]*180/pi);
% grid on;
