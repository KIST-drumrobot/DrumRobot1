clear
close all
clc

global T fIDsave
Task = 'solo';
TaskFolderID = fopen('save\taskFolderName.txt');
TaskFolder = fscanf(TaskFolderID,'%s');
[fIDsave,fIDplot] = fileID(TaskFolder);
codeID = fopen(['save\code_',Task,'.txt']);
code = fscanf(codeID,'%s');
setEnvironment(TaskFolder);
%% Input bar span to be simulated
bSpan = [28 30];
%% Data load: initials and constants
dataID = {'dq0','q0','tC','Kp','Kd','nb','md','tQ0','tQ'};
loadData(Task,dataID);
iC = round(tC/T);    % Contact time constant
% Drum code
[codeR,codeL,codeRF,codeLF,codedata] = codeRegen(code,tQ,tQ0,T);
tSpan = b2tSpan(codedata,bSpan)

disp("initializing..");
kStart = round(tSpan(1)/T)+1;
saved = [fIDsave,'tau','b'];
for i = 1:length(saved)
    X = deleteAfter(Task,saved{i},kStart-1);  % Delete data till start point
    assignin('base',saved{i},X(:,end));       % Data at start point
end
dq1 = dq;  
% Drum position
dmT = load('rT.txt');
%% Inverse kinematics
disp("simulating..");
dataSet = {dq,q,x,...
    cntR,xTR,d2xdR,dxdR,xdR,d2xiR,dxiR,xiR,...
    cntL,xTL,d2xdL,dxdL,xdL,d2xiL,dxiL,xiL,...
    d2xdC,dxdC,xdC,cntRF,dxiRF,xiRF,cntLF,dxiLF,xiLF,...
    codeR,codeL,codeRF,codeLF,...
    iC,Kp,Kd,dmT};
t0 = tic;
inverseKinematics(Task,tSpan,dataSet);
tSim = toc(t0)  % Spent time [s]
%% Data-loading
loadData(Task,fIDplot);
% ::::::::::::: Section Anim ::::::::::::::: %
r = floor(tSpan(1)/T)+1:floor(tSpan(2)/T);
d2q = d2q(:,r);
dq = dq(:,r);
q = q(:,r);
dq0 = dq(:,1);
q0 = q(:,1);
xd = xd(:,r);
x = x(:,r);
% :::::::::::::::::::::::::::::::::::::::::: %
% Data conversion (quarternion to [phi,theta])
xdconv = dataConv(md,xd);
xconv = dataConv(md,x);
%% Animation
modelName = 'DrumBoy5';
td = T*(length(q(1,:)) - 1);    % Simulation time adjustment in case of "stop"
inverseDynamics(modelName,td,d2q,dq,q,dq0,q0,'on');
%% Save torque and body acceleration
appendData(Task,'tau',tau,false);
appendData(Task,'b',b,false);
%% Record
% recordVideo(modelName,Task,1);
%% Plot
plotFigures(xdconv,xconv,q,tau);