function dr = dRS(dphi,dtheta,phi,theta,h)
% stick rotation matrix derivative
if h == "R"
    dr = dRz(phi)*Rx(theta)*dphi + Rz(phi)*dRx(theta)*dtheta;
%     dr = dRy(phi)*Rx(theta)*dphi + Ry(phi)*dRx(theta)*dtheta;
%     dr = Rx(theta)*dRz(phi)*dphi + dRx(theta)*Rz(phi)*dtheta;
elseif h == "L"
    dr = dRz(phi)*Ry(theta)*dphi + Rz(phi)*dRy(theta)*dtheta;
%     dr = dRx(phi)*Ry(theta)*dphi + Rx(phi)*dRy(theta)*dtheta;
%     dr = Ry(theta)*dRz(phi)*dphi + dRy(theta)*Rz(phi)*dtheta;
end