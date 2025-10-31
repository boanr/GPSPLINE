%% ========================================================================
% 
function [ncalls, BTxnew, BTxnewphat, BTdelta, BTflag] = backtrack(orchandle, ...
    problemparam, solverparam, mk, iseed, alphar, logfid)
global AirportSecurityFlag
global mobs
% Searches trajectory for an alphar-feasible solution.
% If one isn't found, set BTflag to 0. (BTflag=1 if alpha_r feas sol is
% found)
% =========================================================================

% Declare global variables
global trajectory

% Problem parameters
id=int32(problemparam(2));
% nseeds=int32(problemparam(3));
% nsecMeas=int32(problemparam(4));

% Initialize backtrack varaibles
ncalls   =0;
iseedk   =iseed;
stack_ctr =size(trajectory,2); %Each column is a new vector
BTflag   =0;  % Alpha_r feasible solution not found

fprintf(logfid, 'Trajectory:\n');
for i=1:id
    for j=1:stack_ctr
        fprintf(logfid, '%d ', trajectory(i,j));
    end
    fprintf(logfid, '\n');
    
end

while stack_ctr>0
    %trajectory(:,stack_ctr)=[]; %this would delete x at location stackctr
    iseed=iseedk;
    [flag, BTxnew, iseed] = orchandle(problemparam, trajectory(:,stack_ctr), mk, iseed); %#ok<ASGLU>
    
    if flag == 0
        if AirportSecurityFlag == 1
          ncalls = ncalls + mobs; %mobs: Number of observations generated
        else
          ncalls = ncalls + mk;
        end    % Count mk only if x\in\mathbb{X}. 

        epsilon=min(max(sqrt(BTxnew.ConstraintCov*mk)/mk^0.45, -BTxnew.constraint), sqrt(BTxnew.ConstraintCov*mk)/mk^0.1);
        BTdelta=(log(sqrt(BTxnew.ConstraintCov*mk))-log(epsilon))/log(mk); %delta is a vector of size nsecMeas
        BTdelta(isnan(BTdelta))=solverparam(5);
        if sum(BTxnew.constraint > sqrt(mk*BTxnew.ConstraintCov)./mk.^BTdelta)>0
            flag=1;
        end
        BTxnewphat=prod(tcdf(mk.^(0.5-BTdelta)-BTxnew.constraint./sqrt(BTxnew.ConstraintCov), mk-1));
    
        if flag == 0 && BTxnewphat>=alphar
           % Initial solution is feasible and alphar-feas.
           BTflag=1;
           break
        end
    end
    stack_ctr=stack_ctr-1;
    
end

% PRINT TO LOG
if stack_ctr>0 
    fprintf(logfid, '\n\tBacktrack found a level alpha_r solution, xnew = [');
    fprintf(logfid, '%d ', BTxnew.x);	
    fprintf(logfid, ']\n');
    fprintf(logfid, '\tsecMeas = [');
    fprintf(logfid, '%.12f ', BTxnew.constraint);
    fprintf(logfid, ']\n\tsecMeasCov = [');
    fprintf(logfid, '%.12f ', BTxnew.ConstraintCov);
    fprintf(logfid, ']\n\txbestfn = %d, phat = %.12f\n', BTxnew.fn, BTxnewphat);
else
    fprintf(logfid, '\n\tBacktrack did not yield a level alpha_r solution.\n');
    % In which case xnew being returned is the first solution to enter the
    % stack
end

end

