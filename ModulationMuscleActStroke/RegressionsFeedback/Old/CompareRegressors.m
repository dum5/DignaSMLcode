function [chi2,p]=CompareRegressors(Cmod,Smod,singleComp,tail)


%keyboard
if singleComp==0 
    %compute p and chisquare in 2d space
    %TO do: check if df is equal to the number of regressors; yes for Chi2 test
    %       check if we need to divide covariance matrices by 2     ,no Accoring to Pablo
    %       check if variance on the diagonal is from single regressors,    correct
    %       divide p-val by 2 for onetail, checked with Pablo that is correct
    chi2=transpose(Cmod.Coefficients.Estimate-Smod.Coefficients.Estimate)...
        *((Cmod.CoefficientCovariance+Smod.CoefficientCovariance)^-1)*((Cmod.Coefficients.Estimate-Smod.Coefficients.Estimate));
    p=chi2cdf(chi2,length(Cmod.Coefficients.Estimate),'upper');
 %keyboard   
elseif singleComp==1
    for c=1:length(Cmod.Coefficients.Estimate)
        chi2(c,1)=((Cmod.Coefficients.Estimate(c)-Smod.Coefficients.Estimate(c))^2)*((Cmod.CoefficientCovariance(c,c)+Smod.CoefficientCovariance(c,c))^-1);
        p(c,1)=chi2cdf(chi2(c),1,'upper');        
    end
    
end

if tail==1
   % p=p/2;
end

end

%Note, a Hotelling T-distribution may be what we need since the covariance
%matrices are estimated and not known