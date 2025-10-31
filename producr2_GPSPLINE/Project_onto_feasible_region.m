%主要程式
function [ResultCutPara,instrument]=Project_onto_feasible_region(ResultCutPara,SPLI_best,gamma,ix1)
    ResultCutPara=GenerateCut(SPLI_best,gamma,ResultCutPara);
    instrument = CheckCut(ix1,ResultCutPara);
end