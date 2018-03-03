%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform linear regression of selected parameters%
% Parmeters can be self-selected by user          %
%                                                 %
% - Input: Table with parameters                  %
%                                                 %
% - Output: Regression model                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%GenerateParamsTable


varnames=T.Properties.VariableNames';
pred=listdlg('PromptString','Select Predictors','SelectionMode','multiple','ListString',varnames);
pred=varnames(pred);
dependent=listdlg('PromptString','Select dependent variable','SelectionMode','single','ListString',varnames);
dependent=cell2mat(varnames(dependent));
LinearModel.fit(T,'PredictorVars',pred,'ResponseVar',dependent)

