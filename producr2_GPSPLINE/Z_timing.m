function [Product_No,sim_time , next_event_type]=Z_timing(  DemandArriveTime, OrderArrival_Pro, ProductNumber, num_months,sim_time,next_event_type)											

next_event_type = 0;
Min_Time_Next_Event = 1.0e29;
Product_No = 0;
 %compare the demandarrivetime   
for i = 1:ProductNumber  
  if DemandArriveTime(1,i) < Min_Time_Next_Event
    Min_Time_Next_Event = DemandArriveTime(1,i);
    next_event_type = 1; 
    Product_No = i;
   end  
end

for i = 1:ProductNumber
    if OrderArrival_Pro(1,i) < Min_Time_Next_Event
		
        Min_Time_Next_Event = OrderArrival_Pro(1,i);
        next_event_type = 2;
        Product_No = i;
    end   
 
end

if num_months<=Min_Time_Next_Event
	Min_Time_Next_Event=num_months;
	next_event_type = 4;
end
sim_time = Min_Time_Next_Event;

end