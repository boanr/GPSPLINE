% TC=Target Conflic[Moderate,Hard]
% WG=Weight regimes[Sym,Asym,Prior]
global method
global scenario
method="MGP";
scenario="NoCut"; %["haveCut","NoCut"]
% [FINALLYRESULT]=Main(3,3,"Moderate","Sym");
% save savefile_3_3_Moderate_Sym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(3,3,"Moderate","Asym");
% save savefile_3_3_Moderate_Asym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(3,3,"Moderate","Prior");
% save savefile_3_3_Moderate_Prior.mat FINALLYRESULT;

[FINALLYRESULT]=Main(3,3,"Hard","Sym");
save savefile_3_3_Hard_Sym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(3,3,"Hard","Asym");
save savefile_3_3_Hard_Asym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(3,3,"Hard","Prior");
save savefile_3_3_Hard_Prior.mat FINALLYRESULT;











% [FINALLYRESULT]=Main(3,5,"Moderate","Sym");
% save savefile_3_5_Moderate_Sym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(3,5,"Moderate","Asym");
% save savefile_3_5_Moderate_Asym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(3,5,"Moderate","Prior");
% save savefile_3_5_Moderate_Prior.mat FINALLYRESULT;

[FINALLYRESULT]=Main(3,5,"Hard","Sym");
save savefile_3_5_Hard_Sym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(3,5,"Hard","Asym");
save savefile_3_5_Hard_Asym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(3,5,"Hard","Prior");
save savefile_3_5_Hard_Prior.mat FINALLYRESULT;












% 
% [FINALLYRESULT]=Main(5,3,"Moderate","Sym");
% save savefile_5_3_Moderate_Sym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(5,3,"Moderate","Asym");
% save savefile_5_3_Moderate_Asym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(5,3,"Moderate","Prior");
% save savefile_5_3_Moderate_Prior.mat FINALLYRESULT;

[FINALLYRESULT]=Main(5,3,"Hard","Sym");
save savefile_5_3_Hard_Sym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(5,3,"Hard","Asym");
save savefile_5_3_Hard_Asym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(5,3,"Hard","Prior");
save savefile_5_3_Hard_Prior.mat FINALLYRESULT;











% [FINALLYRESULT]=Main(5,5,"Moderate","Sym");
% save savefile_5_5_Moderate_Sym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(5,5,"Moderate","Asym");
% save savefile_5_5_Moderate_Asym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(5,5,"Moderate","Prior");
% save savefile_5_5_Moderate_Prior.mat FINALLYRESULT;

[FINALLYRESULT]=Main(5,5,"Hard","Sym");
save savefile_5_5_Hard_Sym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(5,5,"Hard","Asym");
save savefile_5_5_Hard_Asym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(5,5,"Hard","Prior");
save savefile_5_5_Hard_Prior.mat FINALLYRESULT;













% 
% [FINALLYRESULT]=Main(3,10,"Moderate","Sym");
% save savefile_3_10_Moderate_Sym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(3,10,"Moderate","Asym");
% save savefile_3_10_Moderate_Asym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(3,10,"Moderate","Prior");
% save savefile_3_10_Moderate_Prior.mat FINALLYRESULT;

[FINALLYRESULT]=Main(3,10,"Hard","Sym");
save savefile_3_10_Hard_Sym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(3,10,"Hard","Asym");
save savefile_3_10_Hard_Asym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(3,10,"Hard","Prior");
save savefile_3_10_Hard_Prior.mat FINALLYRESULT;














% [FINALLYRESULT,ResultCutPara]=Main(5,10,"Moderate","Sym");
% save savefile_5_10_Moderate_Sym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(5,10,"Moderate","Asym");
% save savefile_5_10_Moderate_Asym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(5,10,"Moderate","Prior");
% save savefile_5_10_Moderate_Prior.mat FINALLYRESULT;

[FINALLYRESULT]=Main(5,10,"Hard","Sym");
save savefile_5_10_Hard_Sym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(5,10,"Hard","Asym");
save savefile_5_10_Hard_Asym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(5,10,"Hard","Prior");
save savefile_5_10_Hard_Prior.mat FINALLYRESULT;





















