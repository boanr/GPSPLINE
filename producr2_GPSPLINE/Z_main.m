function [ result] = Z_main( r,Q,WarmupPeriod,sim_num,tr,omega)
global p
p=p+1;
result=zeros(sim_num,7);
%disp("this time sampling "+string(sim_num)+" times")
for i=1:sim_num
    next_event_type=1;
    [ DemandOrders,BigLamda,bigs,ProductNumber,inv_level,num_months,smalls,area_holding,area_shortage,total_ordering_cost,sim_time,time_last_event,demand_expo_Parameter,DemandArriveTime,OrderArrival_Pro,Demand_Uniform_Parameter,incremental_cost,setup_cost,Holding_Cost,Shortage_Cost,Uniform_Parameter,point_OrderArrival,LostOrders]...
         =Z_Initialize(r,Q);
    while next_event_type ~=  4
    
	    [Product_No,sim_time , next_event_type]=Z_timing(  DemandArriveTime, OrderArrival_Pro, ProductNumber, num_months,sim_time,next_event_type);
	    [time_last_event,area_shortage,area_holding]=Z_update_time_avg_stats(WarmupPeriod, area_holding , area_shortage, ProductNumber, sim_time, time_last_event, inv_level);
	    if next_event_type == 1
	        [ DemandOrders,DemandArriveTime, demand_expo_Parameter, OrderArrival_Pro, point_OrderArrival, inv_level, LostOrders, sim_time, Uniform_Parameter, setup_cost, incremental_cost, smalls, bigs, total_ordering_cost]...
                  =Z_Demand_Arrive(DemandOrders,Demand_Uniform_Parameter,Product_No,WarmupPeriod, DemandArriveTime, demand_expo_Parameter, OrderArrival_Pro, point_OrderArrival, inv_level,LostOrders, sim_time, Uniform_Parameter, setup_cost, incremental_cost, smalls, bigs, total_ordering_cost);
	        continue;
	    elseif next_event_type == 2
		       [ OrderArrival_Pro, sim_time, bigs, inv_level, point_OrderArrival]...
               =Z_Product_OrderArrival(Product_No, OrderArrival_Pro, sim_time, bigs, inv_level, point_OrderArrival);
    
		       continue;
	    elseif next_event_type == 4
		       [Time_total_Cost1,Total_SR1,avg_area_holding1]=Z_Ouput_data(DemandOrders,WarmupPeriod, sim_time , ProductNumber, area_holding, area_shortage, Holding_Cost, Shortage_Cost, total_ordering_cost,LostOrders,BigLamda);
		       break;
	    end
    
    end
    result(i,1)=Time_total_Cost1;
    result(i,2)=Total_SR1;
    result(i,3)=avg_area_holding1;
    result(i,4)=Time_total_Cost1-tr(1,1);
    result(i,5)=Total_SR1-tr(1,2);
    result(i,6)=avg_area_holding1-tr(1,3);
	%0728模型改這裡
    result(i,7)=omega(1,1)*max([Time_total_Cost1-tr(1,1),0])+omega(1,2)*max([Total_SR1-tr(1,2),0])+omega(1,3)*max([avg_area_holding1-tr(1,3),0]);
end
end