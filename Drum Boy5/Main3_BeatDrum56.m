clear
close all
clc
 
global T fIDsave
TaskFolder = 'beatDrum59';
[fIDsave,fIDplot] = fileID(TaskFolder);                    
TaskPrev = 'relaxArm';
Task = 'solo';

code = 'codeBC_final_revise.txt'; N = 10;
bpm = [1 53];

tQ = [bpm(:,1) 60./bpm(:,2)];
tQ0 = 0.600;    % Base quarter note length of code
setEnvironment(TaskFolder);
%% Bar span in code
bSpan = [0 N];
% Delete files in "save" folder
saved = [fIDsave,'tau','b'];
for k = 1:length(saved)
    deleteFile(Task,saved{k});
end
%% Initial setting
% Drum code
[codeR,codeL,codeRF,codeLF,codedata] = codeRegen(code,tQ,tQ0,T);
tSpan = b2tSpan(codedata,bSpan) % time span
% Constants
tC = 0.008;         % Contact time [s]: 2 multiple
iC = round(tC/T);   % Contact time constant
m = 15;             % Total number of DoFs in end-effectors (6*2+3)
Kp = 10*eye(m);     % Control gain: 10(for rate)
% Kp([4:6 10:12],[4:6 10:12]) = 100*eye(6);   % stiff wrist rotation
Kd = 1*eye(m);  % Control gain
% Initial joint positions
q0 = load(['q_',TaskPrev,'.txt'])';
dq0 = load(['dq_',TaskPrev,'.txt'])';
q0 = q0(:,end);
dq0 = dq0(:,end);
dq1 = dq0;          % Updated every iteration
% Initial values
q = q0;
dq = dq0;
x(1:18,1) = fk(q(1:17));
x(19:20,1) = q(18:19);
dx(1:15,1) = J(q(1:17))*dq(1:17);
dx(16:17,1) = dq(18:19);
xd = x;
dxd = dx;
d2xd = 0*dxd;
% Desired position transformation
e = x2Euler(q);
xdR = [xd(1:3);e(1:2)];
xdL = [xd(8:10);e(3:4)];
xdC = e(5:6);
dxdR = [dxd(1:3);0*e(1:2)];
dxdL = [dxd(7:9);0*e(3:4)];
dxdC = 0*e(5:6);
d2xdR = 0*dxdR;
d2xdL = 0*dxdL;
d2xdC = 0*dxdC;
xdRF = xd(19);
xdLF = xd(20);
dxdRF = dxd(16);
dxdLF = dxd(17);
% Iterative variables
md = length(xdR);      % Number of DOFs : (x,y,z) and (phi,theta)
nb = 5;                % Order of Bezier curve
cntR = 1;              % Beat counter (Right)
xTR = xdR;             % Target azimuth (Right)
d2xiR = d2xdR;         % Initial acceleration (Right)
dxiR = dxdR;           % Initial velocity (Right)
xiR = xdR;             % Initial position (Right)
cntL = 1;              % Beat counter (Left)
xTL = xdL;             % Target azimuth (Left)
d2xiL = d2xdL;         % Initial acceleration (Left)
dxiL = dxdL;           % Initial velocity (Left)
xiL = xdL;             % Initial position (Left)
cntRF = 1;             % Beat counter (RF)  
dxiRF = dxdRF;         % Initial velocity (RF)
xiRF = xdRF;           % Initial position (RF)
cntLF = 1;             % Beat counter (LF)
dxiLF = dxdLF;         % Initial velocity (LF)
xiLF = xdLF;           % Initial position (LF)
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
%% Animation
modelName = 'DrumBoy5';
td = T*(length(q(1,:)) - 1);    % Simulation time
inverseDynamics(modelName,td,d2q,dq,q,dq0,q0,'on');
%% Save torque and body acceleration
saveData(Task,'tau',tau,false);
saveData(Task,'b',b,false);
%% Record
% recordVideo(modelName,Task,1);
%% Plot
% Data conversion (quarternion to [phi,theta])
xdconv = dataConv(md,xd);
xconv = dataConv(md,x);
plotFigures(xdconv,xconv,q,tau);
%% Save for re-run
% Initials and constants
dataID = {'dq0','q0','tQ0','tQ','tC','Kp','Kd','nb','md'};
for i = 1:length(dataID)
    saveData(Task,dataID{i},eval(dataID{i}),false);
end
% Code
codeID = fopen(['save\code_',Task,'.txt'],'wt');
fprintf(codeID,code);
fclose(codeID);
% TaskFolder
TaskFolderID = fopen('save\taskFolderName.txt','wt');
fprintf(TaskFolderID,TaskFolder);
fclose(TaskFolderID);