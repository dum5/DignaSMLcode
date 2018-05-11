%% Group assessments
clear all
close all
clc

matfilespath='Z:\Users\Digna\Projects\Modulation of muscle activity in stroke\EMG reanalysis\Data\'

strokesNames={'P0001','P0002','P0003','P0004','P0005','P0006','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};
controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; %C0000 is removed because it is not a control for anyone, plus it has

load ([matfilespath,'groupedParams30HzSOLp5Fix.mat']);

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
newLabelPrefix=strcat(labelPrefix,'s');

newLabelPrefix=reshape(newLabelPrefix,1,numel(newLabelPrefix)); %Putting in row form
aux=groups{1}.adaptData{1}.data.getLabelsThatMatch(['^' newLabelPrefix{1} '[ ]?\d+$']); %Assuming same suffix for all
Np=length(aux);
suffixes=cellfun(@(x) x(length(labelPrefix{1})+1:end),aux,'UniformOutput',false); %Extracting suffixes, I am lazy
labels=strcat(repmat(labelPrefix,Np,1),repmat(suffixes,1,length(labelPrefix))); %To do

eE=1;
eL=1;

%late adapt-TM base
[eps] = defineEpochs({'lA'},{'Adaptation'}',[-40],[eE],[eL],'nanmean');
[reps] = defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],'nanmean');

