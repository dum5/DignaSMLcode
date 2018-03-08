%% Group assessments
clear all
close all
clc

matfilespath='Z:\SubjectData\E01 Synergies\mat\HPF30\';

strokesNames={'P0001','P0002','P0003','P0004','P0005','P0006','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};%P0007 was removed because of contralateral atrophy
controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; %C0000 is removed because it is not a control for anyone, C0007 is removed because it was control for P0007
patientFastList=strcat('P00',{'01','02','05','08','09','10','13','14','15','16'}); %Patients above .72m/s, which is the group mean. N=10. Mean speed=.88m/s. Mean FM=29.5 (vs 28.8 overall)
controlsSlowList=strcat('C00',{'01','02','04','05','06','07','09','10','12','16'}); %Controls below 1.1m/s (chosen to match pop size), N=10. Mean speed=.9495m/s

%patientFastList=strcat('P00',{'02','05','08','09','10','13','14','15','16'}); %
load ([matfilespath,'groupedParams30HzPT11Fixed.mat']);

%define groups
% groups{1}=controls.getSubGroup(controlsSlowList);
% groups{2}=patients.getSubGroup(patientFastList);
groups{1}=controls.getSubGroup(controlsNames);
groups{2}=patients.getSubGroup(strokesNames);

%% Get normalized parameters:
%Define parameters we care about:
mOrder={'TA', 'PER', 'SOL', 'LG', 'MG', 'BF', 'SEMB', 'SEMT', 'VM', 'VL', 'RF', 'HIP', 'ADM', 'TFL', 'GLU'};
%mOrder={'TA','SOL', 'LG', 'MG', 'BF', 'SEMB', 'SEMT', 'VM', 'VL', 'RF'};
nMusc=length(mOrder);
type='s';
labelPrefix=fliplr([strcat('f',mOrder) strcat('s',mOrder)]); %To display
labelPrefixLong= strcat(labelPrefix,['_' type]); %Actual names

%Renaming normalized parameters, for convenience:
for k=1:length(groups)
    ll=groups{k}.adaptData{1}.data.getLabelsThatMatch('^Norm');
    l2=regexprep(regexprep(ll,'^Norm',''),'_s','s');
    groups{k}=groups{k}.renameParams(ll,l2);
end
newLabelPrefix=fliplr(strcat(labelPrefix,'s'));

%first plot time courses of parameters of interest
% figure
% subplot(4,2,1)
% groups{1}.plotAvgTimeCourse('alphaSlow',{'TM base','Adaptation'},1,0,0,0,[],[],0,[],0,gca);title('Controls')
% subplot(4,2,3)
% groups{1}.plotAvgTimeCourse('alphaFast',{'TM base','Adaptation'},1,0,0,0,[],[],0,[],0,gca);
% subplot(4,2,5)
% groups{1}.plotAvgTimeCourse('XSlow',{'TM base','Adaptation'},1,0,0,0,[],[],0,[],0,gca);
% subplot(4,2,7)
% groups{1}.plotAvgTimeCourse('XFast',{'TM base','Adaptation'},1,0,0,0,[],[],0,[],0,gca);
% 
% subplot(4,2,2)
% groups{2}.plotAvgTimeCourse('alphaSlow',{'TM base','Adaptation'},1,0,0,0,[],[],0,[],0,gca);title('Stroke')
% subplot(4,2,4)
% groups{2}.plotAvgTimeCourse('alphaFast',{'TM base','Adaptation'},1,0,0,0,[],[],0,[],0,gca);
% subplot(4,2,6)
% groups{2}.plotAvgTimeCourse('XSlow',{'TM base','Adaptation'},1,0,0,0,[],[],0,[],0,gca);
% subplot(4,2,8)
% groups{2}.plotAvgTimeCourse('XFast',{'TM base','Adaptation'},1,0,0,0,[],[],0,[],0,gca);

%create EMG parameters
groups{1} = groups{1}.addNewParameter('QuadSlow',@(a,b,c,d,e,f,g)([a+b+c+d+e+f+g]/7),{'sRFs 1','sVLs 1','sVLs 2','sVLs 3','sVMs 1','sVMs 2','sVMs 3'},'mean quad activity early stance');
groups{1} = groups{1}.addNewParameter('QuadFast',@(a,b,c,d,e,f,g)([a+b+c+d+e+f+g]/7),{'fRFs 7','fVLs 7','fVLs 8','fVLs 9','fVMs 7','fVMs 8','fVMs 9'},'mean quad activity early stance');
groups{1} = groups{1}.addNewParameter('HamSlow',@(a,b,c,d,e,f)([a+b+c+d+e+f]/6),{'sSEMTs11','sSEMTs12','sSEMBs11','sSEMBs12','sBFs11','sBFs12'},'mean hamstring activity late swing');
groups{1} = groups{1}.addNewParameter('HamFast',@(a,b,c,d,e,f)([a+b+c+d+e+f]/6),{'fSEMTs 5','fSEMTs 6','fSEMBs 5','fSEMBs 6','fBFs 5','fBFs 6'},'mean hamstring activity late swing');
groups{1} = groups{1}.addNewParameter('HipFlexSlow',@(a,b,c,d)([a+b+c+d]/4),{'sTFLs 9','sTFLs10','sHips 9','sHips10'},'mean hip flexor activity early swing');
groups{1} = groups{1}.addNewParameter('HipFlexFast',@(a,b,c,d)([a+b+c+d]/4),{'fTFLs 3','fTFLs 4','fHips 3','fHips 4'},'mean hip flexor activity early swing');

groups{2} = groups{2}.addNewParameter('QuadSlow',@(a,b,c,d,e,f,g)([a+b+c+d+e+f+g]/7),{'sRFs 1','sVLs 1','sVLs 2','sVLs 3','sVMs 1','sVMs 2','sVMs 3'},'mean quad activity early stance');
groups{2} = groups{2}.addNewParameter('QuadFast',@(a,b,c,d,e,f,g)([a+b+c+d+e+f+g]/7),{'fRFs 7','fVLs 7','fVLs 8','fVLs 9','fVMs 7','fVMs 8','fVMs 9'},'mean quad activity early stance');
groups{2} = groups{2}.addNewParameter('HamSlow',@(a,b,c,d,e,f)([a+b+c+d+e+f]/6),{'sSEMTs11','sSEMTs12','sSEMBs11','sSEMBs12','sBFs11','sBFs12'},'mean hamstring activity late swing');
groups{2} = groups{2}.addNewParameter('HamFast',@(a,b,c,d,e,f)([a+b+c+d+e+f]/6),{'fSEMTs 5','fSEMTs 6','fSEMBs 5','fSEMBs 6','fBFs 5','fBFs 6'},'mean hamstring activity late swing');
groups{2} = groups{2}.addNewParameter('HipFlexSlow',@(a,b,c,d)([a+b+c+d]/4),{'sTFLs 9','sTFLs10','sHips 9','sHips10'},'mean hip flexor activity early swing');
groups{2} = groups{2}.addNewParameter('HipFlexFast',@(a,b,c,d)([a+b+c+d]/4),{'fTFLs 3','fTFLs 4','fHips 3','fHips 4'},'mean hip flexor activity early swing');


eE=1;
eL=5;
%evLabel={'iHS','','cTO','','','','cHS','','iTO','','',''};
[eps] = defineEpochs({'lA'},{'Adaptation'}',[-40],[eE],[eL],'nanmedian');
[reps] = defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],'nanmedian');

