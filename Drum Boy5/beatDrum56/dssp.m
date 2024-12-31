function d = dssp(iQ,iSW)
r = iSW/iQ;

% s = 1.1;
% d = 0.6*(min(r,0.5) + s*max(0,r-0.5));

% s = [1 1.65];
% d = 0.6*(min(r,0.5) + s(1)*max(0,min(r-0.5,0.25)) + s(2)*max(0,r-0.75));

% s = [1 1];
% d = 0.5*(min(r,0.5) + s(1)*max(0,min(r-0.5,0.25)) + s(2)*max(0,r-0.75));

% r = iSW;
% d = 0.5*0.5*(tanh(.035*(r-225))+1)+0.3;

d = .6*sqrt(r);