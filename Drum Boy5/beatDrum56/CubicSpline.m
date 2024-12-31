function x = CubicSpline(t,tp,p)
n = length(p);

A = zeros(n,n);
b = zeros(n,1);


%% Find tangents
A(1,1) = 2;
A(n,n) = A(1,1);
A(1,2) = 1;
A(n,n-1) = A(1,2);
b(1) = 3*(p(2) - p(1));
b(n) = 3*(p(n) - p(n-1));
for k = 2:n-1
    A(k,k-1) = 1;
    A(k,k+1) = 1;
    A(k,k) = 4;
    b(k) = 3*(p(k+1) - p(k-1));
end
Theta = A\b;


%% Draw cubic spline
for i = 1:n-1
    if t >= tp(i)
        k = i;
    else
        break;
    end
end

a = p(k);
d = p(k+1);
b = p(k) + Theta(k)/3*(tp(k+1)-tp(k));
c = p(k+1) - Theta(k+1)/3*(tp(k+1)-tp(k));
X = [a b c d];
x = B(t-tp(k),tp(k+1)-tp(k),X);