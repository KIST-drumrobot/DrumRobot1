function [codeR,codeL,codeRF,codeLF,data] = codeRegen(codeName,tQ,tQ0,T)
global SN TT MT FT HH RD RDb CCr CCl
global SNnon SNcen SNoff SNrim SNgst
global HHoff FToff CCroff CCloff HHrd HHl
% NOTE: right (j = 1) / left (j = 2)
% tQ = desired quarter note time length
% tQ0 = quarter note time length in code file
% T = sampling time
data = load(codeName);          % data load
L = length(data(:,1));
%% BPM setting
cnt = 1;
tQk = tQ(cnt,2);
data(1,2) = data(1,2)/tQ0*tQk;
data = [data [tQk;zeros(L-1,1)]];
for k = 1:L-1
    if cnt <= length(tQ(:,1))
        if data(k,1) == tQ(cnt,1)
            tQk = tQ(cnt,2);
            cnt = cnt + 1;
        end
    end
    data(k+1,end) = tQk;
    data(k+1,2) = data(k+1,2)/tQ0*tQk;   
end
%% Variable setting
% Description:
% 1. line number
% 2. bar number
% 3. strike time length
% 4. target drum
% 5. strike speed factor
% 6. swing time length
% 7. quarter note length
% NOTE: 
% strike time = contact + (stay) + swing
% swing time = lift + hit
codeR = zeros([],7);
codeL = zeros([],7);
codeRF = zeros([],7);
codeLF = zeros([],7);
%% Drum set
% basic drum position
SN = 1;
FT = 2;
MT = 3;
TT = 4;
HH = 5;
RD = 6;
RDb = 26;
CCr = 7;
CCl = 8;
cym = [HH RD CCr CCl];
tom = [SN TT MT FT];
% variation
SNnon = 11;     % no-hit
SNcen = 21;     % center-hit
SNoff = 41;     % snare offset
SNrim = 71;     % rim shot
SNgst = 81;     % ghost note
HHoff = 45;     % hihat offset
FToff = 42;     % floor tom offset
CCroff = 47;    % crash offset
CCloff = 48;    % crash offset
HHrd = 65;      % HH wiht RD
HHl = 85;       % HH wiht RD
SNhit = [SN SNrim SNgst];
%% Swing time generation
% Code file description:
% 1. bar number
% 2. strike time
% 3. right target drum
% 4. left target drum
% 5. right speed factor
% 6. left speed factor
% 7. bass kick
% 8. hi-hat open/close
% Example:  1   0.300   5   0   1   0   0   0
tSwing = zeros(L,2);
dt = zeros(1,2);
for k = 1:L
    for j = 1:2
        dt(j) = dt(j) + data(k,2);
        % Base swing time
        if data(k,2+j) > 0
            if dt(j) > data(k,end)
                tSwing(k,j) = data(k,end);
            else
                tSwing(k,j) = dt(j);
            end
            dt(j) = 0;  % reset
        end
    end
