%% ========================================================================
%  PLI
function [kncalls,ncalls, fbar, gamma, npoints, PLI_best, iseed] = PLI(orchandle, ...
    problemparam, solverparam, x, xbest, mk, iseed, logfid,kncalls,ncalls)
global AirportSecurityFlag
global mobs
global step;
% Note: PLI does not estimate prob. of feasibility.
% =========================================================================
% Problem parameters
%nseeds=int32(problemparam(3));
global ncalls;
%Solver parameter
ftol = 0;
id = length(x);
% Initialize variables for PLI
PLI_best    =struct('x',{},'fn',{},'simunum',{});
x0          =struct('x',{},'fn',{},'simunum',{});
gamma       =zeros(1,id);
npoints     =0;
%ncalls      =0;
iseedk      =iseed;
PLI_best(1).x = xbest;
x0(1).x     =floor(x);
strange     =3.145962987654;

z=x-x0.x;  
z=[1;z;0]; % z is a column vector 
[~, p]=sort(z, 'descend');
w=zeros(id+1,1); % w is a column vector
for ff=1:id+1		
	w(ff)=z(p(ff))-z(p(ff+1));
end	
wsum=0;
fbar=0;
%{
fprintf(logfid, '\t\t\t\t\tp z w\n');
for i=1:id+1
    fprintf(logfid, '\t\t\t\t\t%d %0.15f %0.15f\n', p(i), z(i), w(i));
end
fprintf(logfid, '\n\t\t\t\t\ti=1, ipseed = [');
fprintf(logfid, '%d ', iseed);
fprintf(logfid, '], mk=%d\n', mk);	
fprintf(logfid, '\t\t\t\t\tx0 = [');
fprintf(logfid, '%d ', x0.x);
fprintf(logfid, ']\n');
%}
% Call oracle at x0   %先對初始點進行模擬
[flag, x0] = orchandle(x0.x, mk,ncalls);
%feasible
if flag == 0

    ncalls = ncalls + mk;
    kncalls = kncalls + mk;	

    
end
if flag == 0
    npoints=npoints+1;
    wsum = wsum + w(1);
    fbar = fbar + w(1)*x0.fn;
    ghatold = x0.fn;
    PLI_best=x0;
%{
    %PRINT TO LOG
    fprintf(logfid, '\t\t\t\t\t secMeas = [');

    fprintf(logfid, ']\n');
    fprintf(logfid, '\t\t\t\t\tx0.fn = %.12f, w = %.12f, ghatold = %.12f\n\t\t\t\t\topseed = [', x0.fn, w(1), ghatold);
    fprintf(logfid, '%d ', iseed);
    fprintf(logfid, '], gbar=%.6f\n', fbar);	
    %END PRINT		
	%}
else   %如果第一個單體點(原點不符合可行解範圍)
    ghatold = 0;     
    PLI_best(1).fn = strange;
end

% Call oracle at the other id points that form the simplex
for i=2:id+1   %再對其他simplex point進行模擬-----------------------------------------------------
    %從加1改成減1是因為往下減才有更好的解(我demand設比較小)
    x0.x(p(i)-1)=x0.x(p(i)-1)+step;
    iseed=iseedk;
    %{
    fprintf(logfid, '\n\t\t\t\t\ti = %d, ipseed = [', i);
    fprintf(logfid, '%d ', iseed);
    fprintf(logfid, '], mk = %d\n', mk);
	fprintf(logfid, '\t\t\t\t\tx0 = [');
    fprintf(logfid, '%d ', x0.x);
    fprintf(logfid, ']\n');
    %}
    [flag, x0] = orchandle(x0.x, mk,ncalls);
    if flag == 0
        
        ncalls = ncalls + mk;
        kncalls = kncalls + mk;	

        
    end
    if flag == 0
        npoints=npoints+1;
        wsum = wsum + w(i);
        fbar = fbar + w(i)*x0.fn;
        gamma(p(i)-1) = x0.fn - ghatold;
        ghatold = x0.fn;

        %PRINTS
        %fprintf(logfid, '\t\t\t\t\tx0.fn = %.12f, w = %.12f, ghatold = %.12f\n\t\t\t\t\topseed = [', x0.fn, w(i), ghatold);
        %fprintf(logfid, '%d ', iseed);
        %fprintf(logfid, '], gbar=%0.6f, npoints=%d\n', fbar, npoints);
        %END PRINTS		

        if PLI_best.fn == strange || x0.fn < PLI_best.fn + ftol
            PLI_best=x0;
        end
%{
        %PRINTS
        fprintf(logfid, '\t\t\t\t\txbest.fn = %.12f\n\t\t\t\t\txbest = [', PLI_best.fn);
        fprintf(logfid, '%d ', PLI_best.x);
        fprintf(logfid, ']\n');
        fprintf(logfid, '\t\t\t\t\tsecMeas = [');
        fprintf(logfid, '%.12f ', PLI_best.constraint);
        fprintf(logfid, ']\n\n');
        %END PRINTS
        %}
    end
end

if wsum > ftol
    fbar = fbar/wsum;	
end

%fprintf(logfid, '\n\t\t\t\t\tgbar = %.12f, npoints = %d\n', fbar, npoints);
end