%get data for la and bse epochs
dataLAcontrols=getEpochData(groups{1},eps,{'alphaSlow','alphaFast','XSlow','XFast','QuadSlow','QuadFast','HamSlow','HamFast','HipFlexSlow','HipFlexFast','FZSmax','FZFmax','skneeAngleAtSHS','fkneeAngleAtFHS'},1);
dataLAstroke=getEpochData(groups{2},eps,{'alphaSlow','alphaFast','XSlow','XFast','QuadSlow','QuadFast','HamSlow','HamFast','HipFlexSlow','HipFlexFast','FZSmax','FZFmax','skneeAngleAtSHS','fkneeAngleAtFHS'},1);
dataLBcontrols=getEpochData(groups{1},reps,{'alphaSlow','alphaFast','XSlow','XFast','QuadSlow','QuadFast','HamSlow','HamFast','HipFlexSlow','HipFlexFast','FZSmax','FZFmax','skneeAngleAtSHS','fkneeAngleAtFHS'},1);
dataLBstroke=getEpochData(groups{2},reps,{'alphaSlow','alphaFast','XSlow','XFast','QuadSlow','QuadFast','HamSlow','HamFast','HipFlexSlow','HipFlexFast','FZSmax','FZFmax','skneeAngleAtSHS','fkneeAngleAtFHS'},1);
dataLA_BaseControls=dataLAcontrols-dataLBcontrols;
dataLA_BaseStroke=dataLAstroke-dataLBstroke;

