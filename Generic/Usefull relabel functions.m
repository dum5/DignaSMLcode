%useful relabel code

ll=test.data.labels;
a1=test.data.getDataAsVector(ll);
a2=adaptData.data.getDataAsVector(ll);
ii=adaptData.data.isaLabel(ll);
l1=ll(ii);
a1=test.data.getDataAsVector(l1);
a2=adaptData.data.getDataAsVector(l1);
any(a1~=a2)
[i1,j1]=find(a1~=a2);
changed=unique(j1);
dd=a1-a2;
[i1,j1]=find(~isnan(a1) & a1~=a2);
changed=unique(j1);
l1(131)
l1(220)
test.data.getLabelsThatMatch('Angle')
adaptData.data.getLabelsThatMatch('Angle')
test.data.getLabelsThatMatch('Angle')
adaptData.data.getLabelsThatMatch('Angle')
test.data.getLabelsThatMatch('Angle')
aux=test.data.getLabelsThatMatch('_s[ ]')
test.data.renameLabels(aux,regexprep(aux,'_s ',''))
test2=test.data.renameLabels(aux,regexprep(aux,'_s ',''))
test2.data.getLabelsThatMatch('Angle')
test2.getLabelsThatMatch('Angle')
test2=test.data.renameLabels(aux,regexprep(aux,'_s[ ]?',''))
test2.getLabelsThatMatch('Angle')
aux=test.data.getLabelsThatMatch('_s[ ]?')
test2=test.data.renameLabels(aux,regexprep(aux,'_s[ ]?',''))
test2.getLabelsThatMatch('Angle')
ll2=test.data.labels;
a1b=test.data.getDataAsVector(l1);
a1b=a2;
a1b=test.data.getDataAsVector(l1);
a1b-a2;
a1b=test.data.getDataAsVector(l12);
ll2=test2.data.labels;
ll2=test2.Data.labels;
test.data.labels
test2=test.data.renameLabels(aux,regexprep(aux,'_s[ ]?',''))
reservetest=test;
test.data.renameLabels(aux,regexprep(aux,'_s ',''))
aux=test.data.getLabelsThatMatch('_s[ ]?')
test.data.renameLabels(aux,regexprep(aux,'_s ',''))
test.data.labels
test.data.renameLabels(aux,regexprep(aux,'_s[ ]?',''))
test.data.labels
test.data.renameLabels(aux,regexprep(aux,'_s[ ]?',''))
a1b=ans.getDataAsVector(ll2);
a2b=adaptData.getDataAsVector(ll2);
a2=adaptData.data.getDataAsVector(l12);
a2b=adaptData.getDataAsVector(ll2);
a2b=adaptData.getDataAsVector(ll);
a2=adaptData.data.getDataAsVector(l1);
a2b=adaptData.data.getDataAsVector(l12);
plotParamTimeCourse(test,{'skneeAngle1'},1,[],[],1)
dbquit
plotParamTimeCourse(test,{'skneeAngle_s1'},1,[],[],1)
dbquit
plotParamTimeCourse(test,{'skneeAngle_s 1'},1,[],[],1)
dbquit
test.data.labels{821}
plotParamTimeCourse(test,{'skneeAngle_s 1'},1,[],[],1)
dbquit