%% ========================================================================
%  SPLINE
function [ResultCutPara,kncalls,ncalls, stackflag, NE_best, iseed]=SPLINE(orchandle, ...
    problemparam, solverparam, x0, mk, bk, k, iseed, logfid,ncalls,budget,kncalls,ResultCutPara)
% =========================================================================

% Declare global variables
global trajectory visitpoint step;
global ncalls;
% Solver paramater
ftol = 0;

% Initialize SPLINE parameters
NE_best     =struct('x',{},'fn',{},'simunum',{});
stackflag   =0;  % Set to 1 if all solutions in stack are deemed infeasible at cuurent sampling level mk, else 0.
%ncalls      =0;
iseedk      =iseed;
NE_best(1).x   =x0;
bk1 = bk;
%fprintf(logfid, 'Initial solution = [');
%fprintf(logfid, '%d ', NE_best(1).x);
%fprintf(logfid, ']\n');

% Find a sample-path feasible solution in trajectory  
% Move this section of the code into function RSPLINE
stack_ctr=size(trajectory,2); %Each column is a new vector
while (1)   %此迴圈為初始解的檢查機制
    [flag, NE_best] = orchandle(NE_best.x, mk,ncalls);  %執行模擬
    if flag==0  %flag為解的範圍限制 ，0=無違背、1=違背
        
        ncalls = ncalls + mk; % Count mk only if x\in\mathbb{X}.
        kncalls = kncalls + mk;
       
        
        
    end
 
    if flag==0 
       if k==1
           PUSH(NE_best.x);
       end
       break  %找到可行解  跳出迴圈
    end

    % Else initial solution is infeasible
    % %如果初始解不可行，開始找trajectory陣列中之前的可行解
    %fprintf(logfid, 'Infeasible initial solution\n');
    
    stack_ctr=stack_ctr-step;
    if stack_ctr<=0  % Stack is empty    如果trajectory陣列中沒有可行解，回到cgRSPLINE在執行一次restart
        stackflag=1; % Denotes that stack is empty! All visited solutions are infeasible at current sampling level mk
        return       % Returns control to R-SPLINE, which in turn returns control to cgRSPLINE 
    end              % so that local search may be restarted.  

    %trajectory(:,stackctr)=[]; %this would delete x at location stackctr
    NE_best.x=trajectory(:,stack_ctr); %tra::   如果trajectory陣列中有可行解，則使用最近一次的可行解作為SPLINE的初始解     
    %fprintf(logfid, '[');
    %fprintf(logfid, '%d ', NE_best.x);
    %fprintf(logfid, ']: ');
end






% Save feasible initial solution to xinit
xinit=NE_best;

%fprintf(logfid, '\t===== BEGIN SPLINE LOOP ===\n');
%for i=1:bk
while (1)
	%fprintf(logfid, '\t\t=== bk = %d ===\n', i);
		
    iseed=iseedk;
	[ResultCutPara,bk2,kncalls, ncalls, SPLI_best, iseed] = SPLI(orchandle, problemparam, ...
        solverparam, NE_best, mk, iseed, logfid,ncalls,budget,kncalls,bk1,ResultCutPara);

    if ncalls>=budget
        NE_best=SPLI_best;
        break;
    end
        
    if kncalls>= bk2
        NE_best=SPLI_best;
        return;
    end
        
    iseed=iseedk;
	[bk2,kncalls,ncalls, NE_best, iseed] = NE(orchandle, problemparam, ...
        solverparam, SPLI_best, mk, iseed, logfid,ncalls, kncalls,bk1);
 
    if ncalls>=budget
        break;
    end
    
    if kncalls>=bk2
        return;
    end

    
    %找到區域最佳解
    if  SPLI_best.x == NE_best.x 
    	%fprintf(logfid, '\n\t\tSPLINE ended at bk=%d since NE and SPLI returned the same solution\n\n', i);
    	break
    end
end
	
% Starting solution is worse than the new solution by at most amount ftol
if xinit.fn <= NE_best.fn + ftol   %SPLINE找到的解如果比原始解差，將找到的解便回原始解回傳
	NE_best=xinit;
end

end

