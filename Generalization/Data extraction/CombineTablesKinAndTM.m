clear all 
close all
clc

[file,path]=uigetfile('*.mat','choose file with kinematic events detection');
load([path,file]);
Tkin=T;
clear file path T

[file,path]=uigetfile('*.mat','choose file with treadmill events detection');
load([path,file]);

T.Kin_netContributionNorm2_TM_P(1:94)=NaN;
T.Kin_netContributionNorm2_TM_P(1:70)=Tkin.netContributionNorm2_TM_P(1:70);
T.Kin_pctGeneralization=(T.netContributionNorm2_OG_P./T.Kin_netContributionNorm2_TM_P)*100;