function [result]= TestFunction(x,sim_num)
    %變數名稱
    obj=struct('fn1',{},'fn2',{},'fn3',{},'fn4',{},'fn5',{},'sol',{},'D_Array',{},'noise',{},'T',{},'Sr',{},'obj',{},'listObj',{});
    global upper;
    global lower;
    global R;
    global d;
    global TC;
    global WG;
    global method;
    sol=[];     % 放每個變數的抽樣值
    D_Array=[]; % 放每個函數的值
    Sr=[];      %放每個目標式的標準化的值
    noise=[];   %放每個目標式的噪聲的值
    T=[];       %放每個目標式的基準標準的值
    W_Ne=[];    % W_r -
    W_Po=[];    % W_r +
    D=struct('Sphere',{},'Rastrigin',{},'Rosebroke',{},'Absloute',{},'Griewank',{});
    
    if R==3
        result=zeros(sim_num,7);
    elseif R==5
        result=zeros(sim_num,11);
    end
    
   %抽樣
   sol=x;
   for i=1:sim_num
        noise=[];
        D(1).Sphere=sum(sol.^2);
        D(1).Rastrigin=10*numel(sol)+sum(sol.^2-10*cos(2*pi*sol));
        D(1).Rosebroke=sum(100*(sol(2:end)-sol(1:end-1).^2).^2+(sol(1:end-1)-1).^2);
        D_Array=[D(1).Sphere,D(1).Rastrigin,D(1).Rosebroke];
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
        %新增Noise陣列
        noise=randn(1,R,1);
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
                W_Po=[2,1.5,1];
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
        obj(i).fn1=D(1).Sphere+noise(1);
        obj(i).fn2=D(1).Rastrigin+noise(2);
        obj(i).fn3=D(1).Rosebroke+noise(3);
        if R==5
            obj(i).fn4=D(1).Absloute+noise(4);
            obj(i).fn5=D(1).Griewank+noise(5);
        end
        obj(i).noise=noise;
        obj(i).sol=sol;
        obj(i).T=T;
        obj(i).Sr=Sr;
        obj(i).D_Array=D_Array;
        if method=="WGP"
            obj(i).listObj=Obj_Ne.*max(T-(D_Array+noise),0)+Obj_Po.*max((D_Array+noise)-T,0);
            obj(i).obj=sum(Obj_Ne.*max(T-(D_Array+noise),0)+Obj_Po.*max((D_Array+noise)-T,0));
        elseif method=="MGP"
            obj(i).listObj=Obj_Ne.*max(T-(D_Array+noise),0)+Obj_Po.*max((D_Array+noise)-T,0);
            obj(i).obj=max(Obj_Ne.*max(T-(D_Array+noise),0)+Obj_Po.*max((D_Array+noise)-T,0));
        end
        %新程式的輸出接口
        if R==3
            result(i,1)=obj(i).fn1;
            result(i,2)=obj(i).fn2;
            result(i,3)=obj(i).fn3;
            result(i,4)=obj(i).fn1-T(1);
            result(i,5)=obj(i).fn2-T(2);
            result(i,6)=obj(i).fn3-T(3);
            result(i,7)= obj(i).obj;
        elseif R==5
            result(i,1)=obj(i).fn1;
            result(i,2)=obj(i).fn2;
            result(i,3)=obj(i).fn3;
            result(i,4)=obj(i).fn4;
            result(i,5)=obj(i).fn5;
            result(i,6)=obj(i).fn1-T(1);
            result(i,7)=obj(i).fn2-T(2);
            result(i,8)=obj(i).fn3-T(3);
            result(i,9)=obj(i).fn4-T(4);
            result(i,10)=obj(i).fn5-T(5);
            result(i,11)= obj(i).obj;
        end
        
    end
end