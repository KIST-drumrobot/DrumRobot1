function tSpan = b2tSpan(data,bSpan)
tSpan = zeros(1,2);
for k = 1:2
    i = find(data(:,1) > bSpan(k));
    tSpan(k) = sum(data(1:i-1,2));
end
% if tSpan(k) > 1
%     % the last 100[ms] ignored
%     if bSpan(2) == data(end-1,1)
%         tSpan(2) = tSpan(2)-.1;
%     end
% end