function eO = orientError(Qe,Qd)

etae = Qe(1);
epsilone = Qe(2:end);
etad = Qd(1);
epsilond = Qd(2:end);

eO = etae*epsilond - etad*epsilone - S(epsilond)*epsilone;