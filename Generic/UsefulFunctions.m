%useful functions, do not run this script

%PLOT BARS FOR INDIVIDUAL SUBJECT
[figHandle,plotHandles]=plotParamBarsByConditionsv2(this,label,number,exemptLast,exemptFirst,condList,mode,plotHandles)
plotParamBarsByConditionsv2(adaptData,{'netContributionNorm2','stepTimeContributionNorm2'},[10 -50 -100],2,2,{'zeroMS35','hundredMS35'},[])
%in number you can define the number of stepts from the beginning
%(positive) or from the end (negative value)


%MAKE SMATRIX
%can be used to make a struct with group data
%data needs to be in this format to use PlotParamsGUI
%store matrix as mat file to run the GUI
data=makeSMatrixV2

%add a new parameter
newThis=addNewParameter(this,newParamLabel,funHandle,inputParameterLabels,newParamDescription);