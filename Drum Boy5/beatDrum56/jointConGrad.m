function [dh,s] = jointConGrad(qmax,qmin,dq,q)

g = 1000;
r = qmax - qmin;

n1 = r^2;
n2 = 2*q - qmax - qmin;
d1 = qmax - q;
d2 = q - qmin;

dh = n1*n2/(4*g*d1^2*d2^2);
s = dh/abs(dh) * dq*n1*n2/(2*g*d1^2*d2^2)*(1/n2 + 1/d1 - 1/d2);

% Test function
% qmin = pi/180*-90;
% qmax = pi/180*10;
% qm = pi/180*-10;
% q = qmin:0.001:qmax;
% L = length(q);
% 
% H = zeros(1,L);
% g = 10;
% for i = 1:L 
%     r = qmax - qmin;
%     d1 = qmax - q(i);
%     d2 = q(i) - qmin;
%     H(i) = r^2/(4*g*d1*d2);
% end
% 
% set(groot,'defaulttextInterpreter','latex');
% set(groot,'defaultAxesTickLabelInterpreter','latex');
% set(groot,'defaultLegendInterpreter','latex');
% 
% figure('Position',[50 50 1280 360],'Color','w'); 
% plot(q*180/pi,H,'k-','LineWidth',2);
% xlabel('$q_i [deg]$');
% ylabel('$\beta_i$');
% xlim([q(1) q(end)]*180/pi);
% grid on;