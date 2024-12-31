function r = RS(phi,theta,h)
% stick rotation matrix
if h == "R"
    r = Rz(phi)*Rx(theta);
%     r = Ry(phi)*Rx(theta);
%     r = Rx(theta)*Rz(phi);
elseif h == "L"
    r = Rz(phi)*Ry(theta);
%     r = Rx(phi)*Ry(theta);
%     r = Ry(theta)*Rz(phi);
end