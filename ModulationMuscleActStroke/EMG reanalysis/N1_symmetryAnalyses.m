%% Group assessments
clear all
close all
clc

matfilespath='Z:\SubjectData\E01 Synergies\mat\HPF30\';

strokesNames={'P0001','P0002','P0003','P0004','P0005','P0006','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};%P0007 was removed because of contralateral atrophy
controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; %C0000 is removed because it is not a control for anyone, C0007 is removed because it was control for P0007

FM=[33, 26, 29, 21, 31, 31, 23, 30, 26, 30, 32, 32, 29, 32, 33];
load ([matfilespath,'groupedParams30HzPT11Fixed.mat']);

%define groups
groups{1}=controls.getSubGroup(controlsNames);
groups{2}=patients.getSubGroup(strokesNames);

%% Get normalized parameters:
%Define parameters we care about:
mOrder={'TA', 'PER', 'SOL', 'LG', 'MG', 'BF', 'SEMB', 'SEMT', 'VM', 'VL', 'RF', 'HIP', 'ADM', 'TFL', 'GLU'};
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

eE=1;
eL=5;
evLabel2={'iHS','','cTO','','','','cHS','','iTO','','',''};
evLabel={'sHS','','fTO','','','','fHS','','sTO','','',''};

% [eps] = defineEpochs({'lA'},{'Adaptation'}',[-40],[eE],[eL],'nanmedian');
[eps] = defineEpochs({'eA'},{'Adaptation'}',[-40],[eE],[eL],'nanmedian');
 [reps] = defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],'nanmedian');

%[reps] = defineEpochs({'lA'},{'Adaptation'}',[-40],[eE],[eL],'nanmedian');
%[eps] = defineEpochs({'eP'},{'Washout'}',[15],[eE],[eL],'nanmedian');

fi=figure;
subplot(1,2,1);
pc=gca;
[fi,pc,labels,dataEtemp,dataReftemp]=plotCheckerboards(groups{1},newLabelPrefix,eps,fi,pc,reps,2,'nanmedian');
set(gca,'CLim',[-0.5 0.5]);
subplot(1,2,2);
pc=gca;
[fi,pc,labels,dataEtemp,dataReftemp]=plotCheckerboards(groups{2},newLabelPrefix,eps,fi,pc,reps,2,'nanmedian');
set(gca,'CLim',[-0.5 0.5])
colorbar

%do analyses on ATS for controls
[dataEc,labels]=groups{1}.getPrefixedEpochData(newLabelPrefix,eps,true); %Padding with NaNs
[dataRefc,labels]=groups{1}.getPrefixedEpochData(newLabelPrefix,reps,true); %Padding with NaNs
Np=size(labels,1);
dataEc=reshape(dataEc,Np,length(newLabelPrefix),size(dataEc,2),size(dataEc,3));
dataRefc=reshape(dataRefc,Np,length(newLabelPrefix),size(dataRefc,2),size(dataRefc,3));
dataEc=dataEc-dataRefc;
for sj=1:length(groups{1}.adaptData)
    ATS=alignedTimeSeries(0,1/numel(evLabel),dataEc(:,:,:,sj),newLabelPrefix,ones(1,Np),evLabel);
    [ATS,iC,iI]=ATS.getSym;
    summData{1}(sj,1)=norm(ATS.Data(:,1:15))/(norm(ATS.Data(:,1:15))+norm(ATS.Data(:,16:30)));%asymmetric component 
    summData{1}(sj,2)=norm(ATS.Data(:,16:30))/(norm(ATS.Data(:,1:15))+norm(ATS.Data(:,16:30)));%symmetric component
    summData{1}(sj,3)=groups{1}.adaptData{sj}.subData.age;

    clear ATS
end

%do analyses on ATS for stroke
[dataEs,labels]=groups{2}.getPrefixedEpochData(newLabelPrefix,eps,true); %Padding with NaNs
[dataRefs,labels]=groups{2}.getPrefixedEpochData(newLabelPrefix,reps,true); %Padding with NaNs
Np=size(labels,1);
dataEs=reshape(dataEs,Np,length(newLabelPrefix),size(dataEs,2),size(dataEs,3));
dataRefs=reshape(dataRefs,Np,length(newLabelPrefix),size(dataRefs,2),size(dataRefs,3));
dataEs=dataEs-dataRefs;
for sj=1:length(groups{2}.adaptData)
    ATS=alignedTimeSeries(0,1/numel(evLabel),dataEs(:,:,:,sj),newLabelPrefix,ones(1,Np),evLabel);
    [ATS,iC,iI]=ATS.getSym;
    summData{2}(sj,1)=norm(ATS.Data(:,1:15))/(norm(ATS.Data(:,1:15))+norm(ATS.Data(:,16:30)));%asymmetric component
    summData{2}(sj,2)=norm(ATS.Data(:,16:30))/(norm(ATS.Data(:,1:15))+norm(ATS.Data(:,16:30)));%symmetric component
    summData{2}(sj,3)=groups{2}.adaptData{sj}.subData.age;
    clear ATS
end
% 
% [dataEc,labels]=groups{1}.getPrefixedEpochData(newLabelPrefix,eps,true); %Padding with NaNs
% [dataRefc,labels]=groups{1}.getPrefixedEpochData(newLabelPrefix,reps,true); %Padding with NaNs
% Np=size(labels,1);
% dataEc=reshape(dataEc,Np,length(newLabelPrefix),size(dataEc,2),size(dataEc,3));
% dataRefc=reshape(dataRefc,Np,length(newLabelPrefix),size(dataRefc,2),size(dataRefc,3));
% dataEc=dataEc-dataRefc;
% for sj=1:length(groups{1}.adaptData)
%     ATS=alignedTimeSeries(0,1/numel(evLabel),dataEc(:,:,:,sj),newLabelPrefix,ones(1,Np),evLabel);
%     [ATS,iC,iI]=ATS.getSym;
%     summData{1}(sj,1)=sum(sum(abs(ATS.Data(:,1:15))))/(sum(sum(abs(ATS.Data(:,1:15))))+sum(sum(abs(ATS.Data(:,16:30)))));%asymmetric component 
%     summData{1}(sj,2)=sum(sum(abs(ATS.Data(:,16:30))))/(sum(sum(abs(ATS.Data(:,1:15))))+sum(sum(abs(ATS.Data(:,16:30)))));%symmetric component
%     summData{1}(sj,3)=groups{1}.adaptData{sj}.subData.age;
%     clear ATS
% end
% 
% %do analyses on ATS for stroke
% [dataEs,labels]=groups{2}.getPrefixedEpochData(newLabelPrefix,eps,true); %Padding with NaNs
% [dataRefs,labels]=groups{2}.getPrefixedEpochData(newLabelPrefix,reps,true); %Padding with NaNs
% Np=size(labels,1);
% dataEs=reshape(dataEs,Np,length(newLabelPrefix),size(dataEs,2),size(dataEs,3));
% dataRefs=reshape(dataRefs,Np,length(newLabelPrefix),size(dataRefs,2),size(dataRefs,3));
% dataEs=dataEs-dataRefs;
% for sj=1:length(groups{2}.adaptData)
%     ATS=alignedTimeSeries(0,1/numel(evLabel),dataEs(:,:,:,sj),newLabelPrefix,ones(1,Np),evLabel);
%     [ATS,iC,iI]=ATS.getSym;
%     summData{2}(sj,1)=sum(sum(ATS.Data(:,1:15)))/(sum(sum(ATS.Data(:,1:15)))+sum(sum(ATS.Data(:,16:30))));%asymmetric component
%     summData{2}(sj,2)=sum(sum(ATS.Data(:,16:30)))/(sum(sum(ATS.Data(:,1:15)))+sum(sum(ATS.Data(:,16:30))));%symmetric component
%     summData{2}(sj,3)=groups{2}.adaptData{sj}.subData.age;
%     clear ATS
% end



figure; hold on
xdata=summData{1}(:,3);
ydata=summData{1}(:,2);
plot(xdata,ydata,'og','LineWidth',2,'MarkerSize',8)
xdata=summData{2}(:,3);
ydata=summData{2}(:,2);
plot(xdata,ydata,'or','LineWidth',2,'MarkerSize',8)
xdata=[summData{1}(:,3);summData{2}(:,3)];
ydata=[summData{1}(:,2);summData{2}(:,2)];

[r,m,b] = regression(xdata,ydata,'one');
rfit=b+xdata.*m;
plot(xdata,rfit,'LineWidth',2,'Color',[0.5 0.5 0.5])
[r2,p]=corrcoef(xdata,ydata);
xpos=get(gca,'XLim');ypos=get(gca,'YLim');
text(mean(xpos),max(ypos),['R = ',num2str(r2(2)),' p = ',num2str(p(2))],'FontSize',16,'FontWeight','bold');
ylabel('symmetric component');xlabel('age')
title('eP-Base')

figure; hold on
xdata=FM';
ydata=summData{2}(:,2);
plot(xdata,ydata,'or','LineWidth',2,'MarkerSize',8)
[r,m,b] = regression(xdata,ydata,'one');
rfit=b+xdata.*m;
plot(xdata,rfit,'LineWidth',2,'Color',[0.5 0.5 0.5])
[r2,p]=corrcoef(xdata,ydata);
xpos=get(gca,'XLim');ypos=get(gca,'YLim');
text(mean(xpos),max(ypos),['R = ',num2str(r2(2)),' p = ',num2str(p(2))],'FontSize',16,'FontWeight','bold');
ylabel('symmetric component');xlabel('FMA')
title('eP-Base')

figure
subplot(2,2,1)
hold on
title('eP-Base')
bar(1,nanmean(summData{1}(:,2)),'FaceColor','g');
bar(2,nanmean(summData{2}(:,2)),'FaceColor','r');
errorbar(1,nanmean(summData{1}(:,2)),nanstd(summData{1}(:,2)),'Color','k','LineWidth',2);
errorbar(2,nanmean(summData{2}(:,2)),nanstd(summData{2}(:,2)),'Color','k','LineWidth',2);
ylabel('symmetric component')
set(gca,'XTick',[1 2],'XTickLabel',{'Control','Stroke'})

