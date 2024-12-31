function x = saturation(x,xn,d)

if x <= xn-d
    x = xn-d;
elseif x >= xn+d
    x = xn+d;
end