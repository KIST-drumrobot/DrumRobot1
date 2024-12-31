function [iStrike, iSwing] = strikeTime2cnt(T,t,tStrike,tSwing)

iStrike = round((t+tStrike)/T) - round(t/T);
if floor(10000*tStrike) <= floor(10000*tSwing)
    iSwing = iStrike;
else
    iSwing = round(tSwing/T);
end