function [random__integer]=Z_random_integer(Demand_Uniform_Parameter,Product_No)     
    random__integer=randi([Demand_Uniform_Parameter(Product_No,1) , Demand_Uniform_Parameter(Product_No,2)],1,1);
%     if Product_No==1
%     	%random__integer=random('Uniform',5,55);
%         random__integer=randsample(demand,1,true,prob_distrib_demand(:,1));
%     end
%     if Product_No==2
%     	random__integer=randsample(demand,1,true,prob_distrib_demand(:,2));
%     end
%     if Product_No==3
%     	random__integer=randsample(demand,1,true,prob_distrib_demand(:,3));
%     end
%     
end