clear all
close all
clc

%In this version the following has been updated
% - Patient selection has changed according to what we agreed on in Sept 2018
% - Regressions are performed on normalized vectors, since BM on the non-normalized data depends on
%   magnitude in the stroke group (rho=-0.55, p=0.046).
% - We use the first 5 strides to characterize feedback-generated activity
% - The data table for individual subjects will be generated with all 16
%   subjects, such that different selections are possible in subsequent
%   analyses (set allSubFlag to 1)
% - Analyses on group median data are performed with allSubFlag at 0,
%   subject selection depends on speedMatchFlag


[loadName,matDataDir]=uigetfile('*.mat');
loadName=[matDataDir,loadName];
load(loadName)

speedMatchFlag=0;
allSubFlag=0;%use this flag to generate the table that includes all subjects
%this needs to happen separately, since indices will be messed up ohterwise

groupMedianFlag=1; %do not change
nstrides=5;% do not change
summethod='nanmedian';% do not change

SubjectSelection% subjectSelection has moved to different script to avoid mistakes accross scripts

pIdx=1:length(strokesNames);
cIdx=1:length(controlsNames);

%define groups
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
newLabelPrefix2=newLabelPrefix([16:30,1:15]);

eE=1;
eL=1;
% 
% %eA-B
ep=defineEpochs({'eA'},{'Adaptation'}',[nstrides],[eE],[eL],summethod);
baseEp=defineEpochs({'Base'},{'TM base'}',[-40],[eE],[eL],summethod);

%eP-lA
ep2=defineEpochs({'eP'},{'Washout'}',[nstrides],[eE],[eL],summethod);
baseEp2=defineEpochs({'lA'},{'Adaptation'}',[-40],[eE],[eL],summethod);


%Generate figures
f1=figure('Name','EMG structure');
fb=figure;pd1=subplot(2,2,1);
%set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 6 4]);
set(f1,'Color',[1 1 1]','Units','inches','Position',[0 0 6 4]);
ax(1) = axes(f1,'Position',[0.1   0.52   0.2  0.45]);%controls minus EMGon
ax(2) = axes(f1,'Position',[0.1   0.03   0.2  0.45]);%stroke minus EMGon
ax(3) = axes(f1,'Position',[0.4   0.52   0.2  0.45]);
ax(4) = axes(f1,'Position',[0.4   0.03   0.2  0.45]);
ax(5) = axes(f1,'Position',[0.7   0.52   0.2  0.45]);
ax(6) = axes(f1,'Position',[0.7   0.03  0.2  0.45]);



[f1,fb,ax(1),ax(2),pd1,pvalc1,pvals1,pvalb1,hc1,hs1,hb1,dataEc1,dataEs1,dataBinaryc1,dataBinarys1]=plotBGcompV2(f1,fb,ax(1),ax(2),pd1,ep,baseEp,newLabelPrefix,groups,0.1,0.1,'invNanmedian');
    
[f1,fb,ax(3),ax(4),pd1,pvalc2,pvals2,pvalb2,hc2,hs2,hb2,dataEc2,dataEs2,dataBinaryc2,dataBinarys2]=plotBGcompV2(f1,fb,ax(3),ax(4),pd1,ep,baseEp,newLabelPrefix2,groups,0.1,0.1,'nanmedian');

[f1,fb,ax(5),ax(6),pd1,pvalc3,pvals3,pvalb3,hc3,hs3,hb3,dataEc3,dataEs3,dataBinaryc3,dataBinarys3]=plotBGcompV2(f1,fb,ax(5),ax(6),pd1,ep2,baseEp2,newLabelPrefix,groups,0.1,0.1,'nanmedian');

%[f1,fb,ax3,ax1,pd2,pvalc2,pvals2,pvalb2,hc2,hs2,hb2,dataEc2,dataEs2,dataBinaryc2,dataBinarys2]=plotBGcompV2(f1,fb,ax3,ax1,pd1,ep(4,:),baseEp,newLabelPrefix,groups,0.1,0.1,'nanmedian');



close(fb)

for a=1:6
    if a>4
        Ylab=get(ax(a),'YTickLabel');
        for l=1:length(Ylab)
            Ylab{l}=Ylab{l}(2:end-1);
            set(ax(a),'YTickLabel',Ylab,'YAxisLocation','right')
            
            for i=1:length(ax(a).YTickLabel)
                if i<16
                    ax(a).YTickLabel{i}=['\color[rgb]{0.466 0.674 0.188} ' ax(a).YTickLabel{i}];                    
                else
                    ax(a).YTickLabel{i}=['\color[rgb]{0.85,0.325,0.098} ' ax(a).YTickLabel{i}];
                   
                end
            end
        end
    else
        set(ax(a),'YTickLabel','')
        
    end
    set(ax(a),'FontSize',3,'CLim',[-0.5 0.5],'XTick',[1 4 7 10]./12,'XTickLabel',{'DS','SINGLE','DS','SWING'})
    title(ax(a),'');
    
    plot(ax(a),[0.4 1.6]./12,[-0.2 -0.2],'Color','k','LineWidth',2,'Clipping','off')
    plot(ax(a),[2.4 5.6]./12,[-0.2 -0.2],'Color','k','LineWidth',2,'Clipping','off')
    plot(ax(a),[6.4 7.6]./12,[-0.2 -0.2],'Color','k','LineWidth',2,'Clipping','off')
    plot(ax(a),[8.4 11.6]./12,[-0.2 -0.2],'Color','k','LineWidth',2,'Clipping','off')
    
    if a<3
        
        plot(ax(a),[-0.03 -0.03],[0 1],'Color',[0.5 0.5 0.5],'LineWidth',2,'Clipping','off')
        plot(ax(a),[-0.03 -0.03],[1 4.6],'Color',[0 0 0],'LineWidth',2,'Clipping','off')
        plot(ax(a),[-0.03 -0.03],[5.2 7.8],'Color',[0.5 0.5 0.5],'LineWidth',2,'Clipping','off')
        plot(ax(a),[-0.03 -0.03],[8 10.6],'Color',[0 0 0],'LineWidth',2,'Clipping','off')
        plot(ax(a),[-0.03 -0.03],[11.2 13.8],'Color',[0.5 0.5 0.5],'LineWidth',2,'Clipping','off')
        plot(ax(a),[-0.03 -0.03],[14 14.6],'Color',[0 0 0],'LineWidth',2,'Clipping','off')
        plot(ax(a),[-0.03 -0.03],[15.2 15.8],'Color',[0.5 0.5 0.5],'LineWidth',2,'Clipping','off')
        plot(ax(a),[-0.03 -0.03],[16 19.6],'Color',[0 0 0],'LineWidth',2,'Clipping','off')
        plot(ax(a),[-0.03 -0.03],[20.2 22.8],'Color',[0.5 0.5 0.5],'LineWidth',2,'Clipping','off')
        plot(ax(a),[-0.03 -0.03],[23 25.6],'Color',[0 0 0],'LineWidth',2,'Clipping','off')
        plot(ax(a),[-0.03 -0.03],[26.2 28.8],'Color',[0.5 0.5 0.5],'LineWidth',2,'Clipping','off')
        plot(ax(a),[-0.03 -0.03],[29 30],'Color',[0 0 0],'LineWidth',2,'Clipping','off')
        t1=text(ax(a),-0.1,0,2,'ANKLE','Rotation',90,'FontSize',4,'FontWeight','Bold');
        t2=text(ax(a),-0.1,6,2,'KNEE','Rotation',90,'FontSize',4,'FontWeight','Bold');
        t3=text(ax(a),-0.1,12,2,'HIP','Rotation',90,'FontSize',4,'FontWeight','Bold');
        t4=text(ax(a),-0.1,0+15,2,'ANKLE','Rotation',90,'FontSize',4,'FontWeight','Bold');
        t5=text(ax(a),-0.1,6+15,2,'KNEE','Rotation',90,'FontSize',4,'FontWeight','Bold');
        t6=text(ax(a),-0.1,12+15,2,'HIP','Rotation',90,'FontSize',4,'FontWeight','Bold');
        plot(ax(a),[-0.17 -0.17],[0 14.9],'LineWidth',2,'Color',[0.466 0.674 0.188],'Clipping','off')
        plot(ax(a),[-0.17 -0.17],[15.1 30],'LineWidth',2,'Color',[0.85,0.325,0.098],'Clipping','off')
        
       
        
        if a==1
            t7=text(ax(a),-0.27,2,2,'FAST/DOM','Rotation',90,'Color',[0.466 0.674 0.188],'FontSize',4,'FontWeight','Bold');
            t8=text(ax(a),-0.27,17,2,'SLOW/NON-DOM','Rotation',90,'Color',[0.85 0.325 0.098],'FontSize',4,'FontWeight','Bold');
        elseif a==2
            t7=text(ax(a),-0.27,2,2,'FAST/NON-PAR','Rotation',90,'Color',[0.466 0.674 0.188],'FontSize',4,'FontWeight','Bold');
            t8=text(ax(a),-0.27,17,2,'SLOW/PAR','Rotation',90,'Color',[0.85 0.325 0.098],'FontSize',4,'FontWeight','Bold');
            plot(ax(a),[0.2 0.4],[-4 -4],'LineWidth',2,'Color',[0.5 0.5 0.5],'Clipping','off')
            plot(ax(a),[0.2 0.4],[-6 -6],'LineWidth',2,'Color','k','Clipping','off')
            t10=text(ax(a),0.5,-4,2,'FLEXORS','FontSize',4);
            t11=text(ax(a),0.5,-6,2,'EXTENSORS','FontSize',4);
        end
        
    end
    
end

colorbar('peer',ax(2));
%map=flipud(repmat([0.3:0.01:1]',1,3));
%set(f1,'ColorMap',map);
cc=findobj(gcf,'Type','Colorbar');
cc.Location='southoutside';
cc.Position=[0.7354    0.0948    0.2000    0.03];
set(cc,'Ticks',[-0.5 0 0.5],'FontSize',6,'FontWeight','bold');
set(cc,'TickLabels',{'-50%','0%','+50%'});

 set(gcf,'Renderer','painters');
