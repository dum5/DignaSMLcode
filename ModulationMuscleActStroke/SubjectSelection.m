
if allSubFlag
    strokesNames=strcat('P00',{'01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16'}); 
    controlsNames=strcat('C00',{'01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16'});
    speedMatch=zeros(32,1);
    fullGroup=zeros(32,1);
    cfull=[2 3 4 5 6 8 9 10 11 12 13 14 15 16];
    sfull=[1 2 4 5 6 8 9 10 11 12 13 14 15 16];
    csp=[2 3 4 5 6 7 9 10 12 16];
    ssp=[1 2 5 8 9 10 13 14 15 16];
    
    speedMatch(csp)=1;
    speedMatch(ssp+16)=1;
    fullGroup(cfull)=1;
    fullGroup(sfull+16)=1;
    
else
    
    if speedMatchFlag
        
        strokesNames=strcat('P00',{'01','02','05','08','09','10','13','14','15','16'}); %Patients > 0.70m/s; N=10; mean speed 0.8784; sd= 0.1235 
        controlsNames=strcat('C00',{'02','03','04','05','06','07','09','10','12','16'}); %Controls < 1.1 m/s;N=10; mean speed=0.9650, sd= 0.1307
        %patients faster than 0.7 m/s 
        %controls slower than 1.1 m/s, except for C0001, because of bad data           
        % ttest for between-group comparison of speed=0.1450
        
    else
        controlsNames={'C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; 
        % Control 1 is removed because of bad data and control 7 is removed
        % to match group size
        
        strokesNames={'P0001','P0002','P0004','P0005','P0006','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};%P0007 was removed because of contralateral atrophy
        %stroke 3 is removed because of bad data and stroke 7 is removed,
        %because of of atypical clinical presentation (i.e. controlateral
        %atrophy     
        
        
    end
end