function dw = maxManipulability(q)
%% No head
% q = q(1:15);
% n = length(q);
% 
% A = Jb(q)*Jb(q)';
% w = sqrt(det(A)); % Manipulability measure
% 
% k0 = 500;
% dw = zeros(n,1);
% for i = 1:n
%     dw(i) = 1/2*k0*w*trace(A\(dJb(q,i)*Jb(q)' + Jb(q)*dJb(q,i)'));
% end
% dw = [dw;0;0];

% Independent of q(1)
% q = q(1:15);
% n = length(q);
% 
% A = Jb(q)*Jb(q)';
% w = sqrt(det(A)); % Manipulability measure
% 
% k0 = 100000;
% dw = zeros(n,1);
% for i = 2:n
%     dw(i) = 1/2*k0*w*trace(A\(dJb(q,i)*Jb(q)' + Jb(q)*dJb(q,i)'));
% end
% dw = [dw;0;0];


%% With head
n = length(q);

A = J(q)*J(q)';
w = sqrt(det(A)); % Manipulability measure

k0 = 10000;
dw = zeros(n,1);
for i = 1:n
    dw(i) = 1/2*k0*w*trace(A\(dJ(q,i)*J(q)' + J(q)*dJ(q,i)'));
end