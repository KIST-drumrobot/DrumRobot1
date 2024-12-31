function inverseKinematics(Task,tSpan,dataSet)
global T n fIDsave
% dataSet = {dq,q,x,...
%     cntR,xTR,d2xdR,dxdR,xdR,d2xiR,dxiR,xiR,...
%     cntL,xTL,d2xdL,dxdL,xdL,d2xiL,dxiL,xiL,...
%     d2xdC,dxdC,xdC,cntRF,dxiRF,xiRF,cntLF,dxiLF,xiLF,...
%     codeR,codeL,codeRF,codeLF,...
%     iC,Kp,Kd,dmT};
%% Time span transformation
kSpan = round(tSpan/T) + 1;
kS = kSpan(1):kSpan(2);
L = length(kS);
%% Collision check
C = zeros(L-1,2);     % [time distance]
%% Variables (to be saved)
d2q = zeros(n,L);
dq = zeros(n,L);
q = zeros(n,L);
d2xd = zeros(numel(dataSet{3})-2,L);
dxd = zeros(numel(dataSet{3})-2,L);
xd = zeros(numel(dataSet{3}),L);
x = zeros(numel(dataSet{3}),L);

cntR = zeros(numel(dataSet{4}),L);
xTR = zeros(numel(dataSet{5}),L);
d2xdR = zeros(numel(dataSet{6}),L);
dxdR = zeros(numel(dataSet{7}),L);
xdR = zeros(numel(dataSet{8}),L);
d2xiR = zeros(numel(dataSet{9}),L);
dxiR = zeros(numel(dataSet{10}),L);
xiR = zeros(numel(dataSet{11}),L);

cntL = zeros(numel(dataSet{12}),L);
xTL = zeros(numel(dataSet{13}),L);
d2xdL = zeros(numel(dataSet{14}),L);
dxdL = zeros(numel(dataSet{15}),L);
xdL = zeros(numel(dataSet{16}),L);
d2xiL = zeros(numel(dataSet{17}),L);
dxiL = zeros(numel(dataSet{18}),L);
xiL = zeros(numel(dataSet{19}),L);

d2xdC = zeros(numel(dataSet{20}),L);
dxdC = zeros(numel(dataSet{21}),L);
xdC = zeros(numel(dataSet{22}),L);

cntRF = zeros(numel(dataSet{23}),L);
dxiRF = zeros(numel(dataSet{24}),L);
xiRF = zeros(numel(dataSet{25}),L);

cntLF = zeros(numel(dataSet{26}),L);
dxiLF = zeros(numel(dataSet{27}),L);
xiLF = zeros(numel(dataSet{28}),L);
%% Constants
codeR = dataSet{29};
codeL = dataSet{30};
codeRF = dataSet{31};
codeLF = dataSet{32};
iC = dataSet{33};
Kp = dataSet{34};
Kd = dataSet{35};
dmT = dataSet{36};
%% Initialization
dq(:,1) = dataSet{1};
q(:,1) = dataSet{2};
x(:,1) = dataSet{3};
cntR(1) = dataSet{4};
xTR(:,1) = dataSet{5};
d2xdR(:,1) = dataSet{6};
dxdR(:,1) = dataSet{7};
xdR(:,1) = dataSet{8};
d2xiR(:,1) = dataSet{9};
dxiR(:,1) = dataSet{10};
xiR(:,1) = dataSet{11};
cntL(:,1) = dataSet{12};
xTL(:,1) = dataSet{13};
d2xdL(:,1) = dataSet{14};
dxdL(:,1) = dataSet{15};
xdL(:,1) = dataSet{16};
d2xiL(:,1) = dataSet{17};
dxiL(:,1) = dataSet{18};
xiL(:,1) = dataSet{19};
d2xdC(:,1) = dataSet{20};
dxdC(:,1) = dataSet{21};
xdC(:,1) = dataSet{22};
cntRF(:,1) = dataSet{23};
dxiRF(:,1) = dataSet{24};
xiRF(:,1) = dataSet{25};
cntLF(:,1) = dataSet{26};
dxiLF(:,1) = dataSet{27};
xiLF(:,1) = dataSet{28};

