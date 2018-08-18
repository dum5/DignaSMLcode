%generate combined EMG parameters
t.Base_Quad=[t.Base_sVMs_1+t.Base_sVMs_2+t.Base_sVLs_1+t.Base_sVLs_2+t.Base_sRFs_1]./5;
t.lA_Quad=[t.lA_sVMs_1+t.lA_sVMs_2+t.lA_sVLs_1+t.lA_sVLs_2+t.lA_sRFs_1]./5;
t.eA_Quad=[t.eA_sVMs_1+t.eA_sVMs_2+t.eA_sVLs_1+t.eA_sVLs_2+t.eA_sRFs_1]./5;
%based on old between group sign
% t.Base_Quad=[t.Base_sVMs_1+t.Base_sVMs_2+t.Base_sVMs_3+t.Base_sVMs_4+...
%     t.Base_sVLs_3+t.Base_sVLs_4+t.Base_sVLs_1+t.Base_sVLs_2+t.Base_sRFs_1+t.Base_sRFs_4]./10;
% t.lA_Quad=[t.lA_sVMs_1+t.lA_sVMs_2+t.lA_sVMs_3+t.lA_sVMs_4+...
%     t.lA_sVLs_3+t.lA_sVLs_4+t.lA_sVLs_1+t.lA_sVLs_2+t.lA_sRFs_1+t.lA_sRFs_4]./10;
% t.Base_Ham=[t.Base_sBFs11+t.Base_sBFs12+t.Base_sSEMBs10+t.Base_sSEMBs11+t.Base_sSEMTs11]./5;
% t.lA_Ham=[t.lA_sBFs11+t.lA_sBFs12+t.lA_sSEMBs10+t.lA_sSEMBs11+t.lA_sSEMTs11]./5;
% t.Base_TA=[t.Base_sTAs_2+t.Base_sTAs_3+t.Base_sTAs_4]./3;
% t.eA_TA=[t.eA_sTAs_2+t.eA_sTAs_3+t.eA_sTAs_4]./3;
% t.lA_TA=[t.lA_sTAs_2+t.lA_sTAs_3+t.lA_sTAs_4]./3;



t.FF_Quad=t.lA_Quad-t.Base_Quad;
%t.FF_Ham=t.lA_Ham-t.Base_Ham;
t.FF_skneeAngleAtSHS=t.lA_skneeAngleAtSHS-t.Base_skneeAngleAtSHS;
%t.FB_sTA=t.eA_TA-t.Base_TA;
%t.FB_sTA_s2=t.eA_sTAs_2-t.Base_sTAs_2;
%t.DeltaAdaptsTA=t.eA_TA-t.lA_TA;

t.FB_Quad=t.eA_Quad-t.Base_Quad;
t.FB_skneeAngleAtSHS=t.eA_skneeAngleAtSHS-t.Base_skneeAngleAtSHS;