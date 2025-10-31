%Project_onto_feasible_region要用的方法
function [ResultCutPara]=GenerateCut(SPLI_best,gamma,ResultCutPara)
    global CutNum;
    yy=size(SPLI_best.x);
    if yy(1)~=1
        SPLI_best.x=SPLI_best.x';
    end
   
    CutNum=CutNum+1;
    %若平面更新超過100個，則FIFO取代
    % if CutNum>100 
    %     CutNum=1;
    % end
     %建立新的一般切平面
    ResultCutPara(CutNum).Gmk=SPLI_best.fn;
    ResultCutPara(CutNum).tao=gamma;
    ResultCutPara(CutNum).X_best=SPLI_best.x;
    
end