end
%% Swing time correction (Exceptions)
right = zeros(L,1);
left = zeros(L,1);
for k = 1:L
    %:::::::: To prevent collision with left and right ::::::::%
    imax = 3;
    ipast = 0;
    iprev = 0;
    inext = 0;
    % current right and left
    right(k) = rem(data(k,3),10); 
    left(k) = rem(data(k,4),10);
    bfoot = data(k,7);  % bass foot
    % previous right and left
    right_prev = 0;
    left_prev = 0;
    for i = 1:imax
        if k-i < 1
            iprev = i-1;
            break;
        end
        right_prev = right(k-i);
        left_prev = left(k-i);
        if (right_prev > 0) || (left_prev > 0)
            iprev = i;
            break;
        end
    end
    % past right and left
    right_past = 0;
    left_past = 0;
    for j = (i+1):(i+1)+imax
        if k-j < 1  % prevent error
            ipast = j-1;
            break;
        end
        right_past = right(k-j);
        left_past = left(k-j);
        if (right_past > 0) || (left_past > 0)
            ipast = j;
            break;
        end
    end
    % next right and left
    right_next = 0;
    left_next = 0;
    for i = 1:imax
        if k+i > L
            inext = i-1;
            break;
        end
        right_next = rem(data(k+i,3),10); 
        left_next = rem(data(k+i,4),10);
        if (right_next > 0) || (left_next > 0)
            inext = i;
            break;
        end
    end
    % future right and left
    right_future = 0;
    left_future = 0;
    for j = (i+1):(i+1)+imax
        if k+j > L  % prevent error
            ifuture = j-1;
            break;
        end
        right_future = rem(data(k+j,3),10);
        left_future = rem(data(k+j,4),10);
        if (right_future > 0) || (left_future > 0)
            ifuture = j;
            break;
        end
    end
    dref = .2;  % reference value of dissipation d
    %% common rule #1. R/L (cym/SN)
    % *cym = [HH RD CCr CCl]
    p = ismember(right(k),cym) && ismember(left(k),SNhit);
    if p
        % right/left lifting
        data(k,5) = data(k,5) + (dref-.15);
        data(k,6) = data(k,6) + (dref+.15);
    end
    %% special rule1: right CCr-CCl pattern
    p = (right(k-iprev) == CCr) && (right(k) == CCl);
    if p && tSwing(k,1) < .5
        data(k,3) = CCloff;
    end
    %% special rule2: simultaneous RD-HH
    p = (right(k) == RD) && (left(k) == HH);
    if p
        data(k,4) = HHrd;
    end
    %% pattern-rule #1. R-L-R or R-R/L-R
    % 1) cym-SN-cym or cym-cym/SN-cym
    % *cym = [HH RD CCr CCl]
%     p = ismember(right_prev,cym) && (left_prev == 0) && ...
%         ismember(right(k),[0 cym]) && ismember(data(k,4),SNhit) && ...
%         ismember(right_next,cym) && (left_next == 0);
    p = ismember(right_prev,setdiff(cym,RD)) && (left_prev == 0) && ...
        ismember(right(k),[0 setdiff(cym,RD)]) && ismember(data(k,4),SNhit) && ...
        ismember(right_next,setdiff(cym,RD)) && (left_next == 0);
    if p
        if right_prev == HH && right(k) == 0 && right_next == HH
            data(k,6) = data(k,6) + (dref+.3);
        end

        if (left_future == HH || left_future == CCl) || ...
                (left_past == HH || left_past == CCl)
            data(k+inext,3) = HHoff;
        end

        if left_past == HH || left_past == CCl
            data(k,4) = SNoff;
        else
            tSwing(k,2) = sum(data(k-iprev+1:k,2));

            if left_past == 0   
                % find left hit at the latest
                for m = ipast+1:k-ipast-1
                    if data(k-m,4) > 0
                        left_latest_hit = data(k-m,4);

                        if left_latest_hit == HH || left_latest_hit == CCl

                            data(k-iprev,4) = SNnon+10; % offset float
                            data(k-iprev,6) = 1 + (dref+.3);
                            tSwing(k-iprev,2) = sum(data(k-m+1:k-iprev,2));

                        end

                        break;

                    end
                end
            end
        end
    end
    % 2) tom-CCl-HH
    % *tom = [SN TT MT FT]
    p = ismember(right_prev,tom) && (left_prev == 0) && ...
        (right(k) == 0) && (left(k) == CCl) && ...
        (right_next == HH) && (left_next == 0);
    if p
        data(k+inext,4) = SNnon;
        tSwing(k+inext,2) = sum(data(k+1:k+inext,2));
        data(k+inext,6) = 1 + (dref+.3);
    end
    % 3) HH(CCl)-tom-tom/tom or HH(CCl)/SN-tom-tom/tom
    % *tom = [SN TT MT FT]
    p = ismember(right_prev,[HH CCl]) && ismember(data(k-iprev,4),[0 SNhit]) && ...
        (right(k) == 0) && ismember(left(k),tom) && ...
        ismember(right_next,tom) && ismember(left_next,[0 tom]);
    if p
        % left swing time corrected
        tSwing(k,2) = sum(data(k-iprev+1:k,2));

        % right more & left less lifting
        data(k+inext,5) = data(k+inext,5) + (dref-.15);
        data(k,6) = data(k,6) + (dref+.15);
    end
    % 4) tom-tom-tom
    % NOTE: to avoid two sticks meeting
    p4(1) = (right_prev == MT) && (left_prev == 0) && ...
            (right(k) == 0) && (left(k) == MT) && ...
            (right_next == SN) && (left_next == 0);
    p4(2) = (right_prev == TT) && (left_prev == 0) && ...
            (right(k) == 0) && (left(k) == MT) && ...
            (right_next == FT) && (left_next == 0);
    if p4(1)
        data(k+inext,3) = SNoff;
        if left_future == SN
            data(k+ifuture,4) = SNoff;
        end
    end
    if p4(2) && (left_past == SN || left_past == TT)
        % left swing time corrected
        tSwing(k,2) = min(data(k,end),.7*sum(data(k-ipast+1:k,2)));
        data(k+inext,3) = FToff;
    end
    % 5) tom-tom-CCr
    % NOTE: due to short left FT 
    p = ismember(right_prev,[MT FT]) && (left_prev == 0) && ...
        (right(k) == 0) && (left(k) == FT) && ...
        (right_next == CCr) && (left_next == 0);
    if p
