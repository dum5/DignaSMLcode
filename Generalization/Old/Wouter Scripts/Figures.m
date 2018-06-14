%% Creating the figures for Adaptation and OG post

groups=fieldnames(AllTimecourses);
groups1=(groups([3 1 4])); %Gradual Abrupt no FB abrutp FB [0.2 0.2 1; 0.6 0 0.6; 0.6 0.6 0.6;];
groups2=(groups([3 5])); %No Fb Catch  [0.2 0.2 1;1 0.4 0];
groups3=(groups([3 2 5]));%Abrupt Full abrupt colorcodes=[0.2 0.2 1;0.8 0 0;1 0.4 0];
groups4=(groups([3 2]));  % 2 abrupt colorcode [0.2 0.2 1;0.2 0.4 0];
groups5=(groups([1 4 3 5 2]));%colorcodes=[0.2 0.2 1; 0.6 0 0.6; 0.6 0.6 0.6;1 0.4 0;0.8 0 0];
legend1=([{ 'No Feedback';'Gradual';'Feedback'}]);
legend2=([{ 'No Feedback';'Abrupt';'Catch'}]);
legend3=([{'Gradual';'Feedback'; 'No Feedback';'Catch';'Abrupt'}]);
%% Catch work
groups=fieldnames(AllTimecourses);
groups5=(groups([1 4 3 5 2]));
for i=1:5
    eval(['tempdata=(AllTimecourses.',groups5{i},'.adapt{4});';])
for j=1:10;
    for nstep=1:200;
        Run600A{i}(nstep,j)=nanmean(tempdata(580+nstep:580+nstep+5,j));
    end
       [MaxError600{i}(j,:),loc{i}(j,:)]=min(Run600A{i}(:,j));
end
end
Error600=cell2mat(MaxError600);

%% Moving average work
%Moving average of Early adaptation and Maximum error during whole
%adaptation
for i= 1:length(groups5)
    eval(['tempdataA=(AllTimecourses.',groups5{i},'.adapt{4});';])
    eval(['tempdataOG=(AllTimecourses.',groups5{i},'.OGp{4});';])
    eval(['tempdataRA=(AllTimecourses.',groups5{i},'.readapt{4});';])
        for j=1:10;
        for nstep=1:871;
            for nstepra=1:281;
            RunA{i}(nstep,j)=nanmean(tempdataA(nstep:nstep+9,j));
            RunRA{i}(nstepra,j)=nanmean(tempdataRA(nstepra:nstepra+9,j));
            end
       end
        MaxErrorEarly{i}(j,:)=min(RunA{i}(1:50,j));
        [MaxError{i}(j,:),loc{i}(j,:)]=min(RunA{i}(:,j));
        [MaxErrorRA{i}(j,:),locR{i}(j,:)]=min(RunRA{i}(:,j));
           for nOg=1:5;
            RunOg{i}(nOg,j)=nanmean(tempdataOG(1+nOg:nOg+5,j));
            MaxErrorOg{i}(j,:)=max(RunOg{i}(:,j));
        end
    end
end
MaxErrorA=cell2mat(MaxError);
MaxErrorEA=cell2mat(MaxErrorEarly);
ErrorOg=cell2mat(MaxErrorOg);
MaxErrorRA=cell2mat(MaxErrorRA);