T=table;
T.group=[repmat({'Controls'},length(groups{1}.adaptData),1);repmat({'Stroke'},length(groups{2}.adaptData),1)];
T.alphaSlow=[squeeze(dataLA_BaseControls(1,1,:));squeeze(dataLA_BaseStroke(1,1,:))];
T.alphaFast=[squeeze(dataLA_BaseControls(2,1,:));squeeze(dataLA_BaseStroke(2,1,:))];
T.XSlow=[squeeze(dataLA_BaseControls(3,1,:));squeeze(dataLA_BaseStroke(3,1,:))];
T.XFast=[squeeze(dataLA_BaseControls(4,1,:));squeeze(dataLA_BaseStroke(4,1,:))];
T.QuadSlow=[squeeze(dataLA_BaseControls(5,1,:));squeeze(dataLA_BaseStroke(5,1,:))];
T.QuadFast=[squeeze(dataLA_BaseControls(6,1,:));squeeze(dataLA_BaseStroke(6,1,:))];
T.HamSlow=[squeeze(dataLA_BaseControls(7,1,:));squeeze(dataLA_BaseStroke(7,1,:))];
T.HamFast=[squeeze(dataLA_BaseControls(8,1,:));squeeze(dataLA_BaseStroke(8,1,:))];
T.HipSlow=[squeeze(dataLA_BaseControls(9,1,:));squeeze(dataLA_BaseStroke(9,1,:))];
T.HipFast=[squeeze(dataLA_BaseControls(10,1,:));squeeze(dataLA_BaseStroke(10,1,:))];
T.BrakingSlow=[squeeze(dataLA_BaseControls(11,1,:));squeeze(dataLA_BaseStroke(11,1,:))];
T.BrakingFast=[squeeze(dataLA_BaseControls(12,1,:));squeeze(dataLA_BaseStroke(12,1,:))];
T.KneeSlow=[squeeze(dataLA_BaseControls(13,1,:));squeeze(dataLA_BaseStroke(13,1,:))];
T.KneeFast=[squeeze(dataLA_BaseControls(14,1,:));squeeze(dataLA_BaseStroke(14,1,:))];

% [fi,fb,pc1,ps1,pd1,pvalc1,pvals1,pvalb1,hc1,hs1,hb1,dataEc1,dataEs1,dataBinaryc1,dataBinarys1]=plotBGcompV2(fi,fb,pc1,ps1,pd1,eps,reps,newLabelPrefix,groups,0.1,0.05,'nanmedian');
% 
% [eps] = defineEpochs({'eA'},{'Adaptation'}',[15],[eE],[eL],'nanmedian');
% [reps] = defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],'nanmedian');
% [fi,fb,pc2,ps2,pd2,pvalc2,pvals2,pvalb2,hc2,hs2,hb2,dataEc2,dataEs2,dataBinaryc2,dataBinarys2]=plotBGcompV2(fi,fb,pc2,ps2,pd2,eps,reps,newLabelPrefix,groups,0.1,0.05,'nanmedian');
% 
% [eps] = defineEpochs({'eP'},{'Washout'}',[15],[eE],[eL],'nanmedian');
% [reps] = defineEpochs({'lA'},{'Adaptation'}',[-40],[eE],[eL],'nanmedian');
% [fi,fb,pc3,ps3,pd3,pvalc3,pvals3,pvalb3,hc3,hs3,hb3,dataEc3,dataEs3,dataBinaryc3,dataBinarys3]=plotBGcompV2(fi,fb,pc3,ps3,pd3,eps,reps,newLabelPrefix,groups,0.1,0.05,'nanmedian');
% 
% [eps] = defineEpochs({'eP'},{'Washout'}',[15],[eE],[eL],'nanmedian');
% [reps] = defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],'nanmedian');
% [fi,fb,pc4,ps4,pd4,pvalc4,pvals4,pvalb4,hc4,hs4,hb4,dataEc4,dataEs4,dataBinaryc4,dataBinarys4]=plotBGcompV2(fi,fb,pc4,ps4,pd4,eps,reps,newLabelPrefix,groups,0.1,0.05,'nanmedian');
% 
% 
% %TO DO set colormap for nonparameteric
% % whiteMiddleColorMap;
% % set(fi,'ColorMap',map2);
% set(ha(1:2,1),'CLim',[-1 1].*0.5);
% set(ha(1:2,2:end),'YTickLabels',{},'CLim',[-1 1].*0.5);
% set(ha(1,:),'XTickLabels','');
% set(ha(2,:),'XTick',(0:numel(evLabel)-1)/12,'CLim',[-1 1]*0.5);
% set(ha,'FontSize',8)
% pos=get(ha(1,end),'Position');
% axes(ha(1,end))
% colorbar
% set(ha(1,end),'Position',pos);
% 
% 
% set(hb(1:2,2:end),'YTickLabels',{},'CLim',[-1 1].*15);
% %set(ha(1,:),'XTickLabels','');
% set(hb,'XTick',(0:numel(evLabel)-1)/12,'CLim',[-1 1]*15);
% set(hb,'FontSize',8)
% pos=get(hb(1,end),'Position');
% axes(hb(1,end))
% colorbar
% set(hb(1,end),'Position',pos);
% set(hb(2,:),'Visible','off');
% 
