function i = internalTimer(k,cnt,code)

if cnt > 1
    %% Rest phase
    i = k - sum(code(1:cnt-1,3)); % internal counter
else
    %% Initial phase
    i = k;
end