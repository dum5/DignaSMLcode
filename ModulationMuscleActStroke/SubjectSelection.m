
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
    
    if speedMatchFlag==1
        
        strokesNames=strcat('P00',{'01','02','05','08','09','10','13','14','15','16'}); %Patients > 0.70m/s; N=10; mean speed 0.8784; sd= 0.1235 
        controlsNames=strcat('C00',{'02','03','04','05','06','07','09','10','12','16'}); %Controls < 1.1 m/s;N=10; mean speed=0.9650, sd= 0.1307
        %patients faster than 0.7 m/s 
        %controls slower than 1.1 m/s, except for C0001, because of bad data           
        % ttest for between-group comparison of speed=0.1450
        
    elseif speedMatchFlag==0
        controlsNames={'C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; 
        % Control 1 is removed because of bad data and control 7 is removed
        % to match group size
        
        strokesNames={'P0001','P0002','P0004','P0005','P0006','P0008','P0009','P0010','P0011','P0012','P0013','P0014','P0015','P0016'};%P0007 was removed because of contralateral atrophy
        %stroke 3 is removed because of bad data and stroke 7 is removed,
        %because of of atypical clinical presentation (i.e. controlateral
        %atrophy     
    elseif speedMatchFlag==2%matched for EMG symmetry
        
        %controlsNames={'C0003','C0012','C0014','C0009','C0011','C0006','C0010','C0015','C0004','C0002'};
        %strokesNames={ 'P0014','P0012','P0011','P0006','P0013','P0016','P0015','P0005','P0009','P0010'};
  
        strokesNames=strcat('P00',{'15','16','13','06','11','12','14'});
        controlsNames=strcat('C00',{'03','12','14','09','11','06','10'});
    elseif speedMatchFlag==3;%matched for kin symmetry
        strokesNames=strcat('P00',{'15','01','13','14','05','06','08'});
         controlsNames={'C0002','C0003','C0004','C0005','C0006','C0008','C0009','C0010','C0011','C0012','C0013','C0014','C0015','C0016'}; 
        
        elseif speedMatchFlag==4%play around with number of symmetric/asymmetric subjects
            n=10;
            dtc={'03', '12', '14', '09', '11', '06', '10', '15', '04', '02', '08', '13', '05', '16'};%from least to most symmetric
            dtp={'14','12','11','06','13','16','15','05','09','10','04','01','02','08'};%from most to least symmetric
            dtc=dtc(1:n);
            dtp=dtp(1:n);
            strokesNames=strcat('P00',dtp);
            controlsNames=strcat('C00',dtc);
            
    end
end