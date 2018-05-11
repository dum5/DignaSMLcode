%% Group assessments
clear all
close all
clc

matfilespath1='Z:\Users\Digna\Projects\Synergy study\EMG reanalysis\Data\';
matfilespath2='Z:\SubjectData\E01 Synergies\mat\HPF200\';
figpath='Z:\Users\Digna\Projects\Synergy study\EMG reanalysis\Figures\CompareFilters';
cd(figpath);
strokesNames={'P0001','P0002','P0003','P0004','P0005','P0006','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};
controlsNames={'C0001','C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; %C0000 is removed because it is not a control for anyone, plus it has

%load ([matfilespath,'groupedParams_wMissingParametersNew.mat']);
load ([matfilespath1,'groupedParams_wMissingParametersNew.mat']);
evLabel={'iHS','','cTO','','','','cHS','','iTO','','',''};
%define groups
groups{1}=controls.getSubGroup(controlsNames);
groups{2}=patients.getSubGroup(strokesNames);
load ([matfilespath2,'groupedParams_wMissingParameters.mat']);
groupsb{1}=controls.getSubGroup(controlsNames);
groupsb{2}=patients.getSubGroup(strokesNames);

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
    
    ll=groupsb{k}.adaptData{1}.data.getLabelsThatMatch('^Norm');
    l2=regexprep(regexprep(ll,'^Norm',''),'_s','s');
    groupsb{k}=groupsb{k}.renameParams(ll,l2);
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
[ep1]=defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],'nanmean');
[ep2] = defineEpochs({'eA'},{'Adaptation'}',[15],[eE],[eL],'nanmean');
[ep3] = defineEpochs({'lA'},{'Adaptation'}',[-40],[eE],[eL],'nanmean');


for g=1:length(groups)
    for sj=1:length(groups{g}.adaptData)
        this30=groups{g}.adaptData{sj};
        this200=groupsb{g}.adaptData{sj};
        %this needs to become a 3D matrix with muscle, phase of gait and
        %stride number       
        dtep1_30=NaN(size(labels,1),ep1.Stride_No,size(labels,2));
        dtep2_30=NaN(size(labels,1),ep2.Stride_No,size(labels,2));
        dtep3_30=NaN(size(labels,1),ep3.Stride_No,size(labels,2));
        dtep1_200=NaN(size(labels,1),ep1.Stride_No,size(labels,2));
        dtep2_200=NaN(size(labels,1),ep2.Stride_No,size(labels,2));
        dtep3_200=NaN(size(labels,1),ep3.Stride_No,size(labels,2));
        
        for i=1:size(labels,1)
            if ep1.EarlyOrLate==0
                dtep1_30(i,:,:)=cell2mat(getEarlyLateData_v2(this30,labels(i,:),ep1.Condition,0,-1*ep1.Stride_No,ep1.ExemptFirst,ep1.ExemptLast,true));%Get data
                dtep1_200(i,:,:)=cell2mat(getEarlyLateData_v2(this200,labels(i,:),ep1.Condition,0,-1*ep1.Stride_No,ep1.ExemptFirst,ep1.ExemptLast,true));%Get data
            else
                dtep1_30(i,:,:)=cell2mat(getEarlyLateData_v2(this30,labels(i,:),ep1.Condition,0,ep1.Stride_No,ep1.ExemptFirst,ep1.ExemptLast,true));%Get data
                dtep1_200(i,:,:)=cell2mat(getEarlyLateData_v2(this200,labels(i,:),ep1.Condition,0,ep1.Stride_No,ep1.ExemptFirst,ep1.ExemptLast,true));%Get data
            end
            if ep2.EarlyOrLate==0
                dtep2_30(i,:,:)=cell2mat(getEarlyLateData_v2(this30,labels(i,:),ep2.Condition,0,-1*ep2.Stride_No,ep2.ExemptFirst,ep2.ExemptLast,true));%Get data
                dtep2_200(i,:,:)=cell2mat(getEarlyLateData_v2(this200,labels(i,:),ep2.Condition,0,-1*ep2.Stride_No,ep2.ExemptFirst,ep2.ExemptLast,true));%Get data
            else
                dtep2_30(i,:,:)=cell2mat(getEarlyLateData_v2(this30,labels(i,:),ep2.Condition,0,ep2.Stride_No,ep2.ExemptFirst,ep2.ExemptLast,true));%Get data
                dtep2_200(i,:,:)=cell2mat(getEarlyLateData_v2(this200,labels(i,:),ep2.Condition,0,ep2.Stride_No,ep2.ExemptFirst,ep2.ExemptLast,true));%Get data
            end
            if ep3.EarlyOrLate==0
                dtep3_30(i,:,:)=cell2mat(getEarlyLateData_v2(this30,labels(i,:),ep3.Condition,0,-1*ep3.Stride_No,ep3.ExemptFirst,ep3.ExemptLast,true));%Get data
                dtep3_200(i,:,:)=cell2mat(getEarlyLateData_v2(this200,labels(i,:),ep3.Condition,0,-1*ep3.Stride_No,ep3.ExemptFirst,ep3.ExemptLast,true));%Get data
            else
                dtep3_30(i,:,:)=cell2mat(getEarlyLateData_v2(this30,labels(i,:),ep3.Condition,0,ep3.Stride_No,ep3.ExemptFirst,ep3.ExemptLast,true));%Get data
                dtep3_200(i,:,:)=cell2mat(getEarlyLateData_v2(this200,labels(i,:),ep3.Condition,0,ep3.Stride_No,ep3.ExemptFirst,ep3.ExemptLast,true));%Get data            
            end           
        end
        
        x=[1:12];
        
        %plot slow leg
        figure
        ha=tight_subplot(5,3,[.04 .04],.04,.04);
        fullscreen     
        for m=1:15
            fig = gcf;
            fig.CurrentAxes = ha(m);
            title([labelPrefix{m} ' base_slow'])
            gca;hold on
            %for s=1:size(dtep,2)
                plot(x,dtep1_200(:,:,m),'o-g')   
                plot(x,dtep1_30(:,:,m),'o-g','Color',[0.3 0.3 0.3])
                set(gca,'YTick',[0,1,2],'YTickLabel',{'0','1','2'},'YLim',[0 inf],'XTick',1:12,'XTickLabel',evLabel,'XLim',[0.5 12.5])
            %end         
            
            
        end
        
        print(fig,[groups{g}.adaptData{sj}.subData.ID, '_BaseSlow'],'-djpeg')
        close all;clear fig ha
        
        %plot fast leg
        figure
        fullscreen
        ha=tight_subplot(5,3,[.04 .04],.04,.04);
        
        for m=16:30
            fig = gcf;
            fig.CurrentAxes = ha(m-15);
            title([labelPrefix{m} ' base_fast'])
            gca;hold on
            %for s=1:size(dtep,2)
            plot(x,dtep1_200([7:12,1:6],:,m),'o-g')
            plot(x,dtep1_30([7:12,1:6],:,m),'o-g','Color',[0.3 0.3 0.3])
            set(gca,'YTick',[0,1,2],'YTickLabel',{'0','1','2'},'YLim',[0 inf],'XTick',1:12,'XTickLabel',evLabel,'XLim',[0.5 12.5])
            %end
            
            
            
        end
        print(fig,[groups{g}.adaptData{sj}.subData.ID, '_BaseFast'],'-djpeg')
        close all;clear fig ha
        
        
        
         %plot slow leg
        figure
        ha=tight_subplot(5,3,[.04 .04],.04,.04);
        fullscreen     
        for m=1:15
            fig = gcf;
            fig.CurrentAxes = ha(m);
            title([labelPrefix{m} ' eA_slow'])
            gca;hold on
            %for s=1:size(dtep,2)
                plot(x,dtep2_200(:,:,m),'o-g')   
                plot(x,dtep2_30(:,:,m),'o-g','Color',[0.3 0.3 0.3])
                set(gca,'YTick',[0,1,2],'YTickLabel',{'0','1','2'},'YLim',[0 inf],'XTick',1:12,'XTickLabel',evLabel,'XLim',[0.5 12.5])
            %end         
            
            
        end
        
        print(fig,[groups{g}.adaptData{sj}.subData.ID, '_eASlow'],'-djpeg')
        close all;clear fig ha
        
        %plot fast leg
        figure
        fullscreen
        ha=tight_subplot(5,3,[.04 .04],.04,.04);
        
        for m=16:30
            fig = gcf;
            fig.CurrentAxes = ha(m-15);
            title([labelPrefix{m} ' eA_fast'])
            gca;hold on
            %for s=1:size(dtep,2)
            plot(x,dtep2_200([7:12,1:6],:,m),'o-g')
            plot(x,dtep2_30([7:12,1:6],:,m),'o-g','Color',[0.3 0.3 0.3])
            set(gca,'YTick',[0,1,2],'YTickLabel',{'0','1','2'},'YLim',[0 inf],'XTick',1:12,'XTickLabel',evLabel,'XLim',[0.5 12.5])
            %end
            
            
            
        end
        print(fig,[groups{g}.adaptData{sj}.subData.ID, '_eAFast'],'-djpeg')
        close all;clear fig ha
        
        figure
        ha=tight_subplot(5,3,[.04 .04],.04,.04);
        fullscreen     
        for m=1:15
            fig = gcf;
            fig.CurrentAxes = ha(m);
            title([labelPrefix{m} ' lA_slow'])
            gca;hold on
            %for s=1:size(dtep,2)
                plot(x,dtep3_200(:,:,m),'o-g')   
                plot(x,dtep3_30(:,:,m),'o-g','Color',[0.3 0.3 0.3])
                set(gca,'YTick',[0,1,2],'YTickLabel',{'0','1','2'},'YLim',[0 inf],'XTick',1:12,'XTickLabel',evLabel,'XLim',[0.5 12.5])
            %end         
            
            
        end
        
        print(fig,[groups{g}.adaptData{sj}.subData.ID, '_lASlow'],'-djpeg')
        close all;clear fig ha
        
        %plot fast leg
        figure
        fullscreen
        ha=tight_subplot(5,3,[.04 .04],.04,.04);
        
        for m=16:30
            fig = gcf;
            fig.CurrentAxes = ha(m-15);
            title([labelPrefix{m} ' lA_fast'])
            gca;hold on
            %for s=1:size(dtep,2)
            plot(x,dtep3_200([7:12,1:6],:,m),'o-g')
            plot(x,dtep3_30([7:12,1:6],:,m),'o-g','Color',[0.3 0.3 0.3])
            set(gca,'YTick',[0,1,2],'YTickLabel',{'0','1','2'},'YLim',[0 inf],'XTick',1:12,'XTickLabel',evLabel,'XLim',[0.5 12.5])
            %end
            
            
            
        end
        print(fig,[groups{g}.adaptData{sj}.subData.ID, '_lAFast'],'-djpeg')
        close all;clear fig ha
        
        
        
            
        
%         groups2{g}.epData{sj}=dtep;
%         groups2{g}.repData{sj}=dtrep;
%         groups2{g}.varData(:,:,sj)=dtvar;
    end
    
end
