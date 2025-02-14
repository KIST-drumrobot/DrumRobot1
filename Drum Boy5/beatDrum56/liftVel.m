function [uL,uT] = liftVel(i,iSwing,d,dxT,xT,xi,a,h,float)
% alpha = 2-d vector
global T 
iw = d{1}(end);
is = d{2}(end);
gamma = .144;
alpha = 1-rem(a,1);
SuT = dxT(is);
SuL = -alpha*dxT(is);
Wu1 = (xT(iw)-xi(iw))/(iSwing*T);
% Su1 = dB5(i*T,[xi(is) xi(is) xi(is) xT(is) xT(is) xT(is)]);
Su1 = (xT(is)-xi(is))/(iSwing*T);
Sr = Su1/SuT;
%% Find the stick's apex time ratio
if h == "R"
    h = 1;
elseif h == "L"
    h = -1;
end
if h*Su1 >= 0
    SiL = 1/(1+alpha)*(1-Sr*alpha);
else
    SiL = 1/(1+alpha)*(1-Sr/alpha);
end
SiL = SiL*iSwing;
%% Define the wrist's apex time ratio
WiL = SiL-gamma*iSwing;
iL = round(WiL);        
%% Find the proportional constant for wrist's lift velocity
iSwingr = 150;
hL = sqrt(iSwing/iSwingr)*.03 + abs(xT(iw)-xi(iw));max(0,xT(iw)-xi(iw));
if Wu1 ~= 0
    if Wu1 > 0
        for k = 1:WiL
            iL = iL-1;
            WuL = 2*hL/(iL*T);
            WuT = WuL*iL/(iL-iSwing);
            z = WuT/Wu1*(WiL-iL)/(iSwing-iL)+1;
            if z < 0
                break;
            end
        end
    else
        for k = 1:(iSwing-WiL)
            iL = iL+1;
            WuL = 2*hL/(iL*T);
            WuT = WuL*iL/(iL-iSwing);
            z = WuL/Wu1*(1-WiL/iL)+1;
            if z < 0
                break;
            end
        end
    end
else
    WuL = 2*hL/(iL*T);
    WuT = WuL*iL/(iL-iSwing);
end
uL = [WuL;SuL];
uT = [WuT;SuT];
if float
    uL = exp(-3*iSwing*T)*uL;
end