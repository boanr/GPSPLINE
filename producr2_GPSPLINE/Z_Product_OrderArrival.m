function [ OrderArrival_Pro, sim_time, bigs, inv_level, point_OrderArrival]=Z_Product_OrderArrival(Product_No, OrderArrival_Pro, sim_time, bigs, inv_level, point_OrderArrival)

	inv_level(1,Product_No) = inv_level(1,Product_No) + bigs(1,Product_No);
	point_OrderArrival(1,Product_No)=0;




	OrderArrival_Pro(1,Product_No) = 1.0e30;

end