function c = liftDamping(vq,hq)

v = 5:15:65;            % Initial velocity [rad/s]
h = pi/180*(15:30:135); % Reach [rad]
C = [139 480 736 920 1053;
    16 61 102 138 171;
    6 23 38 53 67;
    3 12 20 28 35;
    2 7 12 18 22];

[V,H] = meshgrid(v,h);
c = interp2(V,H,C,vq,hq,'makima');