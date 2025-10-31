function [flag countvio]=checkconstraintfeasible(xconstraint,std,delta,mk,ncalls)

global visitpoint visitN k;

flag=0;
countvio=0;
for i=1:length(xconstraint)
    epilson_new = -(std(i)/mk.^delta(i))*10;
    if xconstraint(i) >epilson_new   %檢測所有限制式的違背
        countvio=countvio+1;
        flag=1; %當違背量>0，flag=1
    end
end

try
    visitpoint(visitN).epsilon1=(std(i)/mk.^delta(1));
    visitpoint(visitN).epsilon1=(std(i)/mk.^delta(2));
end

try
    visitpoint(visitN).k=k;
end


end
