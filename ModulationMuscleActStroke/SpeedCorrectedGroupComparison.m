%% Velocity corrected between group
clear all
close all
clc

[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName]; 
load(loadName)

AddCombinedParamsToTable;
Idx=[1:19 21:30]';

rob='off';

t.group=nominal(t.group);
t2=t(Idx,:);


logfile='VelocityCorrectedBetweenGroupRobust';
diary(logfile);

disp('SYMMETRY PARAMETERS')
lm=fitlm(t,'eA_B_spatialContributionPNorm~group + vel','RobustOpts',rob)
lm=fitlm(t,'lA_B_spatialContributionPNorm~group + vel','RobustOpts',rob)
lm=fitlm(t,'eP_lA_spatialContributionPNorm~group + vel','RobustOpts',rob)
lm=fitlm(t,'eP_B_spatialContributionPNorm~group + vel','RobustOpts',rob)

lm=fitlm(t,'eA_B_stepTimeContributionPNorm~group + vel','RobustOpts',rob)
lm=fitlm(t,'lA_B_stepTimeContributionPNorm~group + vel','RobustOpts',rob)
lm=fitlm(t,'eP_lA_stepTimeContributionPNorm~group + vel','RobustOpts',rob)
lm=fitlm(t,'eP_B_stepTimeContributionPNorm~group + vel','RobustOpts',rob)

lm=fitlm(t,'eA_B_velocityContributionPNorm~group + vel','RobustOpts',rob)
lm=fitlm(t,'lA_B_velocityContributionPNorm~group + vel','RobustOpts',rob)
lm=fitlm(t,'eP_lA_velocityContributionPNorm~group + vel','RobustOpts',rob)
lm=fitlm(t,'eP_B_velocityContributionPNorm~group + vel','RobustOpts',rob)

lm=fitlm(t,'eA_B_netContributionPNorm~group + vel','RobustOpts',rob)
lm=fitlm(t,'lA_B_netContributionPNorm~group + vel','RobustOpts',rob)
lm=fitlm(t,'eP_lA_netContributionPNorm~group + vel','RobustOpts',rob)
lm=fitlm(t,'eP_B_netContributionPNorm~group + vel','RobustOpts',rob)

disp('SINGLE LEG PARAMETERS')
% lm=fitlm(t,'eA_B_alphaSlow~group + vel')
% lm=fitlm(t,'lA_B_alphaSlow~group + vel')
% lm=fitlm(t,'eP_lA_alphaSlow~group + vel')
% lm=fitlm(t,'eP_B_alphaSlow~group + vel')
% 
% lm=fitlm(t,'eA_B_alphaFast~group + vel')
% lm=fitlm(t,'lA_B_alphaFast~group + vel')
% lm=fitlm(t,'eP_lA_alphaFast~group + vel')
% lm=fitlm(t,'eP_B_alphaFast~group + vel')
% 
% lm=fitlm(t,'eA_B_xSlow~group + vel')
% lm=fitlm(t,'lA_B_xSlow~group + vel')
% lm=fitlm(t,'eP_lA_xSlow~group + vel')
% lm=fitlm(t,'eP_B_xSlow~group + vel')
% 
% lm=fitlm(t,'eA_B_xFast~group + vel')
% lm=fitlm(t,'lA_B_xFast~group + vel')
% lm=fitlm(t,'eP_lA_xFast~group + vel')
% lm=fitlm(t,'eP_B_xFast~group + vel')

lm=fitlm(t,'FF_skneeAngleAtSHS~group + vel','RobustOpts',rob)
lm=fitlm(t,'FB_skneeAngleAtSHS~group + vel','RobustOpts',rob)

disp('EMG PARAMETERS')

lm=fitlm(t2,'BM~group + vel','RobustOpts',rob)
lm=fitlm(t,'eAMagn~group + vel','RobustOpts',rob)
lm=fitlm(t2,'ePMagn~group + vel','RobustOpts',rob)
lm=fitlm(t2,'ePBMagn~group +vel','RobustOpts',rob)
lm=fitlm(t,'FF_Quad~group + vel','RobustOpts',rob)
lm=fitlm(t,'FB_Quad~group + vel','RobustOpts',rob)

diary off
txt=fileread(logfile);
txt=removeTags(txt);
fid=fopen(logfile,'w');
fwrite(fid,txt,'char');
fclose(fid);