function [DemandOrders, BigLamda,bigs,ProductNumber,inv_level,num_months,smalls,area_holding,area_shortage,total_ordering_cost,sim_time,time_last_event,demand_expo_Parameter,DemandArriveTime,OrderArrival_Pro,Demand_Uniform_Parameter,incremental_cost,setup_cost,Holding_Cost,Shortage_Cost,Uniform_Parameter,point_OrderArrival,LostOrders]...
    =Z_Initialize(r,Q)


bigs=Q;
ProductNumber=2;
inv_level=zeros(1,ProductNumber);
inv_level(1,1)=2000;
inv_level(1,2)=2000;
% inv_level(1,3)=500;
% inv_level(1,4)=300;
% inv_level(1,5)=300;
num_months=90;
smalls=r;
area_holding=zeros(1,ProductNumber);
area_shortage=zeros(1,ProductNumber);
total_ordering_cost=zeros(1,ProductNumber);
%----------------------------------
sim_time = 0;
time_last_event=0;
%----------------------------------
demand_expo_Parameter=zeros(ProductNumber,2);
%normal distridution(mean,std)
demand_expo_Parameter(1,1)=1.3/24;
demand_expo_Parameter(1,2)=0.5/24;
demand_expo_Parameter(2,1)=1.6/24;
demand_expo_Parameter(2,2)=0.5/24;
% demand_expo_Parameter(1,3)=120;
% demand_expo_Parameter(1,4)=0.2;
% demand_expo_Parameter(1,5)=0.1;
%----------------------------------
DemandArriveTime=zeros(1,ProductNumber);
for i=1:ProductNumber
	first_time=random('Normal',demand_expo_Parameter(i,1),demand_expo_Parameter(i,2));
	DemandArriveTime(1,i)=sim_time+first_time;
end
%----------------------------------
OrderArrival_Pro=zeros(1,ProductNumber);
for i=1:ProductNumber
	OrderArrival_Pro(1,i)=1.0e30;
end
%----------------------------------

%訂單需求
Demand_Uniform_Parameter=zeros(ProductNumber,2);
Demand_Uniform_Parameter(1,1)=5;
Demand_Uniform_Parameter(1,2)=35;
Demand_Uniform_Parameter(2,1)=10;
Demand_Uniform_Parameter(2,2)=45;
% prob_distrib_demand=zeros(4,ProductNumber);
% distrib_demand_constant=0;
% demand=[5,10,30,35];
% prob_distrib_demand(4,1)=1.0000;
%----------------------------------
setup_cost=zeros(1,ProductNumber);

%----------------------------------
incremental_cost=zeros(1,ProductNumber);
%Holding_Cost的一半
incremental_cost(1,1)=1*0.1;
incremental_cost(1,2)=1.05*0.1;
% incremental_cost(1,3)=120;
% incremental_cost(1,4)=4.5;
% incremental_cost(1,5)=3.5;
%----------------------------------
Holding_Cost=zeros(1,ProductNumber);
Holding_Cost(1,1)=1;
Holding_Cost(1,2)=1.05;
% Holding_Cost(1,3)=0.60;
% Holding_Cost(1,4)=4.5;
% Holding_Cost(1,5)=3.5;
%----------------------------------
Shortage_Cost=zeros(1,ProductNumber);
Shortage_Cost(1,1)=1;
Shortage_Cost(1,2)=1.05;
% Shortage_Cost(1,3)=0.03;
% Shortage_Cost(1,4)=4.5;
% Shortage_Cost(1,5)=3.5;
%----------------------------------
% lead time
Uniform_Parameter=zeros(ProductNumber,2);
Uniform_Parameter(1,1)=4;
Uniform_Parameter(1,2)=5;
Uniform_Parameter(2,1)=3;
Uniform_Parameter(2,2)=4;
% Uniform_Parameter(3,1)=1400;
% Uniform_Parameter(3,2)=4320;
% Uniform_Parameter(4,1)=0.09;
% Uniform_Parameter(4,2)=0.11;
Uniform_Parameter(5,1)=0.12;
Uniform_Parameter(5,2)=0.14;
%----------------------------------
point_OrderArrival=zeros(1,ProductNumber);
%----------------------------------
DemandOrders=zeros(1,ProductNumber);
LostOrders=zeros(1,ProductNumber);
BigLamda=zeros(1,ProductNumber);
for i =1:ProductNumber
        BigLamda(1,i)=((Demand_Uniform_Parameter(i,1)+Demand_Uniform_Parameter(i,2))/2)*(num_months/demand_expo_Parameter(i,1));
end
end