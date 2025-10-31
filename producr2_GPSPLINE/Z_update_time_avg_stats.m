function [time_last_event,area_shortage,area_holding]=Z_update_time_avg_stats(WarmupPeriod, area_holding , area_shortage, ProductNumber, sim_time, time_last_event, inv_level)
    time_since_last_event = sim_time - time_last_event;
    time_last_event = sim_time;
    
    for i=1:ProductNumber
		 if  sim_time >  WarmupPeriod
			if inv_level(1,i) < 0
				area_shortage(1,i) = area_shortage(1,i) - inv_level(1,i) * time_since_last_event;
			elseif inv_level(1,i) > 0 
				area_holding(1,i) = area_holding(1,i)+ inv_level(1,i) * time_since_last_event;
			end
		 end
   end
end