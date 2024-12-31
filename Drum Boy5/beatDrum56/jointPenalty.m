function b = jointPenalty(q,s,mode)
global qm qmin qmax n

b = zeros(n,1);

if mode == "qb"
    % Quadratic Bezier
    X = [0 0 1];
    for i = 1:n 
        if q(i) <= qm(i) + s*(qmax(i) - qm(i)) && q(i) >= qm(i) - s*(qm(i) - qmin(i))
            b(i) = 0;
        else
            if q(i) > qm(i) + s*(qmax(i) - qm(i))
                b(i) = B(q(i) - (qm(i) + s*(qmax(i) - qm(i))),qmax(i) - (qm(i) + s*(qmax(i) - qm(i))),X);
                if q(i) > qmax(i)
                    b(i) = 1;
                end
            elseif q(i) < qm(i) - s*(qm(i) - qmin(i))
                b(i) = B(qm(i) - s*(qm(i) - qmin(i)) - q(i),(qm(i) - s*(qm(i) - qmin(i))) - qmin(i),X);
                if q(i) < qmin(i)
                    b(i) = 1;
                end
            end
        end
    end
elseif mode == "sm"
    % Sigmoid
    for i = 1:n 
        if q(i) <= qm(i) + s*(qmax(i) - qm(i)) && q(i) >= qm(i) - s*(qm(i) - qmin(i))
            b(i) = 0;
        else
            if q(i) > qm(i) + s*(qmax(i) - qm(i))
                b(i) = sigmoid(q(i) - (qm(i) + s*(qmax(i) - qm(i))),qmax(i) - (qm(i) + s*(qmax(i) - qm(i))));
                if q(i) > qmax(i)
                    b(i) = 1;
                end
            elseif q(i) < qm(i) - s*(qm(i) - qmin(i))
                b(i) = sigmoid(qm(i) - s*(qm(i) - qmin(i)) - q(i),qm(i) - s*(qm(i) - qmin(i)) - qmin(i));
                if q(i) < qmin(i)
                    b(i) = 1;
                end
            end
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