global scenario
scenario="haveCut"; %["haveCut","NoCut"]
% [FINALLYRESULT]=Main(3,3,"Moderate","Sym");
% save Cutsavefile_3_3_Moderate_Sym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(3,3,"Moderate","Asym");
% save Cutsavefile_3_3_Moderate_Asym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(3,3,"Moderate","Prior");
% save Cutsavefile_3_3_Moderate_Prior.mat FINALLYRESULT;

[FINALLYRESULT]=Main(3,3,"Hard","Sym");
save Cutsavefile_3_3_Hard_Sym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(3,3,"Hard","Asym");
save Cutsavefile_3_3_Hard_Asym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(3,3,"Hard","Prior");
save Cutsavefile_3_3_Hard_Prior.mat FINALLYRESULT;










% 
% [FINALLYRESULT]=Main(3,5,"Moderate","Sym");
% save Cutsavefile_3_5_Moderate_Sym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(3,5,"Moderate","Asym");
% save Cutsavefile_3_5_Moderate_Asym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(3,5,"Moderate","Prior");
% save Cutsavefile_3_5_Moderate_Prior.mat FINALLYRESULT;

[FINALLYRESULT]=Main(3,5,"Hard","Sym");
save Cutsavefile_3_5_Hard_Sym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(3,5,"Hard","Asym");
save Cutsavefile_3_5_Hard_Asym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(3,5,"Hard","Prior");
save Cutsavefile_3_5_Hard_Prior.mat FINALLYRESULT;












% 
% [FINALLYRESULT]=Main(5,3,"Moderate","Sym");
% save Cutsavefile_5_3_Moderate_Sym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(5,3,"Moderate","Asym");
% save Cutsavefile_5_3_Moderate_Asym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(5,3,"Moderate","Prior");
% save Cutsavefile_5_3_Moderate_Prior.mat FINALLYRESULT;

[FINALLYRESULT]=Main(5,3,"Hard","Sym");
save Cutsavefile_5_3_Hard_Sym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(5,3,"Hard","Asym");
save Cutsavefile_5_3_Hard_Asym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(5,3,"Hard","Prior");
save Cutsavefile_5_3_Hard_Prior.mat FINALLYRESULT;











% [FINALLYRESULT]=Main(5,5,"Moderate","Sym");
% save Cutsavefile_5_5_Moderate_Sym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(5,5,"Moderate","Asym");
% save Cutsavefile_5_5_Moderate_Asym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(5,5,"Moderate","Prior");
% save Cutsavefile_5_5_Moderate_Prior.mat FINALLYRESULT;

[FINALLYRESULT]=Main(5,5,"Hard","Sym");
save Cutsavefile_5_5_Hard_Sym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(5,5,"Hard","Asym");
save Cutsavefile_5_5_Hard_Asym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(5,5,"Hard","Prior");
save Cutsavefile_5_5_Hard_Prior.mat FINALLYRESULT;














% [FINALLYRESULT]=Main(3,10,"Moderate","Sym");
% save Cutsavefile_3_10_Moderate_Sym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(3,10,"Moderate","Asym");
% save Cutsavefile_3_10_Moderate_Asym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(3,10,"Moderate","Prior");
% save Cutsavefile_3_10_Moderate_Prior.mat FINALLYRESULT;

[FINALLYRESULT]=Main(3,10,"Hard","Sym");
save Cutsavefile_3_10_Hard_Sym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(3,10,"Hard","Asym");
save Cutsavefile_3_10_Hard_Asym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(3,10,"Hard","Prior");
save Cutsavefile_3_10_Hard_Prior.mat FINALLYRESULT;













% 
% [FINALLYRESULT,ResultCutPara]=Main(5,10,"Moderate","Sym");
% save Cutsavefile_5_10_Moderate_Sym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(5,10,"Moderate","Asym");
% save Cutsavefile_5_10_Moderate_Asym.mat FINALLYRESULT;
% 
% [FINALLYRESULT]=Main(5,10,"Moderate","Prior");
% save Cutsavefile_5_10_Moderate_Prior.mat FINALLYRESULT;

[FINALLYRESULT]=Main(5,10,"Hard","Sym");
save Cutsavefile_5_10_Hard_Sym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(5,10,"Hard","Asym");
save Cutsavefile_5_10_Hard_Asym.mat FINALLYRESULT;

[FINALLYRESULT]=Main(5,10,"Hard","Prior");
save Cutsavefile_5_10_Hard_Prior.mat FINALLYRESULT;