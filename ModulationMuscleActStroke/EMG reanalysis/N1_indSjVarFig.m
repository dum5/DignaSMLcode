%% Group assessments
clear all
close all
clc

%matfilespath='Z:\Users\Digna\Projects\Synergy study\EMG reanalysis\Data\';
matfilespath='Z:\Users\Digna\Projects\Modulation of muscle activity in stroke\EMG reanalysis\Data'
figpath='Z:\Users\Digna\Projects\Modulation of muscle activity in stroke\EMG reanalysis\Figures\Individual subjects';
cd(figpath);
strokesNames={'P0001','P0002','P0003','P0004','P0005','P0006','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};
controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; %C0000 is removed because it is not a control for anyone, plus it has

%load ([matfilespath,'groupedParams_wMissingParametersNew.mat']);
load ([matfilespath,'groupedParams_wMissingParameters.mat']);
evLabel={'iHS','','cTO','','','','cHS','','iTO','','',''};
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
% 
% %Renaming normalized parameters, for convenience:
% for k=1:length(groups)
%     ll=groups{k}.adaptData{1}.data.getLabelsThatMatch('^Norm');
%     l2=regexprep(regexprep(ll,'^Norm',''),'_s','s');
%     groups{k}=groups{k}.renameParams(ll,l2);
% end
% newLabelPrefix=strcat(labelPrefix,'s');


newLabelPrefix=labelPrefix;
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

% [eps] = defineEpochs({'eA'},{'Adaptation'}',[15],[eE],[eL],'nanmean');
% [reps] = defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],'nanmean');

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
        
        %keyboard
        
        %plot slow leg
        figure
        ha=tight_subplot(5,3,[.04 .04],.04,.04);
        fullscreen
        x=[1:12];
        for m=1:15
            fig = gcf;
            fig.CurrentAxes = ha(m);
            title(labelPrefix{m})
            gca;hold on
            %for s=1:size(dtep,2)
                plot(x,dtep(:,:,m),'o-g')   
                plot(x,dtrep(:,:,m),'o-g','Color',[0.3 0.3 0.3])
                set(gca,'YTick',[0,1,2],'YTickLabel',{'0','1','2'},'YLim',[0 inf],'XTick',1:12,'XTickLabel',evLabel,'XLim',[0.5 12.5])
            %end         
            
            
        end
        
        print(fig,[groups{g}.adaptData{sj}.subData.ID, '_lA-Base_slow_200HZ'],'-djpeg')
        close all;clear fig ha
        %plot fast leg
        figure
        fullscreen
        ha=tight_subplot(5,3,[.04 .04],.04,.04);
        
        x=[1:12];
        for m=16:30
            fig = gcf;
            fig.CurrentAxes = ha(m-15);
            title(labelPrefix{m})
            gca;hold on
            %for s=1:size(dtep,2)
                plot(x,dtep([7:12,1:6],:,m),'o-g')   
                plot(x,dtrep([7:12,1:6],:,m),'o-g','Color',[0.3 0.3 0.3])
               set(gca,'YTick',[0,1,2],'YTickLabel',{'0','1','2'},'YLim',[0 inf],'XTick',1:12,'XTickLabel',evLabel,'XLim',[0.5 12.5])
            %end
            
           
            
        end
        print(fig,[groups{g}.adaptData{sj}.subData.ID, '_lA-Base_fast_200HZ'],'-djpeg')
        close all;clear fig ha
            
        
%         groups2{g}.epData{sj}=dtep;
%         groups2{g}.repData{sj}=dtrep;
%         groups2{g}.varData(:,:,sj)=dtvar;
    end
    
end
