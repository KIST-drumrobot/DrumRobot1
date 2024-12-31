function b = jointConAccPenalty(qmin,qmax,q,s)
r = qmax - qmin;
qbmax = qmax - s*r;
qbmin = qmin + s*r;

% Quadratic Bezier
p = 1;
X = [0 0 p];
if q <= qbmax && q >= qbmin
    b = 0;
else
    if q > qbmax
        b = B(q-qbmax,qmax-qbmax,X);
    elseif q < qbmin
        b = B(qbmin-q,qbmin-qmin,X);
    end
end

% Test function
% qmin = pi/180*-90;
% qmax = pi/180*10;
% qm = pi/180*-10;
% 
% s = 0.1;
% r = qmax - qmin;
% qbmax = qmax - s*r;
% qbmin = qmin + s*r;
% 
% q = (qmin-0.1):0.001:(qmax+0.1);
% L = length(q);
% 
% b = zeros(1,L);
% p = 1;
% X = [0 0 p];
% for k = 1:L
%     if q(k) <= qbmax && q(k) >= qbmin
%         b(k) = 0;
%     else
%         if q(k) > qbmax
%             b(k) = B(q(k)-qbmax,qmax-qbmax,X);
%         elseif q(k) < qbmin
%             b(k) = B(qbmin-q(k),qbmin-qmin,X);
%         end
%     end
% end
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
