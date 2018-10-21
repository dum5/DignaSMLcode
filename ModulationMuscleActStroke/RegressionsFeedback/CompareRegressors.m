function [chi2,p]=CompareRegressors(Cmod,Smod,singleComp,tail)

if singleComp==0 
    %compute p and chisquare in 2d space
    %TO do: check if df is equal to the number of regressors
    chi2=transpose(Cmod.Coefficients.Estimate-Smod.Coefficients.Estimate)...
        *((Cmod.CoefficientCovariance+Smod.CoefficientCovariance)^-1)*(Cmod.Coefficients.Estimate-Smod.Coefficients.Estimate);
    p=chi2cdf(chi2,length(Cmod.Coefficients.Estimate),'upper');
    
elseif singleComp==1
    for c=1:length(Cmod.Coefficients.Estimate)
        chi2(c,1)=((Cmod.Coefficients.Estimate(c))^2)*((Cmod.CoefficientCovariance(c,c)+Smod.CoefficientCovariance(c,c))^-1);
        p(c,1)=chi2cdf(chi2(c),1,'upper');        
    end
    
end

if tail==1
    p=p/2;
end

end