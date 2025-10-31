%% ========================================================================
function [ResultCutPara,ncalls, x1, FO, iseed, mk] = ...
    cRSPLINE_v2(x0, orchandle, problemparam, iseed, solverparam, ...
    logfid, logfid2, budget, alpha,ResultCutPara)
tic
%  ========================================================================
%
%  Kalyani Nagaraj
%  Oklahoma State University
%  Last updated: February, 2017
%
%  ========================================================================    
%  INPUT   (self explanatory)
%
%  OUTPUT  (self explanatory)
%
%  ========================================================================    
%  REFERENCES:
%
%     [1] K. Nagaraj and R. Pasupathy,
%     Stochastically constrained simulation optimization on integer-ordered
%     spaces: the cgR-SPLINE algorithm, 
%     Under 2nd review with Operations Research, 2017
%
%     [2] H. Wang, R. Pasupathy, and B. Schmeiser,
%     Integer-Ordered Simulation Optimization using R-SPLINE: 
%     Retrospective Search with Piecewise-Linear Interpolation and
%     Neighborhood Enumeration, ACM TOMACS, 2013
%
%  ========================================================================
%  NOTES: 1. cR-SPLINE_v2 does not prematurely terminate restarts.
%         2. cR-SPLINE_v2 guarantees by alpha_r feasibility of final
%            soln. Y_r by tracing back the trajectory. 
% 
%  ========================================================================

% Problem parameters 
% id=int32(problemparam(2));
% nseeds=int32(problemparam(3));
% nsecMeas=int32(problemparam(4));

% Solver parameters
kmax=solverparam(3); %1000
q=solverparam(4);  %3.5
%delta=solverparam(5)*ones(nsecMeas,1);
global ncalls;

c1=solverparam(6);   %cost s_1:8
c2=solverparam(7);   %cost s_2:10

total_sol=[];

% cvthresh=solverparam(8);
% biasthresh=solverparam(9);
yesgeom=solverparam(10); % yesgeom=1
geoma=solverparam(11);   % =m0=12000
geomc=solverparam(12);   % =c=3
%ftol=solverparam(18);

%{
-------------------------------------------------------------------------------
global RefMatrix_tau
global RefMatrix_AvgWT
global RefMatrix_Se_AvgWT
global RefMatrix_SecurityLevel
global RefMatrix_Cost
global RefMatrix_mobs
global RefMatrixSize
global total_sol 
global TSFtrueFlag
global RefMatrix_Seed
--------------------------------------------------------------------------------
%}

% Declare global variables
global trajectory visitpoint visitN;
trajectory=[]; % Initialize empty trajectory at the start of each restart
global k;
orchandle=str2func(orchandle);
% Initialize cR-SPLINE variables
x1=struct('x',{},'fn',{},'simunum',{});
visitpoint=struct('x',{},'fn',{},'simunum',{},'Penalty',{});
visitN=1;

ncalls=0;	% tracks the total calls made to the oracle
%令x1為x0
x1(1).x=x0;
k=1;





% PRINT TO LOG2  %用於紀錄內圈迭代資訊
%fprintf(logfid2, '-------------------------------------------------------------------------------------------------------------------------|--------------------------------------------\n');
%fprintf(logfid2, '  k    delta     m_k       w_k                                 X_k           g_k  se(g_k)         f_k             se(f_k)|             g           f       Feas    Opt\n');
%fprintf(logfid2, '-------------------------------------------------------------------------------------------------------------------------|--------------------------------------------\n');
% END PRINT TO LOG2
        
% countsame=0;  %For premature termination of restarts
%這啥
Solutions=zeros(1,kmax);
%% R-SPLINEstart

%. Begin Retrospective Iterations
%disp(['Start RSPLINE: ((S1,S2),ncalls) = ' num2str(x0(1)) ',' num2str(x0(2)) ',' num2str(ncalls)])
while (1)  % while ncalls<budget && k<kmax
    %fprintf(logfid, '==== RETROSPECTIVE ITERATION k = %d ====\n', k);
    kncalls = 0;
    % Calculate mk, bk.
    if yesgeom==1
        %mk=ceil(geoma*2^(k+1));  %抽樣數=30*(3^(k-1));
        mk=10*(3^(k-1)); %這是mh
        %bk=ceil(c2*k^3.5); 
        bk=100*(k^3.5);  %這是vh
    else
        mk=c1*ceil(k^q); %8*k^3.5
        bk=c2*ceil(k^q); %10*k^3.5
    end
    
    %fprintf(logfid, 'mk = %d, bk = %d\n', mk, bk);
    %fprintf(logfid, '===== BEGIN SPLINE =====\n');
    numbers=0;
    xk=x1.x;  % Initial sol. = sol. retured by previous call to SPLINE 
    lastRAipseed=iseed;  % Maintain a copy of i/p seed to the ongoing inner iteration 
    
    %disp(['Call SPLINE: New Sample Path'])
    %disp(['InnerIter:' num2str(k) ',mk=' num2str(mk)])
    %disp(['InnerIter:' num2str(k) ',bk=' num2str(bk)])
    
    %{
    -----------------------------------------------------------------------------------------
    RefMatrix_tau = -1*ones(RefMatrixSize);
    RefMatrix_AvgWT = -1*ones(RefMatrixSize);
    RefMatrix_Se_AvgWT = -1*ones(RefMatrixSize);
    RefMatrix_SecurityLevel = -1*ones(RefMatrixSize);
    RefMatrix_Cost = -1*ones(RefMatrixSize);
    RefMatrix_mobs = -1*ones(RefMatrixSize);
    RefMatrix_Seed = -1*ones(1,4,RefMatrixSize(1),RefMatrixSize(2));
    -----------------------------------------------------------------------------------------
    %}

    [ResultCutPara,kncalls,ncalls, stackflag, x1, iseed] = SPLINE(orchandle, ...
       problemparam, solverparam, xk, mk, bk, k, iseed, logfid,ncalls,budget,kncalls,ResultCutPara);	

    %ncalls = ncalls + splinencalls;
    %calculate the solutions number 使用總模擬次數計算已評估的解的數量
    if stackflag==0
        numbers = numbers + ncalls/mk;
        Solutions(k)=numbers;
        %disp(['numbers of solution =' num2str(numbers) 'in' num2str(k)])
    end 

    % Calculate phat=P{X^*\in \mathcal{F}}. Formula of phat assumes independent constraint functions
    %epsilon=min(max(x1.std/mk^0.45, -x1.constraint), x1.std/mk^0.1);
    %delta=(log(x1.std)-log(epsilon))/log(mk); %delta is a vector of size nsecMeas
    %delta(isnan(delta))=solverparam(5);    
    
    %x1phat=prod(tcdf(mk.^(0.5-delta)-x1.constraint./x1.std, mk-1));
    %上式為cgRSPLINE的真正可行解機率(P.27-式子(9))
    nk = x1.simunum;
    

    FO='-';                         % FO defaults to 'sample-path infeasible' 
    if stackflag == 1               % stackflag=1 implies no feasible solution found.
        if k==1
            %fprintf(logfid2, 'Initial solution is infeasible!!!\n');
        else
            %fprintf(logfid2, 'All solutions in stack are infeasible!!!\n');
        end
        ncalls = -5;
        kncalls = 0;
        return                      % Return control to cgR-SPLINE, restart local search
    end  
    k=k+1;
    % Exit R-SPLINE if budget is exceeded

    if ncalls>=budget
        disp(x1.fn)
        disp("now ncalls are "+ string(ncalls))
        FO ='F';        %BG modification 
        break;
    end
    
    
end
toc
end










