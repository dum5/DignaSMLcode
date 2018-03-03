%% Assuming that the variables groups() exists (From N19_loadGroupedData)

loadName='groupedParams_wmissingParameters';
if (~exist('patients','var') || ~isa('patients','groupAdaptationData')) || (~exist('controls','var') || ~isa('controls','groupAdaptationData'))
    load(loadName)
end
% patientFastList=strcat('P00',{'01','02','05','08','09','10','13','14','15','16'}); %Patients above .72m/s, which is the group mean. N=10. Mean speed=.88m/s. Mean FM=29.5 (vs 28.8 overall)
% controlsSlowList=strcat('C00',{'01','02','04','05','06','07','09','10','12','16'}); %Controls below 1.1m/s (chosen to match pop size), N=10. Mean speed=.9495m/s
% patientUphillControlList={'C0001','C0002','C0003','C0004','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'};
% patientUphillList_={'P0001','P0002','P0003','P0004','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'}; %patients that did the uphill
% patientUphillList=strcat(patientUphillList_,'u'); %patients that did the uphill

%%
figuresColorMap
cc=condColors;

%% Define groups from lists:
% controlList=controls.ID;
% patientList=patients.ID;
groups{1}=controls.getSubGroup(controlsNames);
groups{2}=patients.getSubGroup(strokesNames);

%Remove bad strides?
%for k=1:length(groups)
%    groups{k}=groups{k}.removeBadStrides;
%end

%% Define epochs:
baseEp=getBaseEpoch; %defines baseEp
ep=getEpochs(); %Defines other epochs

if ~useLateAdapBase
    refEp=baseEp;
else
    refEp=ep(strcmp(ep.Properties.ObsNames,'late A'),:); 
end
refEp.Properties.ObsNames{1}=['Ref: ' refEp.Properties.ObsNames{1}];

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
newLabelPrefix=strcat(labelPrefix,'s');

%% Plot (and get data)
fh=figure('Units','Normalized','OuterPosition',[0 0 1 1]);
ph=tight_subplot(length(groups),length(ep)+1,[.03 .005],.04,.04);
flip=true;
summFlag='nanmedian';
clear dataE dataRef
for k=1:length(groups)
    groups{k}.plotCheckerboards(newLabelPrefix,refEp,fh,ph(k,1),[],flip); %First, plot reference epoch:   
    [~,~,labels,dataE{k},dataRef{k}]=groups{k}.plotCheckerboards(newLabelPrefix,ep,fh,ph(k,2:end),refEp,flip,summFlag);%Second, the rest:
end
set(ph(:,1),'CLim',[-1 1]);
set(ph(:,2:end),'YTickLabels',{},'CLim',[-1 1].*.5);
set(ph(1,:),'XTickLabels','');
set(ph(2,:),'Title',[]);
set(ph,'FontSize',8)
pos=get(ph(1,end),'Position');
axes(ph(1,end))
colorbar
set(ph(1,end),'Position',pos);
%% Do stats.plotCheckerboard
minEffectSize=.05; %At least 5% increase over max baseline activity
fdr=.1;
for k=1:length(groups)
    for i=1:length(ep)+1
        if i>1
            dd=reshape(dataE{k}(:,:,i-1,:),size(dataE{k},1)*size(dataE{k},2),size(dataE{k},4));
        else
            dd=reshape(dataRef{k}(:,:,i,:),size(dataRef{k},1)*size(dataRef{k},2),size(dataRef{k},4));
        end
        %effects that are significantly larger than the minEffectSize (MES)
%         [~,pR]=ttest(dd',minEffectSize,'tail','right');
%         [~,pL]=ttest(dd',-minEffectSize,'tail','left');
        for j=1:size(dd,1)
            [pR(j)]=signrank(dd(j,:),minEffectSize,'tail','right','method','exact');
            [pL(j)]=signrank(dd(j,:),-minEffectSize,'tail','left','method','exact');
        end
        p=2*min(pR,pL); %Two-tailed test for effect larger than MES: taking twice the minimum of the two p-values
        [h,pTh]=BenjaminiHochberg(p,fdr); %Conservative mult-comparisons: Benjamini & Hochberg approach
        %Add to plot:
        subplot(ph(k,i))
        hold on
        ss=findobj(gca,'type','Image');
        h1=nan(size(h));
        h1(h==1)=1;
        if i>1
            plot3(repmat([1:ss.XData(2)]',1,ss.YData(2)),repmat(1:ss.YData(2),ss.XData(2),1),reshape(h1,[ss.XData(2),ss.YData(2)])','ko','MarkerFaceColor','k','MarkerSize',4)
            aux=num2str(round(1e3*pTh)/1000,2);
            ph(k,i).Title.String=[{ph(k,i).Title.String}; {['p=' aux(2:end)]}];
        else
            aux2=num2str(round(1e2*fdr)/1e2,2);
            ph(k,i).Title.String=[{ph(k,i).Title.String}; {['FDR=' aux2]}];
        end
    end
end

%% Save
saveName=['allChangesEMG'];
% if plotSym==1
%     saveName=[saveName 'Sym'];
% end
% if matchSpeedFlag==1
%    saveName=[saveName '_speedMatched']; 
% elseif matchSpeedFlag==2
%     saveName=[saveName '_uphill'];
% end
% if removeP07Flag
%     saveName=[saveName '_noP07'];
% end
% if subCountFlag==1
%     saveName=[saveName '_subjCount_05pp'];
% end
if useLateAdapBase
    saveName=[saveName '_lateAdapBase'];
end
%saveFig(fh,dirStr,[saveName],0);
