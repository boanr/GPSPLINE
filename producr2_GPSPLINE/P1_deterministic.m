function [AWD]=P1_deterministic(x)
tic
global R;
global d;
global TC;
global WG;
global method;
WarmupPeriod=0; 
yy=size(x);
if yy(1)~=1
    x=x';
end
%% 進行模擬
if R==3
   result=zeros(1,7);
elseif R==5
   result=zeros(1,11);
end
sol=x;
D_Array=[]; % 放每個函數的值
D=struct('Sphere',{},'Rastrigin',{},'Rosebroke',{},'Absloute',{},'Griewank',{});
D(1).Sphere=sum(sol.^2);
D(1).Rastrigin=10*numel(sol)+sum(sol.^2-10*cos(2*pi*sol));
D(1).Rosebroke=sum(100*(sol(2:end)-sol(1:end-1).^2).^2+(sol(1:end-1)-1).^2);
if R==3
    D_Array=[D(1).Sphere,D(1).Rastrigin,D(1).Rosebroke];
end
if R==5
    D(1).Absloute=sum(abs(sol));
    n=numel(sol);
    SumPart=sum(sol.^2)/4000;
    ProPard=prod(cos(sol./sqrt(1:n)));
    D(1).Griewank=1+SumPart-ProPard;
    D_Array=[D(1).Sphere,D(1).Rastrigin,D(1).Rosebroke,D(1).Absloute,D(1).Griewank];
end
%新增Sr陣列
if R==3
    Sr=[12.5,10.125*d,45018*(d-1)];
elseif R==5
    Sr=[12.5,10.125*d,45018*(d-1),2.5*d,1+d/320];
end
std=0.005*Sr;

%建立Target陣列
if R==3
    if TC=="Moderate"
        T=[5*d,(10.25/2)*d,450*(d-1)];
    elseif TC=="Hard"
        T=[8*d,10.25*d,0];
    end
elseif R==5
    if TC=="Moderate"
        T=[5*d,(10.25/2)*d,450*(d-1),1.5*d,0.6+d/320];
    elseif TC=="Hard"
        T=[8*d,10.25*d,0,3*d,0.9+d/320];
    end 
end
%建立目標式的變數
if R==3
    if WG=="Sym"
        W_Ne=[1,1,1];
        W_Po=[1,1,1];
    elseif WG=="Asym"
        W_Ne=[2,2,2];
        W_Po=[1,1,1];
    elseif WG=="Prior"
        W_Ne=[2,1.5,1];
        W_Po=[2.5,5,1];
    end
elseif R==5
     if WG=="Sym"
        W_Ne=[1,1,1,1,1];
        W_Po=[1,1,1,1,1];
    elseif WG=="Asym"
        W_Ne=[2,2,2,2,2];
        W_Po=[1,1,1,1,1];
    elseif WG=="Prior"
        W_Ne=[2,1.6,1.3,1.1,1];
        W_Po=[2,1.6,1.3,1.1,1];
     end 
end
Obj_Ne=W_Ne./Sr;
Obj_Po=W_Po./Sr;
obj(1).fn1=D(1).Sphere;
obj(1).fn2=D(1).Rastrigin;
obj(1).fn3=D(1).Rosebroke;
if R==5
    obj(1).fn4=D(1).Absloute;
    obj(1).fn5=D(1).Griewank;
end
obj(1).sol=sol;
obj(1).D_Array=D_Array;
if method=="WGP"
    obj(1).obj=sum(Obj_Ne.*max(T-D_Array,0)+Obj_Po.*max(D_Array-T,0));
elseif method=="MGP"
    obj(1).obj=max(Obj_Ne.*max(T-D_Array,0)+Obj_Po.*max(D_Array-T,0));    
end

%新程式的輸出接口
if R==3
    result(1,1)=obj(1).fn1;
    result(1,2)=obj(1).fn2;
    result(1,3)=obj(1).fn3;
    result(1,4)=obj(1).fn1-T(1);
    result(1,5)=obj(1).fn2-T(2);
    result(1,6)=obj(1).fn3-T(3);
    result(1,7)= obj(1).obj;
    AWD=mean(result(:,7));
elseif R==5
    result(1,1)=obj(1).fn1;
    result(1,2)=obj(1).fn2;
    result(1,3)=obj(1).fn3;
    result(1,4)=obj(1).fn4;
    result(1,5)=obj(1).fn5;
    result(1,6)=obj(1).fn1-T(1);
    result(1,7)=obj(1).fn2-T(2);
    result(1,8)=obj(1).fn3-T(3);
    result(1,9)=obj(1).fn4-T(4);
    result(1,10)=obj(1).fn5-T(5);
    result(1,11)= obj(1).obj;
    AWD=mean(result(:,11));
end
% result = Z_main(r,Q,WarmupPeriod,10000,tr,omega);

% PCM=0;
% if APD==0
%     PCM=1;
% end
% PCMOne=0;


% new = [1250	1250	1750	1500];
% for i=1:height(new)
% 	ListWidth=width(new(i,:));
% 	bool_=0;
% 	for j=1:ListWidth
% 		if x(j)~=new(i,j)
% 			bool_=bool_+1;
% 		end
% 	end
% 	if bool_==0
% 		PCMOne=1;
% 	end
% end
toc
end