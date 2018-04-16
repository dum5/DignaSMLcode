clear all
close all

[num,txt,raw]=xlsread('Z:\Users\Yashar\EffortStudy\TestingDayOverview.xlsx');

params={'netContributionNorm2'};
condC={'baseline NO_VF','bf minTwelve','bf minSix', 'bf baseline', 'bf plusSix','bf plusTwelve'};%naming of repeated condition seems inconsistent
condS={'TM base','bf zeroD','bf OneD','bf twoD'};
cInds=find(num(:,2)==0);
sInds=find(num(:,2)==1);


%To do:
% -generate structure with all data for each condition (last 2 minutes count)
% -add option to build in different parameters
% -generate table with all parameters per condition, use
%  second instance of repeated condition
% -save datastructure
% -different for controls and patients, since the conditions are different

    for i=cInds' 
       % if num(i,2)==0; disp('controls subject')%control group
            if num(i,1)<10
            sub=['CM00',num2str(num(i,1))];        
            else
                sub=['CM0',num2str(num(i,1))];
            end
            day=['Day',num2str(num(i,3))];
            Path=['S:\Shared\Yashar\EffortStudy\',sub,'\',day];
             disp(['loading ',sub,' ',day]);
            file=[sub,'_fastparams.mat'];
            
            %load actual data            
            load([Path,'\',file]);  
            adaptData=adaptData.removeBadStrides;
            
            %find repeated condition
            if strcmp(adaptData.metaData.conditionName{8},'bf plusTwelve2')
                disp('repeated condition +12');rep=6;
            elseif strcmp(adaptData.metaData.conditionName{8},'bf minTwelve2')
                disp('repeated condition -12');rep=2;
            elseif strcmp(adaptData.metaData.conditionName{8},'bf baseline2')
                disp('repeated condition baseline');rep=4;
            elseif  strcmp(adaptData.metaData.conditionName{8},'bf minSix2')
                disp('repeated condition -6');rep=3;
            elseif strcmp(adaptData.metaData.conditionName{8},'bf min62')
                disp('repeated condition -6');rep=3;
            elseif strcmp(adaptData.metaData.conditionName{8},'bf no_VF2')
                disp('repeated condition No_VF');rep=1;
            elseif strcmp(adaptData.metaData.conditionName{8},'bf plus122')
                disp('repeated condition +12');rep=6;
            elseif strcmp(adaptData.metaData.conditionName{8},'bf plus62')
                disp('repeated condition +6');rep=5;
                
            end
           
           for c=1:6;
               if rep==c
                  f=8;  %use repreated condition                  
               else 
                   %find name of condition in list
                   f=find(cellfun(@(x)strcmp(x,condC{c}),adaptData.metaData.conditionName));
               end
               
               t=adaptData.getParamInCond('finalTime',f);
               for p=1:length(params); %edit this loop to add more paramenters
               %retrieve data for condition              
               dt=adaptData.getParamInCond(params{p},f);%full trial
               control.subdata{i}.condition{c}.parameter{p}=dt(find(t>179,1,'first'):end-5);%last 3 minutes minus 5 strides;
               clear dt t f
               end
           end
    end
            
%            
for l=1:length(sInds)
    i=sInds(l);
        %if num(i,2)==1; disp('stroke subject')%control group
            if num(i,1)<10
            sub=['PM00',num2str(num(i,1))];        
            else
                sub=['PM0',num2str(num(i,1))];
            end
            day=['Day',num2str(num(i,3))];
            Path=['S:\Shared\Yashar\EffortStudy\',sub,'\',day];
            disp(['loading ',sub,' ',day]);
            file=[sub,'_',day,'params.mat'];
            load([Path,'\',file]);  
            adaptData=adaptData.removeBadStrides;
            
            %find repeated condition
            if strcmp(adaptData.metaData.conditionName{6},'bf zeroD2')
                disp('repeated condition zeroD');rep=2;
            elseif strcmp(adaptData.metaData.conditionName{6},'bf oneD2')
                disp('repeated condition oneD');rep=3;
            elseif strcmp(adaptData.metaData.conditionName{6},'bf twoD2')
                disp('repeated condition twoD');rep=4;
            end
            
            for c=1:4;
               if rep==c
                  f=6;  %use repreated condition                  
               else 
                   %find name of condition in list
                   f=find(cellfun(@(x)strcmp(x,condS{c}),adaptData.metaData.conditionName));
               end
               
               t=adaptData.getParamInCond('finalTime',f);
               for p=1:length(params); %edit this loop to add more paramenters
               %retrieve data for condition              
               dt=adaptData.getParamInCond(params{p},f);%full trial
               stroke.subdata{l}.condition{c}.parameter{p}=dt(find(t>179,1,'first'):end-5);%last 3 minutes minus 5 strides;
               clear dt t f
               end
           end
end
        
%now we can extract the parameters from the structs we created, how you do
%that depends on the parameter (i.e. sort for dominant and slow....)

cmat=NaN(length(control.subdata),length(condC));
cvar=NaN(length(control.subdata),length(condC));

for c=1:length(control.subdata)
    if nanmean(control.subdata{c}.condition{2}.parameter{1})<0%this is to make sure all the signs are correct, regardless of leg dominance
        s=1;
    else s=-1;
    end
    
    for con=1:length(condC)
        cmat(c,con)=s*nanmean(control.subdata{c}.condition{con}.parameter{1});
        cvar(c,con)=nanstd(control.subdata{c}.condition{con}.parameter{1});
    end
        
        
end

smat=NaN(length(stroke.subdata),length(condS));
svar=NaN(length(stroke.subdata),length(condS));
for c=1:length(stroke.subdata)
    if nanmean(stroke.subdata{c}.condition{1}.parameter{1})>0%if their initial symmetry is negative, all numbers will be flipped to be able to compare groups
        s=1;
    else s=-1;
    end
    
    for con=1:length(condS)
        smat(c,con)=s*nanmean(stroke.subdata{c}.condition{con}.parameter{1});
        svar(c,con)=nanstd(stroke.subdata{c}.condition{con}.parameter{1});
    end
        
        
end


% plot delta's median and mean

figure
subplot 221
hold on
bar([1:6],mean(cmat),'FaceColor',[0.7 0.7 0.7])
errorbar([1:6],mean(cmat),std(cmat),'LineStyle','none')

%dt=[smat(:,2)./smat(:,1) smat(:,3)./smat(:,1) smat(:,4)./smat(:,1)];
subplot 222
hold on 
bar([1:4],mean(smat),'FaceColor',[0.7 0.7 0.7])
errorbar([1:4],mean(smat),std(smat),'LineStyle','none')

subplot 223
dt=diff(cmat')';
hold on
bar([1:4],nanmean(dt(:,2:5)),'FaceColor',[0.7 0.7 0.7]);
errorbar([1:4],nanmean(dt(:,2:5)),nanstd(dt(:,2:5)),'LineStyle','none');
clear dt;

subplot 224
dt=diff(smat')';
hold on
bar([1:2],nanmean(dt(:,2:3)),'FaceColor',[0.7 0.7 0.7]);
errorbar([1:2],nanmean(dt(:,2:3)),nanstd(dt(:,2:3)),'LineStyle','none');
clear dt;

figure
subplot 221
hold on
boxplot(cmat);
set(gca,'XTick',[1:6],'XTickLabel',{'NoVF','-12%','-6%','+0%','+6%','+12%'})
title('controls')

subplot 222
hold on 
boxplot(smat)
set(gca,'XTick',[1:4],'XTickLabel',{'NoVF','0x asym','1x asym,','2x asym'})
title('stroke')

subplot 223
dt=diff(cmat')';
hold on
boxplot(dt(:,2:5))
clear dt;
set(gca,'YLim',[-0.05 0.5])
set(gca,'XTick',[1:6],'XTickLabel',{'-12% vs -6%','-6% vs 0%','+0% vs -6%','+6%vs +12%'})

subplot 224
dt=diff(smat')';
hold on
boxplot(dt(:,2:3))
clear dt;
set(gca,'YLim',[-0.05 0.5])
set(gca,'XTick',[1:4],'XTickLabel',{'NoVF','0x asym','1x asym,','2x asym'})

figure
subplot 221
hold on
boxplot(cvar);
set(gca,'XTick',[1:6],'XTickLabel',{'NoVF','-12%','-6%','+0%','+6%','+12%'},'YLim',[0 0.4])
title('controls')
ylabel('SD netContribution')

subplot 222
hold on 
boxplot(svar)
set(gca,'XTick',[1:4],'XTickLabel',{'NoVF','0x asym','1x asym,','2x asym'},'YLim',[0 0.4])
title('stroke')




% plot sd in relation to delta

