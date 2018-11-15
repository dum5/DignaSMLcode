%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Velocity corrected between group analysis stroke studies%%
%%                                                         %% 
%% Regressions for all dependend variables of interest     %%
%% with the following predeictors:                         %%
%% - Group                                                 %%
%% - velocity                                              %%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

%load Data
[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName]; 
load(loadName)

AddCombinedParamsToTable;
rob='on';
t.group=nominal(t.group);
t=t(t.fullGroup==1,:);


logfile='VelocityCorrectedBetweenGroupRobust';
diary(logfile);

%do regressions
disp('SINGLE LEG PARAMETERS')
lm=fitlm(t,'FF_Quad~group + vel','RobustOpts',rob)
lm=fitlm(t,'FF_skneeAngleAtSHS~group + vel','RobustOpts',rob)

disp('EMG PARAMETERS')
%lm=fitlm(t2,'BM~group + vel','RobustOpts',rob)
lm=fitlm(t,'lAMagn~group + vel','RobustOpts',rob)
lm=fitlm(t,'eAMagn~group + vel','RobustOpts',rob)
lm=fitlm(t,'ePMagn~group + vel','RobustOpts',rob)
lm=fitlm(t,'ePBMagn~group +vel','RobustOpts',rob)

disp('SYMMETRY KINEMATIC PARAMETERS')
lm=fitlm(t,'eA_B_spatialContributionNorm2~group + vel','RobustOpts',rob)
lm=fitlm(t,'lA_B_spatialContributionNorm2~group + vel','RobustOpts',rob)
lm=fitlm(t,'eP_lA_spatialContributionNorm2~group + vel','RobustOpts',rob)
lm=fitlm(t,'eP_B_spatialContributionNorm2~group + vel','RobustOpts',rob)

lm=fitlm(t,'eA_B_stepTimeContributionNorm2~group + vel','RobustOpts',rob)
lm=fitlm(t,'lA_B_stepTimeContributionNorm2~group + vel','RobustOpts',rob)
lm=fitlm(t,'eP_lA_stepTimeContributionNorm2~group + vel','RobustOpts',rob)
lm=fitlm(t,'eP_B_stepTimeContributionNorm2~group + vel','RobustOpts',rob)

lm=fitlm(t,'eA_B_velocityContributionNorm2~group + vel','RobustOpts',rob)
lm=fitlm(t,'lA_B_velocityContributionNorm2~group + vel','RobustOpts',rob)
lm=fitlm(t,'eP_lA_velocityContributionNorm2~group + vel','RobustOpts',rob)
lm=fitlm(t,'eP_B_velocityContributionNorm2~group + vel','RobustOpts',rob)

lm=fitlm(t,'eA_B_netContributionNorm2~group + vel','RobustOpts',rob)
lm=fitlm(t,'lA_B_netContributionNorm2~group + vel','RobustOpts',rob)
lm=fitlm(t,'eP_lA_netContributionNorm2~group + vel','RobustOpts',rob)
lm=fitlm(t,'eP_B_netContributionNorm2~group + vel','RobustOpts',rob)


diary off
txt=fileread(logfile);
txt=removeTags(txt);
fid=fopen(logfile,'w');
fwrite(fid,txt,'char');
fclose(fid);