clear all
close all
clc

[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName]; 
load(loadName)

strokesNames={'P0001','P0002','P0003','P0004','P0005','P0006','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};%P0007 was removed because of contralateral atrophy
controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; %C0000 is removed because it is not a control for anyone, C0007 is removed because it was control for P0007

useLateAdaptAsBaseline=false;

%define groups
groups{1}=controls.getSubGroup(controlsNames);
groups{2}=patients.getSubGroup(strokesNames);
%% Get normalized parameters:
%Define parameters we care about:
mOrder={'TA', 'PER', 'SOL', 'LG', 'MG', 'BF', 'SEMB', 'SEMT', 'VM', 'VL', 'RF', 'HIP', 'ADM', 'TFL', 'GLU'};

eE=1;
eL=1;
ep=defineEpochs({'BASE','eA','lA','eP','lP'},{'TM Base','Adaptation','Adaptation','Washout','Washout'},[-40 15 -40 15 -40],[eE eE eE eE eE],[eL eL eL eL eL],'nanmean');
%refEp=defineEpochs({'Base'},{'TM Base'}',[15],[eE],[eL],'nanmean');
refEp=defineEpochs({'lP'},{'Washout'}',[-40],[eE],[eL],'nanmean');

nMusc=length(mOrder);
type='s';
labelPrefix=fliplr([strcat('f',mOrder) strcat('s',mOrder)]); %To display
labelPrefixLong= strcat(labelPrefix,['_' type]); %Actual names



for i = 3%1:n_subjects
    adaptDataSubject = groups{2}.adaptData{1, i}; 
    
    %Alt Normalization
    ll=adaptDataSubject.data.getLabelsThatMatch('^Norm');
    l2=regexprep(regexprep(ll,'^Norm',''),'_s','m');
    adaptDataSubject=adaptDataSubject.renameParams(ll,l2);%replace old normalized parameters with random name to avoid collision of names
    clear ll l2
    adaptDataSubject=normalizeToBaselineEpoch(adaptDataSubject,labelPrefixLong,refEp,0);%normalize to alt baseline
    ll=adaptDataSubject.data.getLabelsThatMatch('^Norm');
    l2=regexprep(regexprep(ll,'^Norm',''),'_s','s');
    adaptDataSubject=adaptDataSubject.renameParams(ll,l2);
    newLabelPrefix=fliplr(strcat(labelPrefix,'s'));
    

    fh=figure('Units','Normalized','OuterPosition',[0 0 1 1]);
    %ph=tight_subplot(2,length(ep)+1,[.03 .005],.04,.04);
    ph=tight_subplot(2,length(ep),[.03 .005],.04,.04);
    
    flip=true;

    adaptDataSubject.plotCheckerboards(newLabelPrefix,ep,fh,ph(1,:),[],flip); %First, plot reference epoch:   
    [~,~,labels,dataE{1},dataRef{1}]=adaptDataSubject.plotCheckerboards(newLabelPrefix,ep,fh,ph(2,:),refEp,flip);%Second, the rest:

    set(ph(:,1),'CLim',[-1 1]);
    set(ph(:,2:end),'YTickLabels',{},'CLim',[-1 1].*.5);
    set(ph,'FontSize',8)
    pos=get(ph(1,end),'Position');
    axes(ph(1,end))
    colorbar
    set(ph(1,end),'Position',pos);
    
    
end