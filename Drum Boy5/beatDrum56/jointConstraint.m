function x = jointConstraint(dq,q)
global n qm

 b = jointPenalty(q,0.5,'qb');

 x = eye(n);
 for i = 1:n
     if (q(i) - qm(i))*dq(i) > 0    % Note: "=" makes q(i) stuck in the limit
         x(i,i) = 1 - b(i);
     else
         x(i,i) = 1;
     end
 end