function iL = liftTimeLength(iSwing,dxT,dxi)
% Their magnitude!!!
iL = dxT*iSwing/(dxi+dxT);
iL = floor(iL);