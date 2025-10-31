function [x1] =check_x1(x1)
global demand1
global s_material1
global recipe_count
%1,  2    3  
%y12,y23,y13
if s_material1(1) <=  demand1(1)
    x1(recipe_count+1) =0;
    x1(recipe_count+3) =0;
end

if s_material1(2) <=  demand1(2)
    x1(recipe_count+2) =0;
end

%1,  2    3  
%y12,y23,y13

if s_material1(2) >=  demand1(2)
    x1(recipe_count+1) =0;
end

if s_material1(3) >=  demand1(3)
    x1(recipe_count+3) =0;
    x1(recipe_count+2) =0;
end
end




