%         data(k,4) = FToff;

        if right_prev == MT
            data(k,4) = FToff;
            data(k+inext,3) = CCroff;
            tSwing(k,2) = .8*tSwing(k,2);
        end
    end
    %% pattern-rule #2. R-R-L or R/L-R-L
    % 1) HH(RD,CCl)-tom-tom or HH(RD,CCl)/SN-tom-tom
    % *cym = [HH RD CCr CCl]
    p = ismember(right_prev,setdiff(cym,CCr)) && ismember(data(k-iprev,4),[0 SNhit]) && ...
        ismember(right(k),tom) && (left(k) == 0) && ...
        (right_next == 0) && ismember(left_next,tom);
    if p
        % left swing time corrected
        tSwing(k+inext,2) = .9*sum(data(k-iprev+1:k+inext,2));

        if ismember(data(k-iprev,4),SNhit)
            % find left hit at the latest
            for m = iprev+1:k-iprev-1
                if data(k-m,4) > 0
                    left_latest_hit = data(k-m,4);

                    if left_latest_hit ~= HH
                        tSwing(k-iprev,2) = min(tSwing(k-iprev,1),tSwing(k-iprev,2));
                    end

                    break;
                end
            end

        end
        
    end
    %% pattern-rule #3. L-R-R
    % 1) tom-CCr-HH(RD)
    % *tom = [SN TT MT FT]
    p = (right_prev == 0) && ismember(left_prev,setdiff(tom,SN)) && ...
        (right(k) == CCr) && (left(k) == 0) && ...
        ismember(right_next,[HH RD]) && (left_next == 0);
    if p
        data(k+inext,4) = SNnon;
        tSwing(k+inext,2) = sum(data(k-iprev+1:k+inext,2));
        data(k+inext,6) = 1 + (dref+.3);

        if right_next == HH
            data(k+inext,3) = HHoff;
        end
    end
    % 2) CCl-HH/SN-HH
    p = (right_prev == 0) && (left_prev == CCl) && ...
        (rem(right(k),10) == HH) && (left(k) == SN) && ...
        (rem(right_next,10) == HH) && (left_next == 0);
    if p
        data(k+inext,3) = HHoff;
        data(k,4) = SNoff;
    end
    %% pattern-rule #4. R-R-R or R-R-R/L
    % 1) tom-cym1-cym2
    % *cym = [HH RD CCr CCl]
    % except SN, TT
    p = ismember(right_prev,[MT FT]) && (left_prev == 0) && ...
        ismember(right(k),[CCr RD]) && (left(k) == 0) && ...
        ismember(right_next,setdiff(cym,CCr)) && (left_next == 0);
    if p
        data(k+inext,4) = SNnon;
        tSwing(k+inext,2) = sum(data(k-iprev+1:k+inext,2));
        data(k+inext,6) = 1 + (dref+.3);
    end
    % 2) cym-cym-cym
    % *cym = [HH RD CCr CCl]
    % except CCs 
    p = ismember(right_prev,[HH RD]) && (left_prev == 0) && ...
        ismember(right(k),[HH RD]) && (left(k) == 0) && ...
        ismember(right_next,[HH RD]) && (left_next == 0);
    if p && (tSwing(k,1) < data(k,end))
        % more dynamic swing
        data(k,5) = data(k,5) + (dref-.15);
    end
    %% additional rule
    if k > 1 && k < L
        % 1) preparation for rimshot/bowshot
        if fix(right(k)/10) == 6
            data(k,5) =  1 + (dref+.6);
        end
        if fix(left(k)/10) == 6
            data(k,6) =  1 + (dref+.6);
        end
        % 2) short of target when right moves from CCr to HH
        if (right_prev == CCr && right(k) == HH) || ...
            (right_past == CCr && right_prev == 0 && right(k) == HH)
            if tSwing(k,1) < 0.3
                data(k,3) = 85;
            end
        end
    end