% eA-base 
% [eps] = defineEpochs({'eA'},{'Adaptation'}',[15],[eE],[eL],'nanmean');
% [reps] = defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],'nanmean');
% 
% %eP-La
% [eps] = defineEpochs({'eP'},{'Washout'}',[15],[eE],[eL],'nanmean');
% [reps] = defineEpochs({'lA'},{'Adaptation'}',[-40],[eE],[eL],'nanmean');


for g=1:length(groups)
    for sj=1:length(groups{g}.adaptData)
        this=groups{g}.adaptData{sj};
        %this needs to become a 3D matrix with muscle, phase of gait and
        %stride number       
        dtep=NaN(size(labels,1),eps.Stride_No,size(labels,2));
        dtrep=NaN(size(labels,1),reps.Stride_No,size(labels,2));
        dtvar=NaN(size(labels,1),size(labels,2));
        for i=1:size(labels,1)
            if eps.EarlyOrLate==0
                dtep(i,:,:)=cell2mat(getEarlyLateData_v2(this,labels(i,:),eps.Condition,0,-1*eps.Stride_No,eps.ExemptFirst,eps.ExemptLast,true));%Get data
            else
                dtep(i,:,:)=cell2mat(getEarlyLateData_v2(this,labels(i,:),eps.Condition,0,eps.Stride_No,eps.ExemptFirst,eps.ExemptLast,true));%Get data
            end
            if reps.EarlyOrLate==0
                dtrep(i,:,:)=cell2mat(getEarlyLateData_v2(this,labels(i,:),reps.Condition,0,-1*reps.Stride_No,reps.ExemptFirst,reps.ExemptLast,true));%Get data
            else
                dtrep(i,:,:)=cell2mat(getEarlyLateData_v2(this,labels(i,:),reps.Condition,0,reps.Stride_No,reps.ExemptFirst,reps.ExemptLast,true));%Get data
            end
            for k=1:size(labels,2)
                dtvar(i,k)=sqrt((nanstd(dtep(i,:,k).^2)/size(dtep,2))+(nanstd(dtrep(i,:,k).^2)/size(dtrep,2)));
            end
           
        end
        
        
        groups2{g}.epData{sj}=dtep;
        groups2{g}.repData{sj}=dtrep;
        groups2{g}.varData(:,:,sj)=dtvar;
    end
    
end

%plot individual slow leg data
figure
ha=tight_subplot(5,3,[.03 .005],.04,.04);
x=[1:12];


for m=1:size(labels,2)/2%make separate plot for each muscle
    fig = gcf;
    fig.CurrentAxes = ha(m);
    title(labelPrefix{m})   
    patch([0 13 13 0],[-0.05 -0.05 0.05 0.05],'k','FaceAlpha',0.5,'LineStyle','none')
    for p=1:size(labels,1)%all gait cycle phases go in one plot
        
        %plot controls
      
        
        %mean difference per subject
        %keyboard
       datac=squeeze([getEpochData(groups{1},eps,labels(p,m),true)-getEpochData(groups{1},reps,labels(p,m),true)]);
       gca;hold on
       bar(p-0.3,nanmedian(datac),'faceColor',[0.5 1 0.3],'barWidth',0.15);plot(p-0.32,datac,'.k','MarkerSize',2);
       errorbar(p-0.3,nanmedian(datac),nanstd(datac)/sqrt(length(datac)),'Color','k')
       %keyboard
        bar(p-0.1,nanmedian(squeeze(groups2{1}.varData(p,m,:))),'faceColor','g','barWidth',0.15);plot(p-0.12,squeeze(groups2{1}.varData(p,m,:)),'.k','MarkerSize',2);
        
        datas=squeeze([getEpochData(groups{2},eps,labels(p,m),true)-getEpochData(groups{2},reps,labels(p,m),true)]);
       
       bar(p+0.1,nanmedian(datas),'faceColor','r','barWidth',0.15);plot(p+0.08,datas,'.k','MarkerSize',2);
       errorbar(p+0.1,nanmedian(datas),nanstd(datas)/sqrt(length(datas)),'Color','k')
       %keyboard
        bar(p+0.3,nanmedian(squeeze(groups2{2}.varData(p,m,:))),'faceColor','r','barWidth',0.15);plot(p+0.28,squeeze(groups2{2}.varData(p,m,:)),'.k','MarkerSize',2);
%        
%        datas=squeeze([getEpochData(groups{2},eps,labels(p,m),true)-getEpochData(groups{2},reps,labels(p,m),true)]);
%        gca;hold on
%        bar(x(4*p-1),nanmean(datas),'faceColor',[0.5 1 0.3]);plot(x(4*p-1)-0.4,datas,'.k');
%        errorbar(x(4*p-1),nanmean(datas),nanstd(datas)/length(datas),'Color','r')
%        %keyboard
%        bar(x(4*p),nanmean(squeeze(groups2{2}.varData(p,m,:))),'faceColor','r');plot(x(4*p),squeeze(groups2{2}.varData(p,m,:)),'.k');
%        
       
%         %plot stroke
%         datac=squeeze([getEpochData(groups{2},eps,labels(p,m),true)-getEpochData(groups{2},reps,labels(p,m),true)]);
%        gca;hold on
%        bar(x(2*p),nanmean(datac),'faceColor','r')
%        for sj=1:15
%            plot(x(2*p)-0.5+(1/15)*sj,[nanmean(groups2{2}.epData{sj}(p,:,m))-nanmean(groups2{2}.repData{sj}(p,:,m))],'.k')
%        end
       
    end
        set(gca,'XLim',[0.5 12.5]) 
end
        
     dsfsdfdsf   
    

[eps] = defineEpochs({'eA'},{'Adaptation'}',[15],[eE],[eL],'nanmean');
[reps] = defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],'nanmean');
[f,p2c,ps2,pd2,pvalc2,pvals2,pvalb2,hc2,hs2,hb2,dataEc2,dataEs2]=plotBGcompCounts(f,pc2,ps2,pd2,eps,reps,newLabelPrefix,groups,0.05,0.1);

[eps] = defineEpochs({'eP'},{'Washout'}',[15],[eE],[eL],'nanmean');
[reps] = defineEpochs({'lA'},{'Adaptation'}',[-40],[eE],[eL],'nanmean');
[f,p3c,ps3,pd3,pvalc3,pvals3,pvalb3,hc3,hs3,hb3,dataEc3,dataEs3]=plotBGcompCounts(f,pc3,ps3,pd3,eps,reps,newLabelPrefix,groups,0.05,0.1);
