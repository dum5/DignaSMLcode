clear all
close all

[num,txt,raw]=xlsread('Z:\Users\Digna\Projects\Effort study\CMU collaboration\Analyze data Yashar\Interim July2017\Summary Stroke Study Jun1st.xlsx','Sheet1');

figure
x=[0 1 2];
for pt=1:7
    subplot(3,3,pt)
    hold on
    r1=3*pt-2;
    meanday2=[num(r1,4) num(r1,8) num(r1,12)];
    sdday2=[num(r1,3) num(r1,7) num(r1,11)];
    r2=3*pt-1;
    meanday3=[num(r2,4) num(r2,8) num(r2,12)];
    sdday3=[num(r2,3) num(r2,7) num(r2,11)];
    r3=3*pt;
    meanday4=[num(r3,4) num(r3,8) num(r3,12)];
    sdday4=[num(r3,3) num(r3,7) num(r3,11)];
    errorbar(x,meanday2,sdday2)
    errorbar(x,meanday3,sdday3)
    errorbar(x,meanday4,sdday4)  
    title(['PT ',num2str(num(3*pt,1))])
    
    
end