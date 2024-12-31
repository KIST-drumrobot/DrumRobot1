function x = Kz(k,qmax,qmin,qm,q)

x = zeros(3,3);
% k = 5e-6;
% x(3,3) = k*abs(q);
% k = 5e-5;
% x(3,3) = k*q^2;

if q > qm
    r = (q-qm)/(qmax-qm);
else
    r = (q-qm)/(qmin-qm);
end
x(3,3) = k*r^2;