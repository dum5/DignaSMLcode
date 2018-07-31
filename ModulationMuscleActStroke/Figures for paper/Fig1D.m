%fh=figure('Units','Normalized','Position',[0 0 0. 0.3]);
figuresColorMap;
fh=figure('Units','Normalized','Position',[0 0 .55 .35]);
    
auxF=[0;.35;-.3];
auxS=[-.35;.35;.2];
for k=[2,1]
    switch k
        case 1 %eA
            aux1=auxF;
            aux2=auxS;
            tt='eA_B';
       case 2
            tt='eA_B^*';
            aux1=auxS;
            aux2=auxF;     
    end
ax=axes;
%ax.Position=[0.05+(k-1)*.08 .05 .2 .35];
ax.Position=[0.05+(k-1)*.16 .05 .2 .35];
I=imshow(size(map,1)*(aux1+.5),flipud(map),'Border','tight');
rectangle('Position',[.5 .5 1 3],'EdgeColor','k')
%%Add arrows
hold on
quiver(ones(size(aux1)),[1:numel(aux1)]'+.4*sign(aux1),zeros(size(aux1)),-.7*sign(aux1),0,'Color','k','LineWidth',2)
ax=axes;
%ax.Position=[.05+(k-1)*.08 .45 .2 .35];
ax.Position=[.05+(k-1)*.16 .45 .2 .35];
I=imshow(size(map,1)*(aux2+.5),flipud(map),'Border','tight');
rectangle('Position',[.5 .5 1 3],'EdgeColor','k')
%%Add arrows
hold on
quiver(ones(size(aux1)),[1:numel(aux1)]'+.4*sign(aux2),zeros(size(aux1)),-.7*sign(aux2),0,'Color','k','LineWidth',2)

set(gca,'XTickLabel','','YTickLabel','','XTick','','YTick','')
text(.6,0,tt,'Clipping','off','FontSize',14,'FontWeight','bold')

end

% text(-1.8,-.65,'eP-lA','Clipping','off','FontSize',14,'FontWeight','bold')
% plot([-3.5 1.5],-.3*[1 1],'k','LineWidth',2,'Clipping','off')
%plot(-4*[1 1],[.5 7],'k','LineWidth',1,'Clipping','off')

%Add lines on fast/slow:
ccc=get(gca,'ColorOrder');
plot(0*[1 1],3.45+[.5 3.5],'LineWidth',4,'Color',ccc(1,:),'Clipping','off')
text(-0.6,6.5,'FAST','Color',ccc(1,:),'Rotation',90,'FontSize',20,'FontWeight','bold')
plot(0*[1 1],[.5 3.5],'LineWidth',4,'Color',ccc(2,:),'Clipping','off')
text(-0.6,3.25,'SLOW','Color',ccc(2,:),'Rotation',90,'FontSize',20,'FontWeight','bold')

text(-3,-0.75,'\DeltaEMG(eP_l_A)=\beta_M \DeltaEMG(eA_B)^*','FontSize',16,'FontWeight','bold')