end

%% Disassembly into left/right
% ---------- Hands  ---------- %
i = ones(1,2);
t = zeros(1,2);
dt = zeros(1,2);
for k = 1:L
    for j = 1:2
        % HH position correction
        if data(k,2+j) == 5 && data(k,8) == 2
            data(k,2+j) = 25;   % HH open
        end
        % Code generation for each hand
        code = zeros(1,5);
        if data(k,2+j) ~= 0
            code(1) = data(k,1);
            code(2) = dt(j) + data(k,2);    % Strike time
            code(3) = data(k,2+j);          % Target drum
            code(4) = data(k,4+j);          % Swing speed
            code(5) = tSwing(k,j);          % Swing time
            code(6) = data(k,end);          % Quarter note
            % Time 2 count
            [iStrike, iSwing] = strikeTime2cnt(T,t(j),code(2),code(5));
            code(2) = iStrike;
            code(5) = iSwing;
            code(6) = round(code(6)/T);
            % Save code to right and left
            if j == 1       % Right(R)
                codeR(i(j),:) = [i(j) code];
            elseif j == 2   % Left(L)
                codeL(i(j),:) = [i(j) code];
            end
            % Update time and count
            t(j) = t(j) + dt(j) + data(k,2);
            i(j) = i(j) + 1;
            dt(j) = 0;  % Strike time increment reset
        else
            dt(j) = dt(j) + data(k,2);
        end
    end
end
% ---------- Feet ---------- %
i = ones(1,2);
t = zeros(1,2);
dt = zeros(1,2);
for k = 1:L
    for j = 1:2
        code = zeros(1,5);

        if data(k,6+j) ~= 0
            code(1) = data(k,1);
            code(2) = dt(j) + data(k,2);    % Strike time
            code(3) = data(k,6+j);          % For HH pedal, 1: closed, 2: open
            if code(2) > data(k,end)/2
                code(5) = data(k,end)/2;
            else
                code(5) = code(2);
            end
            % Strike and swing time 2 count
            [iStrike, iSwing] = strikeTime2cnt(T,t(j),code(2),code(5));
            code(2) = iStrike;
            code(5) = iSwing;
            code(6) = round(data(k,end)/T);
            % Save code to right and left
            if j == 1   % Bass pedal(R)
                codeRF(i(j),:) = [i(j) code];
            elseif j == 2   % HH pedal(L)
                codeLF(i(j),:) = [i(j) code];
            end
            % Update time and count
            t(j) = t(j) + dt(j) + data(k,2);
            i(j) = i(j) + 1;
            dt(j) = 0;  % Strike time increment reset
        else
            dt(j) = dt(j) + data(k,2);
        end
    end
end

%% Break time handling
kCntLim = round(1.5/T);
% If the break time lasts for more than kCountLim, the sticks move toward
% the next drums in advance.

L = sum(codeR(:,3));
beat = zeros(L,2);  % drum beat kind

