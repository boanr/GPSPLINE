function [Time_total_Cost,Total_SR,avg_area_holding]=Z_Ouput_data(DemandOrders,WarmupPeriod, sim_time , ProductNumber, area_holding, area_shortage, Holding_Cost, Shortage_Cost, total_ordering_cost,LostOrders,BigLamda)

ordering_cost=zeros(1,ProductNumber);
holding_cost=zeros(1,ProductNumber);
shortage_cost=zeros(1,ProductNumber);
SR=zeros(1,ProductNumber);
for i=1:ProductNumber
	area_holding(1,i) = area_holding(1,i)/(sim_time-WarmupPeriod);
	area_shortage(1,i) = area_shortage(1,i)/(sim_time-WarmupPeriod);
end
for i=1:ProductNumber
%     disp(total_ordering_cost(1,i));
% 	disp(area_holding(1,i));
% 	disp(area_shortage(1,i));
	ordering_cost(1,i) = total_ordering_cost(1,i);
	holding_cost(1,i) = Holding_Cost (1,i)* area_holding(1,i);
	shortage_cost(1,i) = Shortage_Cost(1,i) * area_shortage(1,i);
end   
Cost=sum(ordering_cost)+sum(holding_cost)+sum(shortage_cost);
Time_total_Cost  = Cost;
% fprintf(' area_holding %f \n\r',area_holding);
% fprintf(' area_shortage %f \n\r ',area_shortage);
% fprintf(' LostSales %f \n\r',LostSales);
% fprintf(' TotalDemand %f \n\r',TotalDemand);
SumBigLamda=sum(BigLamda);
for i=1:width(SR)
    SR(1,i)=(BigLamda(1,i)/SumBigLamda)*(LostOrders(1,i)/DemandOrders(1,i));
end
Total_SR=sum(SR);
avg_area_holding=sum(area_holding);
end