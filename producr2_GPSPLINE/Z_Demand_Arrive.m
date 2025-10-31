function [ DemandOrders,DemandArriveTime, demand_expo_Parameter, OrderArrival_Pro, point_OrderArrival, inv_level, LostOrders, sim_time, Uniform_Parameter, setup_cost, incremental_cost, smalls, bigs, total_ordering_cost]...
    =Z_Demand_Arrive(DemandOrders,Demand_Uniform_Parameter,Product_No,WarmupPeriod, DemandArriveTime, demand_expo_Parameter, OrderArrival_Pro, point_OrderArrival, inv_level,LostOrders, sim_time, Uniform_Parameter, setup_cost, incremental_cost, smalls, bigs, total_ordering_cost)
  [Demand_count]=Z_random_integer(Demand_Uniform_Parameter,Product_No) ;
  for i=1:Demand_count
    DemandOrders(1,Product_No)=DemandOrders(1,Product_No)+1;
    inv_level(1,Product_No) = inv_level(1,Product_No) -1;
	if inv_level(1,Product_No)<smalls(1,Product_No)
		if point_OrderArrival(1,Product_No)==0
			%計算訂購成本
			if  sim_time >  WarmupPeriod
				total_ordering_cost(1,Product_No) = total_ordering_cost(1,Product_No)+  incremental_cost(1,Product_No) * bigs(1,Product_No);
			end
			%計算啥時來
			OrderArrival_Pro(1,Product_No)=sim_time+random('Uniform',Uniform_Parameter(Product_No,1),Uniform_Parameter(Product_No,2));
			%訂了就不能再訂
			point_OrderArrival(1,Product_No)=1;
		end
    
 end
    if inv_level(1,Product_No)<0
        LostOrders(1,Product_No)=LostOrders(1,Product_No)+1;
    end
  end

  DemandArriveTime(1,Product_No) = DemandArriveTime(1,Product_No) + random('Normal',demand_expo_Parameter(Product_No,1),demand_expo_Parameter(Product_No,2));
  %Update_HoldingCost(Product_No,WarmupPeriod)
  %Update_SortaCost(Product_No,WarmupPeriod)
end