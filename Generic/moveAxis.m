function [ax]=moveAxis(ax,vShift,hShift)

for a=1:length(ax(:))
    pos=get(ax(a),'Position');
    pos(2)=pos(2)+vShift;
    pos(1)=pos(1)+hShift;
    set(ax(a),'Position',pos)
end

end