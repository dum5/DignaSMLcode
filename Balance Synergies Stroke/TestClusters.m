% clear all
% close all
% 
% load('Z:\Users\Digna\Projects\Balance Synergies postStroke\TestClusters\allsubjectsFIPSorted.mat')

%Organize all Ws of controls
Wmatrix=[];
leg=[];
legno=0;
for sj=1:length(Wall)
    legno=legno+1;
    dt=Wall(sj).aff;
    leg=[leg;repmat(legno,size(dt,2),1)];
    Wmatrix=[Wmatrix;dt'];
    clear dt
    legno=legno+1;
    dt=Wall(sj).unaff;
    leg=[leg;repmat(legno,size(dt,2),1)];
    Wmatrix=[Wmatrix;dt'];
    clear dt    
end
Wmatrix(52:54,:)=Wmatrix(56:58,:);
Wmatrix=Wmatrix(1:54,:);
leg(52:54)=leg(56:58);
leg=leg(1:54);

Wmatrix2=NaN(size(Wmatrix));
for i=1:size(Wmatrix,1)
    dt=Wmatrix(i,:);
%     dt=dt-min(dt);
    maxt=max(dt);
    dt=dt./maxt;
    Wmatrix2(i,:)=dt;
    clear dt maxt
end

D=pdist(Wmatrix2,'minkowski',5);
%Z=linkage(D,'median');
Z = linkage(Wmatrix2,'ward',{'minkowski',3});

T=table;
T.leg=leg;
%increase the number of clusters untill no legs have the same cluster
%number twice
T.c1=cluster(Z,'maxclust',1);
T.c2=cluster(Z,'maxclust',2);
T.c3=cluster(Z,'maxclust',3);
T.c4=cluster(Z,'maxclust',4);
T.c5=cluster(Z,'maxclust',5);
T.c6=cluster(Z,'maxclust',6);
T.c7=cluster(Z,'maxclust',7);
T.c8=cluster(Z,'maxclust',8);
T.c9=cluster(Z,'maxclust',9);
T.c10=cluster(Z,'maxclust',10);

x=1:8;
figure
bar(x-0.25,Wmatrix(53,:),'FaceColor','g')
hold on
bar(x+0.25,Wmatrix(54,:),'FaceColor','r')

