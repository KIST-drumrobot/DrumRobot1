function d = dsspfl(iQ,iSW)
s = 2;
r = iSW/iQ;
d = 0.6*(min(r,0.5) + s*max(0,r-0.5));