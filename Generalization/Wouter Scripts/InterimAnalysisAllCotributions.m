%% Computation of parameters
clear all
close all


% This section calculates the parameters we wanted to compute. First lines
% are selecting the StudyFile and %commented% is the savings of "old"
% figures
[file,path]=uigetfile('Z:\Users\Wouter\Generalization Young\Param files\*.mat','choose file to load');
load([path,file]);
% figdir=uigetdir('Z:\Users\Wouter\Generalization Young\Results\InterimAnalysis\','choose folder for figures');
% cd=figdir;



%remove Bias and Bad strides for all groups
groups=fieldnames(studyData);

for i=1:length(groups)
    dt=eval(['studyData.',groups{i}]);
    dt=removeBadStrides(dt);
   % dt=removeBias(dt);%remove median baseline for OG and TM trials separately
    eval(['studyData.',groups{i},'=dt'])
   clear dt
end

nafter= 5; %number of steps after effect OGp is without first step!!
nEarlyAdapt= 60; %Early adaptation error All Strides
nEarlyReAdapt= 20; %readaptation error
nLateAdapt= 50; %late adaptation error Late Adaptation is without last 10 strides
parameter=4;  % giving numbers of parameters collected which is 4 in this case StepPos Step Time StepVel and NetContributionNorm2
lmean=600; % Number of steps Mean error
fullerror=850; %Number of steps for the full trial
%get outcome measures per group

for i=1:length(groups)
    dt=eval(['studyData.',groups{i}]);
    start=151;
    if i==2;
        start=1;
    end%input(['Enter start frame for adaptation for group ',groups{i},': ']);
    for cc=1:parameter  %remove baseline manually!
        if i==5         
        ot.Ca{cc}=cell2mat(getGroupedData(dt,{'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netcontributionNorm2'},{'catch'},0,nafter,1,0)); %Catch except first 1
        ot.Ca{cc}=squeeze(ot.Ca{cc});
        ot.Ca{cc}=nanmean(ot.Ca{cc}(:,cc,:));
        ot.Ca{cc}=squeeze(ot.Ca{cc});
        ot.Ca{cc}=ot.Ca{cc}-ot.TMb{cc};
        end
        ot.OGb{cc}=cell2mat(getGroupedData(dt,{'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netcontributionNorm2'},{'OG base'},0,90,0,0));
        ot.OGb{cc}=(squeeze(ot.OGb{cc}));  % changing into matrix(data,parameter,subject)
        ot.OGb{cc}=nanmedian(ot.OGb{cc}(:,cc,:)); % getting individual median of every subject
        ot.OGb{cc}=squeeze(ot.OGb{cc}); % changing into matrix for removal in the end --> same is done for TMb OGp and TMp
        ot.TMb{cc}=cell2mat(getGroupedData(dt,{'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netcontributionNorm2'},{'TM base'},0,90,0,0));
        ot.TMb{cc}=squeeze(ot.TMb{cc});
        ot.TMb{cc}=(nanmedian(ot.TMb{cc}(:,cc,:)));
        ot.TMb{cc}=squeeze(ot.TMb{cc});
        ot.OGp{cc}=cell2mat(getGroupedData(dt,{'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netcontributionNorm2'},{'OG post'},0,nafter,1,0)); %OG post except first 1
        ot.OGp{cc}=squeeze(ot.OGp{cc});
        ot.OGp{cc}=nanmean(ot.OGp{cc}(:,cc,:));
        ot.OGp{cc}=squeeze(ot.OGp{cc});
        ot.TMp{cc}=cell2mat(getGroupedData(dt,{'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netcontributionNorm2'},{'TM post'},0,nafter,1,0)); %TM post except first 1
        ot.TMp{cc}=squeeze(ot.TMp{cc});
        ot.TMp{cc}=nanmean(ot.TMp{cc}(:,cc,:));
        ot.TMp{cc}=squeeze(ot.TMp{cc});
        

        ot.OGp{cc}=ot.OGp{cc}-ot.OGb{cc}; %removing baseline
        ot.TMp{cc}=ot.TMp{cc}-ot.TMb{cc}; %removing baseline

           
        ot.OGLA{cc}=cell2mat(getGroupedData(dt,{'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netcontributionNorm2'},{'OG post'},0,-1*50,10,0));
        ot.OGLA{cc}=squeeze(ot.OGLA{cc});
        ot.OGLA{cc}=nanmean(ot.OGLA{cc}(:,cc,:));
        ot.OGLA{cc}=squeeze(ot.OGLA{cc});
        ot.OGLA{cc}=ot.OGLA{cc}-ot.OGb{cc};
        ot.EA{cc}=cell2mat(getGroupedData(dt,{'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netcontributionNorm2'},{'gradual adaptation'},0,nEarlyAdapt,start,0));
        ot.EA{cc}=squeeze(ot.EA{cc});  %changing into matrix(data,parameter,subject
        ot.EA{cc}=nanmean(ot.EA{cc}(:,cc,:));   %mean for each subject
        ot.EA{cc}=squeeze(ot.EA{cc}); % changing into matrix for use of figures same for others LA ERA LRA
        ot.EA{cc}=ot.EA{cc}-ot.TMb{cc};
        ot.LA{cc}=cell2mat(getGroupedData(dt,{'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netcontributionNorm2'},{'gradual adaptation'},0,-1*nLateAdapt,0,10));
        ot.LA{cc}=squeeze(ot.LA{cc});
        ot.LA{cc}=nanmean(ot.LA{cc}(:,cc,:));
        ot.LA{cc}=squeeze(ot.LA{cc});
        ot.LA{cc}=ot.LA{cc}-ot.TMb{cc};
        ot.ERA{cc}=cell2mat(getGroupedData(dt,{'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netcontributionNorm2'},{'readaptation'},0,nEarlyReAdapt,0,0));
        ot.ERA{cc}=squeeze(ot.ERA{cc});
        ot.ERA{cc}=nanmean(ot.ERA{cc}(:,cc,:));
        ot.ERA{cc}=squeeze(ot.ERA{cc});
        ot.ERA{cc}=ot.ERA{cc}-ot.TMb{cc};
        ot.LRA{cc}=cell2mat(getGroupedData(dt,{'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netcontributionNorm2'},{'readaptation'},0,-1*nLateAdapt,0,10));
        ot.LRA{cc}=squeeze(ot.LRA{cc});
        ot.LRA{cc}=nanmean(ot.LRA{cc}(:,cc,:));
        ot.LRA{cc}=squeeze(ot.LRA{cc});
        ot.LRA{cc}=ot.LRA{cc}-ot.TMb{cc};
        if cc==4
           ot.AdaptExtent=ot.LA{1,4}-ot.LA{1,3};
           ot.AdaptExtentTM=ot.LRA{1,4}-ot.LRA{1,3};
        end
        eval(['AllData.',groups{i},'=ot;']);
    end
 
 
end
    
%%
%%get the data for time courses. All timecourse are in the end saved in 


for i=1:length(groups)
    dt=eval(['studyData.',groups{i}]);
    L=900; %input(['How long is the adaptation for: ',groups{i},': ']);
    start=151;
    if i==2;
        start=1;
    end%input(['Enter start frame for adaptation for group ',groups{i},': ']);
    for cc=1:parameter%% number of parameters
        ot.adapt{cc}=NaN(L-20,length(dt.adaptData));
        ot.readapt{cc}=NaN(290,length(dt.adaptData));
        ot.OGp{cc}=NaN(75,length(dt.adaptData));
        ot.TMp{cc}=NaN(580,length(dt.adaptData));
    end
    for sj=1:length(dt.adaptData)   %number of subjects
%         if i==1 && sj==7
%         else
            
            tempb=getParamInCond(dt.adaptData{sj},{'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netcontributionNorm2'},'OG base');
            tempb2=getParamInCond(dt.adaptData{sj},{'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netcontributionNorm2'},'TM base');
            for c=1: parameter
                tempbiasOG(c)=nanmedian(tempb(1:90,c)); %get median for each parameter in OG
                tempbiasTM(c)=nanmedian(tempb2(1:90,c)); %get median for each condition in Tm
            end
            for j=1:parameter %creating cells for each parameter. Each cell contains 10 subjects
                if i==5
                tempdata=getParamInCond(dt.adaptData{sj},{'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netcontributionNorm2'},'Catch');
                ot.Ca{j}(1:6,sj)=tempdata(1:6,j)-tempbiasOG(j);clear tempdata;%6 strides catch
                end
                tempdata1=getParamInCond(dt.adaptData{sj},{'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netcontributionNorm2'},'gradual adaptation');
                ot.adapt{j}(1:L-20,sj)=tempdata1(start:(start+L)-21,j)-tempbiasTM(j); clear tempdata;%this is the whole adaptation minus last few strides each cell represents a different parameter minus baseline
                tempdata=getParamInCond(dt.adaptData{sj},{'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netcontributionNorm2'},'readaptation');
                ot.readapt{j}(1:290,sj)=tempdata(1:290,j)-tempbiasTM(j);clear tempdata;%this is the whole readaptation minus last few strides
                tempdata=getParamInCond(dt.adaptData{sj},{'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netcontributionNorm2'},'OG post');
                ot.OGp{j}(1:75,sj)=tempdata(1:75,j)-tempbiasOG(j);clear tempdata;%75 strides OG post
                tempdata=getParamInCond(dt.adaptData{sj},{'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netcontributionNorm2'},'TM post');
                ot.TMp{j}(1:580,sj)=tempdata(1:580,j)-tempbiasTM(j);;%580 strides TM post
                tempdata2=getParamInCond(dt.adaptData{sj},{'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netcontributionNorm2'},'gradual adaptation');
                
                eval(['AllData.',groups{i},'.M600A{j}=nanmean(ot.adapt{j}(1:lmean,:));']);%all strides adaptation, exempt last 20
                eval(['AllData.',groups{i},'.M900A{j}(:,sj)=nanmean(tempdata2(1:fullerror,j));'])
                eval(['AllData.',groups{i},'.MRA{j}=nanmean(ot.readapt{j});']);%all strides readaptation exempt last 10
                eval(['AllTimecourses.',groups{i},'=ot;']);
                
            end
%         end
        
    end
end
clear tempdata clear tembpbiasOG tempbiasTM tempb tempb2 clear ot


%Calculating Context1 whicc is OGp as a % of Adapt Extent
  
for i=1:length(groups)
    eval(['dt3=AllData.',groups{i},'.OGp{4};';])
    eval(['dt4=AllData.',groups{i},'.TMp{4};';])
    eval(['dt1=AllData.',groups{i},'.AdaptExtent(:,1);';])
    eval(['dt2=AllData.',groups{i},'.OGp{1,4};';])
    eval(['dt5=AllData.',groups{i},'.AdaptExtentTM(:,1);';])
    Context1{i}=dt2./dt1*100;
    ContextTM{i}=dt4./dt5*100;
    OGtoTM1(:,i)=dt3./dt4*100;    
end

groups=fieldnames(AllData);
groups1=(groups([3 1 4])); %Gradual Abrupt no FB abrutp FB [0.2 0.2 1; 0.6 0 0.6; 0.6 0.6 0.6;];
groups2=(groups([3 5])); %No Fb Catch  [0.2 0.2 1;1 0.4 0];
groups3=(groups([3 2 5]));%Abrupt Full abrupt colorcodes=[0.2 0.2 1;0.8 0 0;1 0.4 0];
groups4=(groups([3 2]));  % 2 abrupt colorcode [0.2 0.2 1;0.2 0.4 0];
groups5=(groups([1 4 3 5 2]));%colorcodes=[0.2 0.2 1; 0.6 0 0.6; 0.6 0.6 0.6;1 0.4 0;0.8 0 0];
legend1=([{ 'No Feedback';'Gradual';'Feedback'}]);
legend2=([{ 'No Feedback';'Abrupt';'Catch'}]);
legend3=([{'Gradual';'Feedback'; 'No Feedback';'Catch';'Abrupt'}]);

  clear dt1 dt2 dt3 dt4 dt5
 

%% These are the first figures we made in september, I created a new script regarding figures so this is commented for now. 
% %%%%%%%%%%%%%%
% %make figures%
% %%%%%%%%%%%%%%
% 
% %time course adaptation and readaptation
% h=figure;
% x1=1:L-20;x2=length(x1)+10:length(x1)+299;
% hold on
% for k=1:parameter
%     subplot(4,1,k)
%     for i= 1:length(groups)
%         if i==1|| i==3||i==4
%         eval(['dt=nanmean(transpose(AllTimecourses.',groups{i},'.adapt{k}));';])
%         plot(x1,dt,'ok','MarkerFaceColor',colorcodes(i,:));hold on;
%         set (gca,'YLim',[-0.1 0.3])
%         if k==1
%             ylabel('Step Position')
%             title('Time course Adaptation and re-adaptation')
%         end
%         if k==2
%             ylabel('Step Time')
%         end
%         if k>=3
%             ylabel('Velocity Contribution')
%             set (gca,'FontSize',10,'YLim',[-0.3 0.05])
%         end
%         if k==4
%             ylabel('netContribution')
%         end
%     end
% 
%     hold on;
%     
%     for i= 1:length(groups)
%         eval(['dt=nanmean(transpose(AllTimecourses.',groups{i},'.adapt{k}));';])
%         eval(['nt=nanstd(transpose(AllTimecourses.',groups{i},'.adapt{k}));';])
%         eval(['n=length(studyData.',groups{i},'.adaptData);']);
%         nt=nt./sqrt(n);
%         patch([x1,fliplr(x1)],[dt+nt fliplr(dt-nt)],colorcodes(i,:),'FaceAlpha',0.2,'LineStyle','none');hold on;
%     end
%     
%     
%     for i= 1:length(groups)
%         eval(['dt=nanmean(transpose(AllTimecourses.',groups{i},'.readapt{k}));';])
%         plot(x2,dt,'ok','MarkerFaceColor',colorcodes(i,:));
%         eval(['nt=nanstd(transpose(AllTimecourses.',groups{i},'.readapt{k}));';])
%         eval(['n=length(studyData.',groups{i},'.adaptData);']);
%         nt=nt./sqrt(n);
%         patch([x2,fliplr(x2)],[dt+nt fliplr(dt-nt)],colorcodes(i,:),'FaceAlpha',0.2,'LineStyle','none');hold on;
%     end
%     end
% end
% legend(groups)
% set(gca,'XTick',[nanmean(x1) nanmean(x2)],'XTickLabel',{'Adaptation','Re-adaptation'})
% 
% 
% figure
% uiwait(gcf)
% print(h,[cd '\AdapTimeCourse'],'-dpng')
% close all
% 
% %% time courses after effects
% h=figure;
% x1=1:15;x2=21:35;
% colorcodes=[0.2 0.2 1; 0.6 0 0.6; 0.6 0.6 0.6;];
% hold on
% for k=1:parameter
%     subplot(4,1,k)
%     for i= 1:length(groups1)
%         eval(['dt=nanmean(transpose(AllTimecourses.',groups1{i},'.OGp{k}));';])
%         plot(x1,dt(1:15),'ok','MarkerFaceColor',colorcodes(i,:));hold on;
%         set (gca,'YLim',[-0.1 0.15])
%         if k==1
%             ylabel('Step Position')
%             title('Time course After effects')
%         end
%         if k==2
%             ylabel('Step Time')
%         end
%         if k==3
%             ylabel('Velocity Contribution')
%             set (gca,'FontSize',10,'YLim',[-0.1 0.05])
%         end
%         if k==4
%             set (gca,'YLim',[-0.05 0.2])
%             ylabel('netContribution')
%         end
%     end
%   
%     
%     for i= 1:length(groups1)
%         eval(['dt=nanmean(transpose(AllTimecourses.',groups1{i},'.OGp{k}));';])
%         eval(['nt=nanstd(transpose(AllTimecourses.',groups1{i},'.OGp{k}));';])
%         eval(['n=length(studyData.',groups1{i},'.adaptData);']);
%         nt=nt./sqrt(n);
%         patch([x1,fliplr(x1)],[dt(1:15)+nt(1:15) fliplr(dt(1:15)-nt(1:15))],colorcodes(i,:),'FaceAlpha',0.2,'LineStyle','none');hold on;
%     end
% end  
% legend (groups1)
%     for i= 1:length(groups)
%         eval(['dt=nanmean(transpose(AllTimecourses.',groups5{i},'.TMp{k}));';])
%         eval(['nt=nanstd(transpose(AllTimecourses.',groups5{i},'.TMp{k}));';])
%         eval(['n=length(studyData.',groups{i},'.adaptData);'])
%         nt=nt./sqrt(n);
%         plot(x2,dt(1:15),'ok','MarkerFaceColor',colorcodes(i,:));
%         patch([x2,fliplr(x2)],[dt(1:15)+nt(1:15) fliplr(dt(1:15)-nt(1:15))],colorcodes(i,:),'FaceAlpha',0.2,'LineStyle','none');hold on;
%     end
% 
% legend (groups)
% set(gca,'XTick',[nanmean(x1) nanmean(x2)],'XTickLabel',{'OG','TM'})
% 
% 
% 
% figure
% uiwait(gcf)
% print(h,[cd '\AfterEffectTimeCourse'],'-dpng')
% close all
% 
% %% bar plots errors adaptation
% x1=1:length(groups);
% x2=x1+length(x1)+1;
% h=figure;
% hold on
% for k=1:parameter
%     subplot(4,1,k)
%     for i=1:length(groups)
%         eval(['dt1=AllData.',groups{i},'.EA{k};';])
%         eval(['dt2=AllData.',groups{i},'.M900A{k};';])
%         bar([x1(i) x2(i)],[nanmean(dt1) nanmean(dt2)],'BarWidth',0.2,'FaceColor',colorcodes(i,:)); hold on;
%         set(gca,'FontSize',10,'YLim',[-0.1 0.2])
%         if k==1
%             ylabel('Step Position')
%             title('Errors Adaptation')
%         end
%         if k==2
%             ylabel('Step Time')
%         end
%         if k==3
%             ylabel('Velocity Contribution')
%             set (gca,'YLim',[-0.3 0.05])
%         end
%         if k==4
%             set (gca,'YLim',[-0.2 0.05])
%             ylabel('netContribution')
%         end
%     end
%     
%     
%     for i=1:length(groups)
%         eval(['dt1=AllData.',groups{i},'.EA{k};';])
%         eval(['dt2=AllData.',groups{i},'.M900A{k};';])
%         n=length(dt2);
%         errorbar([x1(i) x2(i)],[nanmean(dt1) nanmean(dt2)],[nanmean(dt1) nanmean(dt2)]./sqrt(n),'Color','k','LineStyle','none','LineWidth',2)
%         plot(repmat(x1(i),n,1),dt1,'ok');plot(repmat(x2(i),n,1),dt2,'ok');hold on;
%         
%     end
% end
% legend (groups)
% set(gca,'XTick',[nanmean(x1) nanmean(x2)],'XTickLabel',{['First ',num2str(nEarlyAdapt),' strides'],['All strides']})
% 
% figure
% uiwait(gcf)
% print(h,[cd '\BarplotErrorEA'],'-dpng')
% close all
% %% barplot readaptation
% h=figure;
% hold on;
% 
% for k=1:parameter
%     subplot(4,1,k)
%     for i=1:length(groups)
%         eval(['dt1=AllData.',groups{i},'.ERA{k};';])
%         eval(['dt2=AllData.',groups{i},'.MRA{k};';]) 
%         bar([x1(i) x2(i)],[nanmean(dt1) nanmean(dt2)],'BarWidth',0.2,'FaceColor',colorcodes(i,:)); hold on;
%         if k==1
%             ylabel('Step Position')
%             title('Errors Re-adaptation','fontsize',14)
%         end
%         if k==2
%             ylabel('Step Time')
%         end
%         if k==3
%             ylabel('Velocity Contribution')
%             set (gca,'YLim',[-0.4 0.05])
%         end
%         if k==4
%             set (gca,'YLim',[-0.2 0.05])
%             ylabel('netContribution')
%         end
%     end
%         for i=1:length(groups);
%         eval(['dt1=AllData.',groups{i},'.ERA{k};';])
%         eval(['dt2=AllData.',groups{i},'.MRA{k};';]) 
%         n=length(dt2);
%         errorbar([x1(i) x2(i)],[nanmean(dt1) nanmean(dt2)],[nanmean(dt1) nanmean(dt2)]./sqrt(n),'Color','k','LineStyle','none','LineWidth',2)
%         plot(repmat(x1(i),n,1),dt1,'ok');plot(repmat(x2(i),n,1),dt2,'ok');hold on;
%         end
%         
% 
% end
% legend(groups)
% set(gca,'XTick',[nanmean(x1) nanmean(x2)],'XTickLabel',{['First ',num2str(nEarlyReAdapt),' strides'],['All strides']})
% title('Errors during readaptation')
% figure
% uiwait(gcf)
% print(h,[cd '\BarplotErrorERA'],'-dpng')
% close all
% clear dt1 dt2
% 
% 
% %% bar plots after effecs
% h=figure;
% hold on
% for k=1:parameter
%     subplot(4,1,k)
%     for i=1:length(groups)
%         eval(['dt1=AllData.',groups{i},'.OGp{k};';])
%         eval(['dt2=AllData.',groups{i},'.TMp{k};';])
%         bar([x1(i) x2(i)],[nanmean(dt1) nanmean(dt2)],'BarWidth',0.2,'FaceColor',colorcodes(i,:));hold on;
%         set (gca,'YLim',[-0.1 0.15])
%         if k==1
%             ylabel('Step Position')
%             title('After Effects','fontsize',14)
%         end
%         if k==2
%             ylabel('Step Time')
%         end
%         if k==3
%             ylabel('Velocity Contribution')
%             set (gca,'YLim',[-0.05 0.1])
%         end
%         if k==4
%             set (gca,'YLim',[-0.05 0.3])
%             ylabel('netContribution')
%         end
%     
%     end
%     
%     for i=1:length(groups)
%         eval(['dt1=AllData.',groups{i},'.OGp{k};';])
%         eval(['dt2=AllData.',groups{i},'.TMp{k};';])
%         n=length(dt2);
%         errorbar([x1(i) x2(i)],[nanmean(dt1) nanmean(dt2)],[nanmean(dt1) nanmean(dt2)]./sqrt(n),'Color','k','LineStyle','none','LineWidth',2)
%         plot(repmat(x1(i),n,1),dt1,'ok');plot(repmat(x2(i),n,1),dt2,'ok'); hold on;
%         
%     end
% end
% clear dt1 dt2
% legend(groups)
% set(gca,'XTick',[nanmean(x1) nanmean(x2)],'XTickLabel',{['First ',num2str(nafter),' strides OG post'],['First ',num2str(nafter),'strides TM post']})
% 
% figure
% uiwait(gcf)
% print(h,[cd '\BarplotAfterEffn5'],'-dpng')
% close all
% 
%  
% %% bar OG post contextualization
% h=figure;
% hold on
% for i=1:length(groups)
%     subplot(3,1,3);
%     title('OGpost/End steady state end of adaptation (netCon-velCon)')
%     eval(['dt1=AllData.',groups{i},'.AdaptExtent(:,1);';])
%     eval(['dt2=AllData.',groups{i},'.OGp{1,4};';])
%     Context1{i}=dt2./dt1*100;
%     n=length (dt2);
%     bar([x1(i)],[nanmean(Context1{i}) ],'BarWidth',0.4,'FaceColor',colorcodes(i,:)); hold on;
% end
%     for i=1:length(groups)
%     eval(['dt1=AllData.',groups{i},'.AdaptExtent(:,1);';])
%     eval(['dt2=AllData.',groups{i},'.OGp{1,4};';])
%     Context1{i}=dt2./dt1*100;
%     errorbar([x1(i)],[nanmean(Context1{i})],[nanmean(Context1{i})]./sqrt(n),'Color','k','LineStyle','none','LineWidth',2)
%     plot(repmat(x1(i),n,1),Context1{i},'ok');hold on;
%     end
%     clear dt1 dt2
%     subplot (3,1,2)
% for i=1:length(groups)
%     title('OG post step time/end steady state step time');
%     eval(['dt1.St=AllData.',groups{i},'.LA{2}();';])
%     eval(['dt2.St=AllData.',groups{i},'.OGp{2};';])
%     Context.St{i}=dt2.St./dt1.St*100;
%     bar([x1(i)],[nanmean(Context.St{i}) ],'BarWidth',0.4,'FaceColor',colorcodes(i,:)); hold on;
% end
% 
% for i=1:length(groups)
%     eval(['dt1.St=AllData.',groups{i},'.LA{2}();';])
%     eval(['dt2.St=AllData.',groups{i},'.OGp{2};';])
%     Context.St{i}=dt2.St./dt1.St*100;
%     errorbar([x1(i)],[nanmean(Context.St{i})],[nanmean(Context.St{i})]./sqrt(n),'Color','k','LineStyle','none','LineWidth',2); hold on;
%     plot(repmat(x1(i),n,1),Context.St{i},'ok'); hold on;
% end
% clear dt1 dt2
% subplot(3,1,1)
% for i=1:length(groups)
%     title('OG post step position/end steady state step position');
%     eval(['dt1.Sp=AllData.',groups{i},'.LA{1}();';])
%     eval(['dt2.Sp=AllData.',groups{i},'.OGp{1};';])
%     Context.Sp{i}=dt2.Sp./dt1.Sp*100;
%     bar([x1(i)],[nanmean(Context.Sp{i}) ],'BarWidth',0.4,'FaceColor',colorcodes(i,:)); hold on;
% end
%     
% for i=1:length (groups)
%     eval(['dt1.Sp=AllData.',groups{i},'.LA{1}();';])
%     eval(['dt2.Sp=AllData.',groups{i},'.OGp{1};';])
%     Context.Sp{i}=dt2.Sp./dt1.Sp*100;
%     errorbar([x1(i)],[nanmean(Context.Sp{i})],[nanmean(Context.Sp{i})]./sqrt(n),'Color','k','LineStyle','none','LineWidth',2)
%     plot(repmat(x1(i),n,1),Context.Sp{i},'ok');
% end
% legend (groups)
% clear dt1 dt2
% figure
% uiwait(gcf)
% print(h,[cd '\BarplotErrorContext'],'-dpng')
% close all


