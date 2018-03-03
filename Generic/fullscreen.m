%figureFullScreen

scrsz = get(0,'ScreenSize'); % left, bottom, width, height
%for windows:
set(gcf,'OuterPosition',[scrsz(1) scrsz(2)+30 scrsz(3) scrsz(4)-30]); %50 is the number of pixels of the bar at bottom of screen

%for linux or mac:
%figure('Units','normalized','OuterPosition',[0 0 1 1]);