cnt = [1 1];
kT = zeros(1,length(cnt));
kT(1) = codeR(cnt(1),3);
kT(2) = codeL(cnt(2),3);
kCnt = 0;
trig = true;
trigL = true;
for k = 1:L
    for j = 1:2
        switch j
            case 1
                codeX = codeR;
            case 2
                codeX = codeL;
        end

        if k == kT(j)
            beat(k,j) = codeX(cnt(j),4); 
            cnt(j) = cnt(j)+1;
            if cnt(j) <= length(codeX(:,1))
                kT(j) = kT(j) + codeX(cnt(j),3);
            end
        end
    end

    % Case handling: "right only moves"
    if cnt(1) < length(codeR(:,1))
        if beat(k,2) > 0
            trigL = true;
        end
        if trigL
            if kT(1)+codeR(cnt(1),end)*4 < kT(2)

                rOnlyMove = true;

                ka = kT(1);
                for i = 1:3
                    ka = ka + codeR(min(cnt(1)+i,length(codeR(:,3))),3);
                    if ka > kT(2)
                        rOnlyMove = false;
                        break;
                    end
                end
        
                if rOnlyMove
                    % 1) generate a "float" line to insert
                    r = codeL(cnt(2),:);
                    r(4) = SNnon; % float
                    r(3) = kCntLim;
                    if codeL(cnt(2),6) > codeL(cnt(2),3)-kCntLim
                        r(3) = codeL(cnt(2),3)-codeL(cnt(2),6);
                    end
                    r(6) = r(3);
                    
                    % 2) push back the current line for insertion
                    codeL(cnt(2),1) = codeL(cnt(2),1)+1;
                    codeL(cnt(2),3) = codeL(cnt(2),3)-r(6);
                    codeL = [codeL(1:cnt(2)-1,:);r;codeL(cnt(2):end,:)];
    
                    % 3) update left cnt and reset trigL
                    cnt(2) = cnt(2)+1;
                    trigL = false;
                end

            end
        end

    end

    if sum(beat(k,:)) > 0
        trig = true;
        % NOTE: "trig" prevents this from producing "float" at one sequence of break
    end
    if trig
        if sum(beat(k,:)) == 0
            kCnt = kCnt+1;
            if kCnt >= kCntLim
                for j = 1:2

                    % 1) save "codeR" or "codeL" to the temp "codeX"
                    switch j
                        case 1
                            codeX = codeR;
                        case 2
                            codeX = codeL;
                    end

                    % 2) generate a "float" line to insert
                    r = codeX(cnt(j),:);
                    r(4) = rem(r(4),10)+10; % float
                    if j == 2
                        if codeR(cnt(1),4) == 15
                            r(4) = SNnon;
                        end
                    end
                    r(3) = kCntLim;
                    if codeX(cnt(j),6) > codeX(cnt(j),3)-kCntLim
                        r(3) = codeX(cnt(j),3)-codeX(cnt(j),6);
                    end
                    r(6) = r(3);

                    % 3) push back the current line for insertion
                    codeX(cnt(j),1) = codeX(cnt(j),1)+1;
                    codeX(cnt(j),3) = codeX(cnt(j),3)-r(6);

                    % 4) add the "float" line
                    codeX = [codeX(1:cnt(j)-1,:);r;codeX(cnt(j):end,:)];

                    % 5) return "codeX" to "codeR" or "codeL"
                    switch j
                        case 1
                            codeR = codeX;
                        case 2
                            codeL = codeX;
                    end

                end

                % update and reset
                cnt = cnt+1;
                kCnt = 0;
                trig = false;

            end
        else
            kCnt = 0;
        end
    end

end

%% supplementary dissipation
% :::::::::: right  :::::::::: %
for k = 1:length(codeR(:,1))-1

    if rem(codeR(k,5),1) == 0
        codeR(k,5) = codeR(k,5) + dref;
    end

end
% :::::::::: left :::::::::: %
for k = 1:length(codeL(:,1))-1

    if k > 1
        if rem(codeL(k-1,4),10) == CCl && rem(codeL(k,4),10) == SN
            codeL(k,5) = 1 + (dref+.6);
        end
    end

    if rem(codeL(k,5),1) == 0
        codeL(k,5) = codeL(k,5) + dref;
    end

end