xd(:,1) = x(:,1);
dxd(16:17,1) = dq(18:19,1);
%% Inverse kinematics
for k = 1:L-1
    % ------ Task space trajectory ------ %
    %%%%%%%% Arm %%%%%%%%%
    [cntR(k+1),xTR(:,k+1),d2xdR(:,k+1),dxdR(:,k+1),xdR(:,k+1),d2xiR(:,k+1),dxiR(:,k+1),xiR(:,k+1),flR] = ...
        traj(cntR(k),xTR(:,k),d2xdR(:,k),dxdR(:,k),xdR(:,k),d2xiR(:,k),dxiR(:,k),xiR(:,k),...
        q(:,k),kS(k),codeR,dmT,iC,'R');
    [cntL(k+1),xTL(:,k+1),d2xdL(:,k+1),dxdL(:,k+1),xdL(:,k+1),d2xiL(:,k+1),dxiL(:,k+1),xiL(:,k+1),flL] = ...
        traj(cntL(k),xTL(:,k),d2xdL(:,k),dxdL(:,k),xdL(:,k),d2xiL(:,k),dxiL(:,k),xiL(:,k),...
        q(:,k),kS(k),codeL,dmT,iC,'L');

    % Conversion
    [d2xd(1:6,k+1),dxd(1:6,k+1),xd(1:7,k+1)] = trajConv(d2xdR(:,k+1),dxdR(:,k+1),xdR(:,k+1),'R');
    [d2xd(7:12,k+1),dxd(7:12,k+1),xd(8:14,k+1)] = trajConv(d2xdL(:,k+1),dxdL(:,k+1),xdL(:,k+1),'L');

    %%%%%%%% Head %%%%%%%%%
    [d2xdC(:,k+1),dxdC(:,k+1),xdC(:,k+1)] = trajHead(dxdC(:,k),xdC(:,k),q(:,k),kS(k),codeR(cntR(k),end),flR,xTR(end,k+1));
    [d2xd(13:15,k+1),dxd(13:15,k+1),xd(15:18,k+1)] = trajHeadConv(d2xdC(:,k+1),dxdC(:,k+1),xdC(:,k+1));
    
    %%%%%%%% Foot %%%%%%%%%
    [cntRF(k+1),d2xd(16,k+1),dxd(16,k+1),xd(19,k+1),dxiRF(:,k+1),xiRF(:,k+1)] = ...
        trajFoot(cntRF(k),dxiRF(:,k),xiRF(:,k),codeR(cntR(k),end),kS(k),codeRF,'R');
    [cntLF(k+1),d2xd(17,k+1),dxd(17,k+1),xd(20,k+1),dxiLF(:,k+1),xiLF(:,k+1)] = ...
        trajFoot(cntLF(k),dxiLF(:,k),xiLF(:,k),codeR(cntR(k),end),kS(k),codeLF,'L');

    % Error computation
    e = zeros(15,1);
    e(1:3) = xd(1:3,k+1)-x(1:3,k);
    e(4:6) = orientError(x(4:7,k),xd(4:7,k+1));
    e(7:9) = xd(8:10,k+1)-x(8:10,k);
    e(10:12) = orientError(x(11:14,k),xd(11:14,k+1));
    e(13:15) = orientError(x(15:18,k),xd(15:18,k+1));
    de = dxd(1:15,k+1) - J(q(1:17,k))*dq(1:17,k);   % Error derivative    
    % Quadratic programming rate control
    [d2q(1:17,k+1),dq(1:17,k+1),q(1:17,k+1)] = ...
        qprc(Kp,dxd(1:15,k+1),e,dq(1:17,k),q(1:17,k));
    % Quadratic programming acceleration control
%     [d2q(1:17,k+1),dq(1:17,k+1),q(1:17,k+1)] = ...
%         qpac(Kd,Kp,d2xd(1:14,k+1),de,e,dq(1:17,k),q(1:17,k));

    d2q(18:19,k+1) = d2xd(16:17,k+1);
    dq(18:19,k+1) = dxd(16:17,k+1);
    q(18:19,k+1) = xd(19:20,k+1);
    % Forward kinematics
    x(1:18,k+1) = fk(q(1:17,k+1));
    x(19:20,k+1) = q(18:19,k+1);
    % Stick collision check
    rT= fkT(q(:,k+1));
    rW= fkW(q(:,k+1));
    rTR = rT(1:3);
    rTL = rT(4:6);
    rWR = rW(1:3);
    rWL = rW(4:6);
    rSR = rTR - rWR;
    rSL = rTL - rWL;
    uSR = rSR/norm(rSR);
    uSL = rSL/norm(rSL);
    d = cross(uSR,uSL)'*(rTR-rTL);
    C(k,:) = [kS(k)*T d];
    % **d = distance between right and left sticks
    % the less d the closer the sticks

    % Stop IK
    if sum(isnan(q(:,k+1))) > 0    % At least one NaN element exists
        tBreak = k*T
        break;
    end
end
%% Save data
for i = 1:length(fIDsave)
    appendData(Task,fIDsave{i},eval(fIDsave{i}),true);
end
% save(['save\collcheck.txt'],'C','-ascii','-tabs','-append');
figure; plot(C(:,1),C(:,2));