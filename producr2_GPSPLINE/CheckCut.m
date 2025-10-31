%Project_onto_feasible_region要用的方法
function instrument = CheckCut(ix1,ResultCutPara)
    %遍立所有Cut，只要走第十四行，若未成立直到最後跳出迴圈
    global CutNum;
    for i=1:CutNum
        if ix1.fn-ResultCutPara(i).Gmk<dot(ResultCutPara(i).tao,ix1.x-ResultCutPara(i).X_best)
            instrument="stop";
            return;
        end
    end
    instrument="Evalate";
    return;
end