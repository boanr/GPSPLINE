function [flag, result]=P1_SIMU(x,simunum,ncalls)
result=struct('x',{},'fn',{},'constraint',{},'std',{},'simunum',{});
%%
global R step;
global visitpoint visitN
%%
yy=size(x);
if yy(1)~=1
    x=x';
end
flag=0;
% omega=[1,13000,4.6];
% tr=[7000,	0.06,	100];
xmin=[ -5 ,-5,-5,-5,-5,-5,-5,-5,-5,-5];
xmax=[5,5,5,5,5,5,5,5,5,5];
for i=1:width(x)
	if x(i)>xmax(i) 
	    flag=1;
  end
    if  x(i)<xmin(i) 
	    flag=1;
    end
    if mod(x(i),step)~=0
	    flag=1;
   end
end
if flag==1
	check=x;
	result(1).x=check;
    return
end

%flag = 1為不可行解

visitN=visitN+1;
% r=[x(1),x(2)];
% Q=[x(3),x(4)];
WarmupPeriod=0; 
%% 進行模擬
[result1] = TestFunction(x,simunum);
if yy(1)~=1
    x=x';
end
%%
result(1).x=x;
if R==3
    result(1).fn=mean(result1(:,7));
elseif R==5
    result(1).fn=mean(result1(:,11));
end
result(1).simunum=simunum;
result(1).ncalls=ncalls;

visitpoint(visitN).x=result(1).x;
visitpoint(visitN).fn=result(1).fn;
visitpoint(visitN).simunum=result(1).simunum;
visitpoint(visitN).ncalls=result(1).ncalls;
visitN=visitN+1;
end