%% Figures 3 groups Timecourse Adaptation 
% This section creates timecourse in adaptation for 3 groups, right now we
% are doing all groups in one plot
% h=figure;
% x1=1:L-20;
% hold on
% subplot(2,1,1)
% box off
% for i= 1:length(groups1)
%     colorcodes=[0.2 0.2 1; 0.6 0 0.6; 0.6 0.6 0.6;];
%     eval(['dt=nanmean(transpose(AllTimecourses.',groups1{i},'.adapt{4}));';])
%     h(i)=plot(x1,dt,'ok','MarkerFaceColor',colorcodes(i,:));hold on;
%     eval(['dt=nanmean(transpose(AllTimecourses.',groups1{i},'.adapt{4}));';])
%     eval(['nt=nanstd(transpose(AllTimecourses.',groups1{i},'.adapt{4}));';])
%     eval(['n=length(studyData.',groups1{i},'.adaptData);']);
%     nt=nt./sqrt(n);
%     patch([x1,fliplr(x1)],[dt+nt fliplr(dt-nt)],colorcodes(i,:),'FaceAlpha',0.2,'LineStyle','none');hold on;
%     set (gca,'YLim',[-0.3 0.05],'XTick',[nanmean(x1)],'XTickLabel',{'Strides'}); ylabel('SLA'); title('Adaptation');
% end
% 
% legend (h([1 2 3]),groups1,'Location','best');box off
% subplot(2,1,2) 
% for i= 1:length(groups3)
%     colorcodes=[0.2 0.2 1;0.8 0 0;1 0.4 0];
%     eval(['dt=nanmean(transpose(AllTimecourses.',groups3{i},'.adapt{4}));';])
%     eval(['nt=nanstd(transpose(AllTimecourses.',groups3{i},'.adapt{4}));';])
%     eval(['n=length(studyData.',groups3{i},'.adaptData);']);
%     nt=nt./sqrt(n);
%     if i==3
%         h(i+3)=plot(x1,dt,'ok','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 1]);hold on;
%         patch([x1,fliplr(x1)],[dt+nt fliplr(dt-nt)],[0.9 0.9 0.9],'FaceAlpha',0.5,'LineStyle','none');hold on;
%     else
%     h(i+3)=plot(x1,dt,'ok','MarkerFaceColor',colorcodes(i,:));hold on;
%     patch([x1,fliplr(x1)],[dt+nt fliplr(dt-nt)],colorcodes(i,:),'FaceAlpha',0.2,'LineStyle','none');hold on;
%     end
% 
% 
%     
%     set (gca,'YLim',[-0.3 0.05],'XTick',[nanmean(x1)],'XTickLabel',{'Strides'});ylabel ('SLA')
% end
%     legend (h([4 5 6]),groups3,'Location','best');box off
% subplot (3,1,3);hold on;
% box('on')
% for i= 1:length(groups3)
%     colorcodes=[0.2 0.2 1;0.2 0.4 0;1 0.4 0];
%     eval(['dt=nanmean(transpose(AllTimecourses.',groups3{i},'.adapt{4}));';])
%     h(i+5)=plot(x1,dt,'ok','MarkerFaceColor',colorcodes(i,:));hold on;
%     eval(['dt=nanmean(transpose(AllTimecourses.',groups3{i},'.adapt{4}));';])
%     eval(['nt=nanstd(transpose(AllTimecourses.',groups3{i},'.adapt{4}));';])
%     eval(['n=length(studyData.',groups3{i},'.adaptData);']);
%     nt=nt./sqrt(n);
%     patch([x1,fliplr(x1)],[dt+nt fliplr(dt-nt)],colorcodes(i,:),'FaceAlpha',0.2,'LineStyle','none');hold on;
%     set (gca,'YLim',[-0.3 0.05],'XTick',[nanmean(x1)],'XTickLabel',{'Strides'}); ylabel('SLA')
% end
%  legend (h([6 7]),groups3,'Location','best');box off




%% OG POST
%% time courses after effects + bars first 3 groups
% This section creates timecourse in OG Post for 3 groups, right now we
% are doing all groups in one plot
% h1=figure;
% set(gcf,'Position',[500 350 750 570]) ;
% x1=1:15;
% hold on
% subplot(3,1,1)
% 
% for i= 1:length(groups1)
%     colorcodes=[0.2 0.2 1; 0.6 0 0.6; 0.6 0.6 0.6;];
% %     if i==2
% %         eval(['dt=nanmean(transpose(AllTimecourses.',groups1{i},'.OGp{4}(:,[1:6 8 9])));';])
% %         eval(['dt=nanstd(transpose(AllTimecourses.',groups1{i},'.OGp{4}(:,[1:6 8 9])));';])
% %         eval(['n=length(studyData.',groups1{i},'.adaptData)-1;']);
% 
%       eval(['dt=nanmean(transpose(AllTimecourses.',groups1{i},'.OGp{4}));';])
%     eval(['nt=nanstd(transpose(AllTimecourses.',groups1{i},'.OGp{4}));';])
%     eval(['n=length(studyData.',groups1{i},'.adaptData);']);
% %     end
%     h1(i)=plot(x1,dt(1:15),'ok','MarkerFaceColor',colorcodes(i,:));hold on;
%     nt=nt./sqrt(n);
%     patch([x1,fliplr(x1)],[dt(1:15)+nt(1:15) fliplr(dt(1:15)-nt(1:15))],colorcodes(i,:),'FaceAlpha',0.2,'LineStyle','none');hold on;
%     set (gca,'YLim',[-0.05 0.2],'box','off')
%     title('Step length Asymmetry')
% end
% box off
% %barplots
% x1=1:length(groups1);
% hold on
% for k=1:parameter
%     for i=1:length(groups1)
%         colorcodes=[0.2 0.2 1; 0.6 0 0.6; 0.6 0.6 0.6;];
%         if k==1||k==2
%             subplot(3,2,k+2)
%             eval(['dt1=AllData.',groups1{i},'.OGp{k};';])
%             n=length(dt1);
%             h3(i)=bar([x1(i)],[nanmean(dt1)],'BarWidth',0.6,'FaceColor',colorcodes(i,:));hold on;
%             e(i)=errorbar([x1(i)],[nanmean(dt1)],[nanstd(dt1)]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
%             set (gca,'YLim',[-0.1 0.1]);set(gca,'XtickLabel',legend1,'XTick',1:numel(legend1),'box','off');
%             if k==1
%                 title('Step Position','fontsize',12);
%             end
%             
%             if k==2
%                 set (gca,'YLim',[0.0 0.2])
%                 title({'Step Time';'(mean of first 5 steps)'},'fontsize',12)
%             end
%         elseif k==4
%             subplot (3,2,5)
%             eval(['dt1=AllData.',groups1{i},'.OGp{k};';])
%             n=length(dt1);
%             h3(i)=bar([x1(i)],[nanmean(dt1)],'BarWidth',0.6,'FaceColor',colorcodes(i,:));hold on;
%             e(i)=errorbar([x1(i)],[nanmean(dt1)],[nanstd(dt1)]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
%             set (gca,'YLim',[0.0 0.2]);
%             title({'Step length asymmetry';'(mean of first 5 steps)'},'fontsize',12)
%             set(gca,'XtickLabel',legend1,'XTick',1:numel(legend1),'box','off');
%             
%             
%         else
%             subplot (3,2,6)
%             title({'OGpost% of learning'},'fontsize',12)
%             eval(['dt1=AllData.',groups1{i},'.AdaptExtent(:,1);';])
%             eval(['dt2=AllData.',groups1{i},'.OGp{1,4};';])
%             Context1{i}=dt2./dt1*100;
%             n=length (dt2);
%             h4(i)=bar([x1(i)],[nanmean(Context1{i}) ],'BarWidth',0.4,'FaceColor',colorcodes(i,:)); hold on;
%             e(i)=errorbar([x1(i)],[nanmean(Context1{i})],[nanstd(Context1{i})]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
%             set(gca,'XtickLabel',legend1,'XTick',1:numel(legend1),'box','off','Ylim',[0 60]);
%             
%         end
%     end
%     
% end
% subplot (3,2,3)
% sigstar({[1,2]})
% subplot (3,2,5)
% sigstar({[1,2],[1,3]})
% subplot (3,2,6)
% sigstar({[1,2],[1,3]})
% box off
% legend(h3([1 2 3 ]),groups1);
clear dt1 dt2
% %% No Fb ,Abrupt and Catch groups
% h1=figure;
% set(gcf,'Position',[700 350 750 570]) 
% x1=1:15;x2=21:35;
% hold on
% subplot(3,1,1)
% for i= 1:length(groups3)
%     colorcodes=[0.2 0.2 1;0.8 0 0;1 0.4 0];
%     eval(['dt=nanmean(transpose(AllTimecourses.',groups3{i},'.OGp{4}));';])
%     eval(['nt=nanstd(transpose(AllTimecourses.',groups3{i},'.OGp{4}));';])
%     eval(['n=length(studyData.',groups3{i},'.adaptData);']);
%     nt=nt./sqrt(n);
%     if i==3
%     h1(i)=plot(x1,dt(1:15),'ok','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 1]);hold on;
%      patch([x1,fliplr(x1)],[dt(1:15)+nt(1:15) fliplr(dt(1:15)-nt(1:15))],[0.9 0.9 0.9],'FaceAlpha',0.5,'LineStyle','none');hold on;
%     else
%     h1(i)=plot(x1,dt(1:15),'ok','MarkerFaceColor',colorcodes(i,:));hold on;
%      patch([x1,fliplr(x1)],[dt(1:15)+nt(1:15) fliplr(dt(1:15)-nt(1:15))],colorcodes(i,:),'FaceAlpha',0.2,'LineStyle','none');hold on;
%     end
%     set (gca,'YLim',[-0.05 0.2],'box','off')
%     title({'Step length Asymmetry';'(mean of first 5 steps)'})
% end
% box off
% %barplots
% x1=1:length(groups3);
% hold on
% for k=1:parameter
%     for i=1:length(groups3)
%         colorcodes=[0.2 0.2 1;0.8 0 0;1 0.4 0];
%         if k==1||k==2
%             subplot(3,2,k+2)
%             eval(['dt1=AllData.',groups3{i},'.OGp{k};';])
%             n=length(dt1);
%             if i==3
%              h3(i)=bar([x1(i)],[nanmean(dt1)],'BarWidth',0.6,'FaceColor',[0 0 1],'FaceAlpha',0.08,'EdgeColor',[0 0 1],'LineWidth',1);hold on;
%             e(i)=errorbar([x1(i)],[nanmean(dt1)],[nanstd(dt1)]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
%             else
%             h3(i)=bar([x1(i)],[nanmean(dt1)],'BarWidth',0.6,'FaceColor',colorcodes(i,:));hold on;
%             e(i)=errorbar([x1(i)],[nanmean(dt1)],[nanstd(dt1)]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
%              end
%             
%             set (gca,'YLim',[-0.1 0.1]);set(gca,'XtickLabel',legend2,'XTick',1:numel(groups3),'box','off');
%             if k==1
%                 title({'Step Position';'(mean of first 5 steps)'},'fontsize',12);
%                 
%             end
%             if k==2
%                 set (gca,'YLim',[0.0 0.2])
%                 title({'Step Time';'(mean of first 5 steps)'},'fontsize',12)
%             end
%         elseif k==4
%             subplot (3,2,5)
%             eval(['dt1=AllData.',groups3{i},'.OGp{k};';])
%             n=length(dt1);
%             if i==3
%              h3(i)=bar([x1(i)],[nanmean(dt1)],'BarWidth',0.6,'FaceColor',[0 0 1],'FaceAlpha',0.08,'EdgeColor',[0 0 1],'LineWidth',1);hold on;
%             e(i)=errorbar([x1(i)],[nanmean(dt1)],[nanstd(dt1)]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
%             else
%             h3(i)=bar([x1(i)],[nanmean(dt1)],'BarWidth',0.6,'FaceColor',colorcodes(i,:));hold on;
%             e(i)=errorbar([x1(i)],[nanmean(dt1)],[nanstd(dt1)]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
%              end
%             set (gca,'YLim',[0.0 0.2]);
%             title({'Step length asymmetry';'(mean of first 5 steps)'},'fontsize',12)
%             set(gca,'XtickLabel',legend2,'XTick',1:numel(groups3),'box','off');
%             
%             
%         else
%             subplot (3,2,6)
%             title('OGpost% of learning','fontsize',12)
%             eval(['dt1=AllData.',groups3{i},'.AdaptExtent(:,1);';])
%             eval(['dt2=AllData.',groups3{i},'.OGp{1,4};';])
%             Context1{i}=dt2./dt1*100;
%             n=length (dt2);
%             if i==3
%             h4(i)=bar([x1(i)],[nanmean(Context1{i}) ],'BarWidth',0.4,'FaceColor',[0 0 1],'FaceAlpha',0.08,'EdgeColor',[0 0 1],'LineWidth',1); hold on;
%             e(i)=errorbar([x1(i)],[nanmean(Context1{i})],[nanstd(Context1{i})]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
%             else
%             h4(i)=bar([x1(i)],[nanmean(Context1{i}) ],'BarWidth',0.4,'FaceColor',colorcodes(i,:)); hold on;
%             e(i)=errorbar([x1(i)],[nanmean(Context1{i})],[nanstd(Context1{i})]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);   
%             end
%             set(gca,'XtickLabel',legend2,'XTick',1:numel(groups3),'box','off')
%             
%         end
%     end
% end
% subplot (3,2,3)
% sigstar({[1,3]})
% subplot (3,2,4)
% sigstar({[1,3],[2,3]})
% subplot (3,2,5)
% sigstar({[1,3],[2,3]})
% subplot (3,2,6)
% sigstar({[1,3],[2,3]})


% %% %% No Fb and Full Abrupt 2 groups
% h1=figure;
% x1=1:15;x2=21:35;
% hold on
% subplot(3,1,1)
% for i= 1:length(groups3)
%     colorcodes=[0.2 0.2 1;0.2 0.4 0;];
%     eval(['dt=nanmean(transpose(AllTimecourses.',groups3{i},'.OGp{4}));';])
%     h1(i)=plot(x1,dt(1:15),'ok','MarkerFaceColor',colorcodes(i,:));hold on;
%     eval(['dt=nanmean(transpose(AllTimecourses.',groups3{i},'.OGp{4}));';])
%     eval(['nt=nanstd(transpose(AllTimecourses.',groups3{i},'.OGp{4}));';])
%     eval(['n=length(studyData.',groups3{i},'.adaptData);']);
%     nt=nt./sqrt(n);
%     patch([x1,fliplr(x1)],[dt(1:15)+nt(1:15) fliplr(dt(1:15)-nt(1:15))],colorcodes(i,:),'FaceAlpha',0.2,'LineStyle','none');hold on;
%     set (gca,'YLim',[-0.05 0.2])
%     title('Step length Asymmetry')
% end
% %barplots
% x1=1:length(groups3);
% hold on
% for k=1:parameter
%     for i=1:length(groups3)
%         colorcodes=[0.2 0.2 1;0.2 0.4 0;];
%         if k==1||k==2
%             subplot(3,2,k+2)
%             eval(['dt1=AllData.',groups3{i},'.OGp{k};';])
%             n=length(dt1);
%             h3(i)=bar([x1(i)],[nanmean(dt1)],'BarWidth',0.6,'FaceColor',colorcodes(i,:));hold on;
%             e(i)=errorbar([x1(i)],[nanmean(dt1)],[nanstd(dt1)]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
%             set (gca,'YLim',[-0.1 0.1]);set(gca,'XtickLabel',groups3,'XTick',1:numel(groups3));
%             if k==1
%                 title('Step Position','fontsize',12);
%                 
%             end
%             if k==2
%                 set (gca,'YLim',[0.0 0.2])
%                 title('Step Time','fontsize',12)
%             end
%         elseif k==4
%             subplot (3,2,5)
%             eval(['dt1=AllData.',groups3{i},'.OGp{k};';])
%             h3(i)=bar([x1(i)],[nanmean(dt1)],'BarWidth',0.6,'FaceColor',colorcodes(i,:));hold on;
%             n=length(dt1);
%             e(i)=errorbar([x1(i)],[nanmean(dt1)],[nanstd(dt1)]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
%             set (gca,'YLim',[0.0 0.2]);
%             title('Step length asymmetry','fontsize',12)
%             set(gca,'XtickLabel',groups3,'XTick',1:numel(groups3));
%             
%             
%         else
%             subplot (3,2,6)
%             title('OGpost% of learning','fontsize',12)
%             eval(['dt1=AllData.',groups3{i},'.AdaptExtent(:,1);';])
%             eval(['dt2=AllData.',groups3{i},'.OGp{1,4};';])
%             Context1{i}=dt2./dt1*100;
%             n=length (dt2);
%             h4(i)=bar([x1(i)],[nanmean(Context1{i}) ],'BarWidth',0.4,'FaceColor',colorcodes(i,:)); hold on;
%             e(i)=errorbar([x1(i)],[nanmean(Context1{i})],[nanstd(Context1{i})]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
%             set(gca,'XtickLabel',groups3,'XTick',1:numel(groups3))
%             
%         end
%     end
% end


%% Time course and bar plots in ALL IN ONE Og Post
h=figure;
x1=1:15;
hold on
subplot(2,2,1)
for i= 1:length(groups1)
    colorcodes=[0.2 0.2 1; 0.6 0 0.6; 0.6 0.6 0.6;];
    eval(['dt=nanmean(transpose(AllTimecourses.',groups1{i},'.OGp{4}));';])
    eval(['nt=nanstd(transpose(AllTimecourses.',groups1{i},'.OGp{4}));';])
    eval(['n=length(studyData.',groups1{i},'.adaptData);']);
    nt=nt./sqrt(n);
    h1(i)=plot(x1,dt(1:15),'ok','MarkerFaceColor',colorcodes(i,:));hold on;
    patch([x1,fliplr(x1)],[dt(1:15)+nt(1:15) fliplr(dt(1:15)-nt(1:15))],colorcodes(i,:),'FaceAlpha',0.2,'LineStyle','none');hold on;
    set (gca,'YLim',[-0.05 0.2])
    title('Step length Asymmetry')
end
subplot(2,2,3) 
for i= 1:length(groups3)
    colorcodes=[0.2 0.2 1;0.8 0 0;1 0.4 0];
    eval(['dt=nanmean(transpose(AllTimecourses.',groups3{i},'.OGp{4}));';])
    eval(['nt=nanstd(transpose(AllTimecourses.',groups3{i},'.OGp{4}));';])
    eval(['n=length(studyData.',groups3{i},'.adaptData);']);
    nt=nt./sqrt(n);
    if i==3
    h1(i)=plot(x1,dt(1:15),'ok','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 1]);hold on;
     patch([x1,fliplr(x1)],[dt(1:15)+nt(1:15) fliplr(dt(1:15)-nt(1:15))],[0.9 0.9 0.9],'FaceAlpha',0.5,'LineStyle','none');hold on;
    else
    h1(i)=plot(x1,dt(1:15),'ok','MarkerFaceColor',colorcodes(i,:));hold on;
     patch([x1,fliplr(x1)],[dt(1:15)+nt(1:15) fliplr(dt(1:15)-nt(1:15))],colorcodes(i,:),'FaceAlpha',0.2,'LineStyle','none');hold on;
    end
    set (gca,'YLim',[-0.05 0.2])
    title('Step length Asymmetry')
end
box off

x1=1:length(groups5);
colorcodes=[0.6 0 0.6; 0.6 0.6 0.6;0.2 0.2 1; 1 0.4 0;0.8 0 0];
hold on
for k=1:parameter
    for i=1:length(groups5)
        if k==1||k==2
            subplot(2,4,k+2)
            eval(['dt1=AllData.',groups5{i},'.OGp{k};';])
            n=length(dt1);
            x1=1:length(groups5);
            if i==4
             h3(i)=bar([x1(i)],[nanmean(dt1)],'BarWidth',0.6,'FaceColor',[0 0 1],'FaceAlpha',0.08,'EdgeColor',[0 0 1],'LineWidth',1);hold on;
            e(i)=errorbar([x1(i)],[nanmean(dt1)],[nanstd(dt1)]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
            else
            h3(i)=bar([x1(i)],[nanmean(dt1)],'BarWidth',0.6,'FaceColor',colorcodes(i,:));hold on;
            e(i)=errorbar([x1(i)],[nanmean(dt1)],[nanstd(dt1)]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
             end
            set (gca,'YLim',[-0.1 0.1]);set(gca,'XtickLabel',[],'Xlim',[0 6]);
            if k==1
                title('Step Position','fontsize',12);
                
            end
            if k==2
                set (gca,'YLim',[0.0 0.2])
                title('Step Time','fontsize',12)
            end
        elseif k==4
            subplot (2,4,7)
            eval(['dt1=AllData.',groups5{i},'.OGp{k};';])
            n=length(dt1);
            if i==4
             h3(i)=bar([x1(i)],[nanmean(dt1)],'BarWidth',0.6,'FaceColor',[0 0 1],'FaceAlpha',0.08,'EdgeColor',[0 0 1],'LineWidth',1);hold on;
            e(i)=errorbar([x1(i)],[nanmean(dt1)],[nanstd(dt1)]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
            else
            h3(i)=bar([x1(i)],[nanmean(dt1)],'BarWidth',0.6,'FaceColor',colorcodes(i,:));hold on;
            e(i)=errorbar([x1(i)],[nanmean(dt1)],[nanstd(dt1)]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
            end
            set (gca,'YLim',[0.0 0.2]);
            title('Step length asymmetry','fontsize',12)
            set(gca,'XtickLabel',[],'Xlim',[0 6]);
            
            
        else
            subplot (2,4,8)
            title('OGpost% of learning','fontsize',12)
            eval(['dt1=AllData.',groups5{i},'.AdaptExtent(:,1);';])
            eval(['dt2=AllData.',groups5{i},'.OGp{1,4};';])
            n=length(dt1);
            Context1{i}=dt2./dt1*100;
            
             if i==4
             h3(i)=bar([x1(i)],[nanmean(Context1{i})],'BarWidth',0.6,'FaceColor',[0 0 1],'FaceAlpha',0.08,'EdgeColor',[0 0 1],'LineWidth',1);hold on;
            e(i)=errorbar([x1(i)],[nanmean(Context1{i})],[nanstd(Context1{i})]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
            else
            h3(i)=bar([x1(i)],[nanmean(Context1{i})],'BarWidth',0.6,'FaceColor',colorcodes(i,:));hold on;
            e(i)=errorbar([x1(i)],[nanmean(Context1{i})],[nanstd(Context1{i})]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
             end
           set(gca,'XtickLabel',[],'Xlim',[0 6])
            
        end
    end
end
subplot (2,4,3)
sigstar({[1,2]})
subplot (2,4,4)
sigstar({[1,3],[1,4],[3,5],[4,5]})
subplot (2,4,7)
sigstar({[1,2],[1,3],[1,4],[2,5],[3,5],[4,5]})
subplot (2,4,8)
sigstar({[1,2],[1,3],[1,4],[4,5]})
%% Time course and bar plots ALL IN ONE Adaptation
h=figure;
strides=[300 600 900];
set(gcf,'Position',[680   350   780   640]);
x1=1:L-20;
hold on
subplot(3,1,1)
for i= 1:length(groups1)
    colorcodes=[0.2 0.2 1; 0.6 0 0.6; 0.6 0.6 0.6;];
    eval(['dt=nanmean(transpose(AllTimecourses.',groups1{i},'.adapt{4}));';])
    h(i)=plot(x1,dt,'ok','MarkerFaceColor',colorcodes(i,:));hold on;
    eval(['nt=nanstd(transpose(AllTimecourses.',groups1{i},'.adapt{4}));';])
    eval(['n=length(studyData.',groups1{i},'.adaptData);']);
    nt=nt./sqrt(n);
    patch([x1,fliplr(x1)],[dt+nt fliplr(dt-nt)],colorcodes(i,:),'FaceAlpha',0.2,'LineStyle','none');hold on;
    set (gca,'YLim',[-0.3 0.05],'XTick',(strides),'XTickLabel',(strides)); ylabel('SLA'); title('Adaptation');
end
box('off')
subplot(3,1,2) 
for i= 1:length(groups3)
    colorcodes=[0.2 0.2 1;0.8 0 0;1 0.4 0];
    eval(['dt=nanmean(transpose(AllTimecourses.',groups3{i},'.adapt{4}));';])
    eval(['nt=nanstd(transpose(AllTimecourses.',groups3{i},'.adapt{4}));';])
    eval(['n=length(studyData.',groups3{i},'.adaptData);']);
    nt=nt./sqrt(n);
   
    if i==3
         dt(dt(1:90)<=-0.2)=NaN;
         dt(600:602)=NaN;
        h(i+3)=plot(x1,dt,'ok','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 1]);hold on;
        patch([x1,fliplr(x1)],[dt+nt fliplr(dt-nt)],[0.9 0.9 0.9],'FaceAlpha',0.5,'LineStyle','none');hold on;
    else
        h(i+3)=plot(x1,dt,'ok','MarkerFaceColor',colorcodes(i,:));hold on;
        patch([x1,fliplr(x1)],[dt+nt fliplr(dt-nt)],colorcodes(i,:),'FaceAlpha',0.2,'LineStyle','none');hold on;
    end
    
    set (gca,'YLim',[-0.3 0.05],'XTick',(strides),'XTickLabel',(strides));ylabel ('SLA')
    
end
box('off')

%barplots
x1=1:length(groups5);
colorcodes=[ 0.6 0 0.6; 0.6 0.6 0.6 ;0.2 0.2 1;1 1 1;0.8 0 0];
hold on
for i=1:length(groups5)
     subplot(3,3,7)
    n=length(MaxError{1});
     if i==4
        h3(i)=bar([x1(i)],[nanmean(MaxErrorA(:,i))],'BarWidth',0.6,'FaceColor',[0 0 1],'FaceAlpha',0.08,'EdgeColor',[0 0 1],'LineWidth',1); hold on;
     else
     h(i)=bar([x1(i)],[nanmean(MaxErrorA(:,i))],'BarWidth',0.6,'FaceColor',colorcodes(i,:));hold on;
     end
     e(i)=errorbar([x1(i)],[nanmean(MaxErrorA(:,i))],[nanstd(MaxErrorA(:,i))]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
     
    set (gca,'YLim',[-0.4 0]);set(gca,'XtickLabel',legend3,'XTick',1:numel(groups5),'XTickLabelRotation',-45);
    title({'Maximum  Errors'},'fontsize',12);


       
    subplot (3,3,8)
    eval(['dt1=AllData.',groups5{i},'.LA{4};';])
    n=length(dt1);
    if i==4
        h3(i)=bar([x1(i)],[nanmean(dt1)],'BarWidth',0.6,'FaceColor',[0 0 1],'FaceAlpha',0.08,'EdgeColor',[0 0 1],'LineWidth',1); hold on;
    else
        h3(i)=bar([x1(i)],[nanmean(dt1)],'BarWidth',0.6,'FaceColor',colorcodes(i,:));hold on;
    end
    e(i)=errorbar([x1(i)],[nanmean(dt1)],[nanstd(dt1)]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
    set (gca,'YLim',[-.1 0]);
    title({'Late adaptation'},'fontsize',12);
    set(gca,'XtickLabel',legend3,'XTick',1:numel(groups5),'XTickLabelRotation',-45);
    
    subplot (3,3,9)
    eval(['dt1=AllData.',groups5{i},'.M900A{4};';])
    n=length(dt1);
    if i==4
        h3(i)=bar([x1(i)],[nanmean(dt1)],'BarWidth',0.6,'FaceColor',[0 0 1],'FaceAlpha',0.08,'EdgeColor',[0 0 1],'LineWidth',1); hold on;
    else
        h3(i)=bar([x1(i)],[nanmean(dt1)],'BarWidth',0.6,'FaceColor',colorcodes(i,:));hold on;
    end
    e(i)=errorbar([x1(i)],[nanmean(dt1)],[nanstd(dt1)]./sqrt(n),'Color','k','LineStyle','none','LineWidth',3);
    set (gca,'YLim',[-0.1 0]);
    title({'Mean error adaptation'},'fontsize',12);
    set(gca,'XtickLabel',legend3,'XTick',1:numel(groups5),'XTickLabelRotation',-45); 
    
end
 legend (h3([1 2 3 4 5]),groups5,'Location','best');box off
subplot(3,1,2)
line([600,600],[-0.3,0.1],'LineStyle','--')
subplot(3,3,7)
sigstar_negative({[1,2],[1,3],[1,5],[2,3],[2,4],[2,5],[3,4],[3,5],[4,5]});box off;
subplot (3,3,8)
sigstar_negative({[2,3]});box off;
subplot (3,3,9)
sigstar_negative({[1,3],[2,3],[3,5],[3,4]});box off;
