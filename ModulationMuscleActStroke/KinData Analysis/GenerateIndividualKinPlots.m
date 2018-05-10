clear all
close all

load('C:\Users\did35\OneDrive - University of Pittsburgh\Projects\Modulation of muscle activity in stroke\GroupData\groupedParams_wMissingParameters.mat')

params={'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netContributionNorm2'};
savedir='C:\Users\did35\OneDrive - University of Pittsburgh\Projects\Modulation of muscle activity in stroke\Plots\Individual plots kinematics\'

for i=1:16
    controls.adaptData{i}.plotParamTimeCourse(params)
    ph = flipud(findobj(gcf,'type','axes'));
    for h=1:length(ph)
        ylabel(ph(h),'')
        title(ph(h),params{h})
        saveas(gcf,[savedir,'C0',num2str(i),'.png'])
    end
    close all;clear ph;
    patients.adaptData{i}.plotParamTimeCourse(params)
    ph = flipud(findobj(gcf,'type','axes'));
    for h=1:length(ph)
        ylabel(ph(h),'')
        title(ph(h),params{h})
        saveas(gcf,[savedir,'P0',num2str(i),'.png'])
    end
    close all;clear ph;
    
end