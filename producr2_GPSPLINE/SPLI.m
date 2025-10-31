%% ========================================================================
%  SPLI
function [ResultCutPara,bk2,kncalls, ncalls, SPLI_best, iseed] = SPLI(orchandle, problemparam, ...
    solverparam, SPLI_best, mk, iseed, logfid,ncalls,budget, kncalls,bk1,ResultCutPara)
%  ========================================================================

% Problem parameters
% nseeds = int32(param(3));
% nsecMeas = int32(param(4));
%Solver parameter
global scenario
global step step_decial
ftol = 0;
id=length(SPLI_best(1).x);
global ncalls;
% Initialize SPLI variables
ix1 =struct('x',{},'fn',{},'simunum',{});
x0 =struct('x',{},'fn',{},'simunum',{});
imax=100;
jmax=5;
%ncalls=0;
s0=2;
c=2;
iseedk=iseed;
bk2 = bk1;


%fprintf(logfid, '\t\t\tBEGIN SPLI ===\n');
for j=0:jmax
%{
    fprintf(logfid, '\t\t\t\t=== j = %d ===\n', j);
    fprintf(logfid, '\t\t\t\ti/p seed to PERTURB = [');
    fprintf(logfid, '%d ', iseed);
    fprintf(logfid, ']');
    %}
    %x1=PERTURB(SPLI_best.x, iseed, logfid);
    x1=[];

    for i=1:length(SPLI_best.x)
        %有點tradeoff的關係
        x1=[x1;SPLI_best.x(i)];
    end

    %fprintf(logfid, '\t\t\t\tPertrubed value of xbest.x = [');
    %fprintf(logfid, '%0.12f ', x1);
    %fprintf(logfid, ']\n');

	%fprintf(logfid, '\t\t\t\tPLI begins ===\n');		

    iseed=iseedk;
    [kncalls,ncalls, fbar, gamma, npoints, pli_best, iseed] = PLI(orchandle, ...
        problemparam, solverparam, x1, SPLI_best.x, mk, iseed, logfid,kncalls,ncalls);
	% Regardless of whether npoints=id+1 or not, update current best
    % disp("pli_best");
    % disp(pli_best.x);
    % disp("SPLI_best");
    % disp(SPLI_best.x);
    if  pli_best.fn + ftol < SPLI_best.fn 
        if npoints>0
            SPLI_best=pli_best;
            PUSH(SPLI_best.x);
        end
    end
     
    if ncalls>=budget
        return;
    end 
    
    if kncalls>= bk2
        return;
    end  
    
    if npoints < id+1 % Return control to SPLINE if PLI could not identify 
                      % id+1 feasible points   %如果PLI中單體點不是全部可行解 直接回傳目前解(這裡出事了阿伯)
        return 
    end
    
    % Perform line search only if PLI finds id+1 feasible
    % points----------------------------------------------------------------------------------------------------
	glength=norm(gamma);
    %fprintf(logfid, '\t\t\t\tglength = %.12f\n', glength);		
    if glength + ftol <= 0
		return
    end
    x0(1).x=SPLI_best.x;
    [rows, cols]=size(x0(1).x);
    if rows~=1
        x0(1).x=transpose(x0(1).x);
    end
    %gamma=gamma/glength;
	b=0;
	ix1(1).x=SPLI_best.x;
	while (ix1(1).x~=SPLI_best.x | ncalls>kncalls)
        ix1(1).x=zeros(1,id);
		b=b+1;
		s=c^(b-1)*s0;
        % disp("x0(1).x");
        % disp(x0(1).x);
        % disp("s");
        % disp(s);
        % disp("gamma/glength");
        % disp(gamma/glength);
		ix1(1).x= round(x0(1).x-s*(gamma/glength),step_decial);
        [flag, ix1] = orchandle(ix1(1).x, mk,ncalls);
        if scenario=="haveCut"
		    [ResultCutPara,instrument]=Project_onto_feasible_region(ResultCutPara,SPLI_best,gamma,ix1);
		    if instrument=="stop"
			  flag=1;
            end
        end
		
        if flag==0
           ncalls = ncalls + mk;
           kncalls = kncalls +mk;            
        end
        if flag~=0 % Return conntrol to SPLINE if line search encounters
                    % an infeasible pt
            return	% ix1 is infeasible    違背限制式>跳出SPLI
        end

        %剛改這
        % if ix1.fn >= SPLI_best.fn + ftol 
        %        if i <= 2
        %             return  % Return control to SPLINE if a worse solution is encountered
        %             % right away    新的解解品質太差>跳出SPLI
        %        end
        % end





        % if ix1.fn >= SPLI_best.fn + ftol
        %     break   % If a worse solution is found later, simply perform PLI again. 
        % end
		% Update xbest after every step in the line search
		SPLI_best=ix1;
        PUSH(SPLI_best.x);
        
        if ncalls>=budget
            return;
        end
        if kncalls>= bk2
			return;
        end  
        
	end
	%{
    for i=0:imax   %執行鹹性搜尋的最大次數
        s = s0 * c^i;
        ix1(1).x=zeros(id,1);
        for k=1:id  %計算id個維度的前進量!!!!!!!!!!!!!!!!!!!!!!改看看
            %因為單體點變成減1，所以減改成加(很重要的tradeoff)
            new_Value=floor(s*gamma(k));
            %500是步長
			ix1(1).x(k)=floor(x0(k)-250*new_Value);
        end
%%        
        [flag, ix1] = orchandle(ix1.x, mk,ncalls);
        if flag==0
           ncalls = ncalls + mk;
           kncalls = kncalls +mk;            
        end
        if flag~=0 % Return conntrol to SPLINE if line search encounters
                    % an infeasible pt
            return	% ix1 is infeasible    違背限制式>跳出SPLI
        end

        
        if ix1.fn >= SPLI_best.fn + ftol 
               if i <= 2
                    return  % Return control to SPLINE if a worse solution is encountered
                    % right away    新的解解品質太差>跳出SPLI
               end
        end
        if ix1.fn >= SPLI_best.fn + ftol
            break   % If a worse solution is found later, simply perform PLI again. 
        end

        % Update xbest after every step in the line search
		SPLI_best=ix1;
        PUSH(SPLI_best.x);
        
        if ncalls>=budget
            return;
        end
        if kncalls>= bk2
        return;
        end  
        
    end
	%}
end
end
