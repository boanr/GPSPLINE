% %% ========================================================================
% %  NE
% function [bk2,kncalls, ncalls, NE_best, iseed] = NE(orchandle, problemparam, ...
%     solverparam, SPLI_best, mk, iseed, logfid,ncalls, kncalls,bk1)
% 
% %  ========================================================================
% 
% % Problem parameters
% id = length(SPLI_best(1).x);
% % nseeds = int32(problemparam(3));
% % nsecMeas = int32(problemparam(4));
% 
% % Solver parameters
% ftol = 0;
% 
% % Initialize NE variables
% %ncalls    = 0;
% iseedk    = iseed;
% NE_best   = SPLI_best;
% y2        = NE_best.fn;
% ixquad    = struct('x',{},'fn',{},'simunum',{});
% ixquad(1).x = zeros(id, 1);
% bk2 = bk1;
% %{
% fprintf(logfid, '\n\t\t\t===== NE BEGINS =====\n');
% fprintf(logfid, '\t\t\tfn at center = %.12f, center = [', y2);
% fprintf(logfid, '%d ', NE_best.x);
% fprintf(logfid, ']\n');
% %}
% for i=1:id  %執行鄰域搜尋(id=維度數)
% 	count=1;
%     SPLI_best(1).x(i)=SPLI_best(1).x(i)+250;  %更新鄰近點(右邊)
%     iseed=iseedk;
% 
%     [flag, SPLI_best] = orchandle(SPLI_best.x, mk,ncalls);  %執行模擬
%     if flag==0  %此flag為變數範圍的flag
% 
%         ncalls = ncalls + mk;
%         kncalls = kncalls + mk;
%     end
% 
%     if flag == 0  %if feasible, update ncalls and call fn as y2
% 		y1=SPLI_best.fn; 
% 		count=count+1;        %count keeps a track of number of feasible points along a direction
%         if SPLI_best.fn <= NE_best.fn + ftol % if superior, update current best solution   比較目前鄰近點與最佳的的目標值
% 			NE_best=SPLI_best;
%             PUSH(NE_best.x);
%         end
%     end
% 
% 
%     SPLI_best(1).x(i)=SPLI_best(1).x(i)-500;  %更新鄰近點(左邊)(因為前面向右1單位，回左邊要2單位
%     iseed=iseedk;
% 
%     [flag, SPLI_best] = orchandle(SPLI_best.x, mk,ncalls);  %執行模擬
%     if flag==0  %此flag為變數範圍的flag
% 
%         ncalls = ncalls + mk;
%         kncalls = kncalls + mk;
% 
%     end
% 
% 
%     if flag == 0
% 		y3=SPLI_best.fn; 
% 		count=count+1;
%         if SPLI_best.fn <= NE_best.fn + ftol
% 			NE_best=SPLI_best;
%             PUSH(NE_best.x);
%         end 
%     end
% 
% 	SPLI_best(1).x(i)=SPLI_best(1).x(i)+250;  %回到原點
% 	xqnew=SPLI_best.x(i);
% 
%     % Quadratic search
%     if count==3 %如果鄰近點皆為可行點
% 		a = (y1+y3)/2.0 - y2;  %a=左右點的目標值平均-原本最佳解的目標值
% 		b = (y1-y3)/2.0;       %b=左右點的目標值差的平均
%         if a-ftol > 0  %如果y2的目標值小於左右點的目標值的平均
% 			xqnew = int32(SPLI_best.x(i) - (b / (a + a)));
%         end
% 		%fprintf(logfid, '\t\t\t\ti = %d, a = %.12f, b = %.12f, xqnew = %.12f\n', i, a, b, xqnew);
% 		%fprintf(logfid, '\t\t\t\ty2 = %.12f, y1 = %.12f, y3 = %.12f\n', y2, y1, y3);
%     end
%     if  abs(xqnew) < 2147483646.0 %2^31-2
% 		ixquad(1).x(i) = xqnew;
%     end
% 	%fprintf(logfid, '\t\t\t\txold[%d] = %d, ixquad[%d] = %d\n', i, SPLI_best.x(i), i, ixquad.x(i));
% end
% 
% %Call oracle at ixquad. Update NE_best.
% iseed=iseedk;
% [flag, ixquad] = orchandle(ixquad.x, mk,ncalls);  %執行模擬
% 
% if flag==0
% 
%     ncalls = ncalls + mk; % Count mk only if x\in\mathbb{X}.
%     kncalls = kncalls + mk;
% 
% end
% 
% if flag==0
%     if ixquad.fn <= NE_best.fn + ftol
% 		NE_best=ixquad;
%         PUSH(NE_best.x);
%     end
% end
% 
% 
% end
























































































function [bk2, kncalls, ncalls, NE_best, iseed] = NE(orchandle, problemparam, ...
    solverparam, SPLI_best, mk, iseed, logfid, ncalls, kncalls, bk1)
global step;
global step_decial;
% Problem parameters
id = length(SPLI_best(1).x);

% Solver parameters
ftol = 0;

% Initialize NE variables
iseedk    = iseed;
NE_best   = SPLI_best;
best_val  = NE_best.fn;
y2        = NE_best.fn;
ixquad    = struct('x', {}, 'fn', {}, 'simunum', {});
ixquad(1).x = zeros(id, 1);
bk2 = bk1;

% === 新增：候選解清單 ===
NE_candidates = NE_best;  % 初始放目前解，之後會替換掉

for i = 1:id
    count = 1;
    SPLI_best(1).x(i) = SPLI_best(1).x(i) + step;
    iseed = iseedk;

    [flag, SPLI_best] = orchandle(SPLI_best.x, mk, ncalls);
    if flag == 0
        ncalls = ncalls + mk;
        kncalls = kncalls + mk;
        y1 = SPLI_best.fn;
        count = count + 1;

        % === 比較並收集候選解 ===
        if SPLI_best.fn < best_val - ftol
            NE_candidates = SPLI_best;
            best_val = SPLI_best.fn;
        elseif abs(SPLI_best.fn - best_val) <= ftol
            NE_candidates(end+1) = SPLI_best;
        end
    end

    SPLI_best(1).x(i) = SPLI_best(1).x(i) - step;
    iseed = iseedk;

    [flag, SPLI_best] = orchandle(SPLI_best.x, mk, ncalls);
    if flag == 0
        ncalls = ncalls + mk;
        kncalls = kncalls + mk;
        y3 = SPLI_best.fn;
        count = count + 1;

        if SPLI_best.fn < best_val - ftol
            NE_candidates = SPLI_best;
            best_val = SPLI_best.fn;
        elseif abs(SPLI_best.fn - best_val) <= ftol
            NE_candidates(end+1) = SPLI_best;
        end
    end

    SPLI_best(1).x(i) = SPLI_best(1).x(i) + step;
    xqnew = SPLI_best.x(i);

    % Quadratic interpolation
    if count == 3
        a = (y1 + y3) / 2.0 - y2;
        b = (y1 - y3) / 2.0;
        if a - ftol > 0
            xqnew = int32(SPLI_best.x(i) - (b / (2.0 * a)));
        end
    end

    if abs(xqnew) < 2147483646.0
        ixquad(1).x(i) = xqnew;
    end
end

% Evaluate quadratic point
iseed = iseedk;
[flag, ixquad] = orchandle(ixquad.x, mk, ncalls);
if flag == 0
    ncalls = ncalls + mk;
    kncalls = kncalls + mk;

    if ixquad.fn < best_val - ftol
        NE_candidates = ixquad;
        best_val = ixquad.fn;
    elseif abs(ixquad.fn - best_val) <= ftol
        NE_candidates(end+1) = ixquad;
    end
end

% === 最後選擇一個最佳解 ===
if ~isempty(NE_candidates)
    idx = randi(length(NE_candidates));  % 隨機選一個
    NE_best = NE_candidates(idx);
    PUSH(NE_best.x);
end

end
