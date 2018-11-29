function eh=drawEllipse2D(M,B,ax)
%Draws a 2D ellipse given by %x'*M*X=1 on current axes. M bust be a
%postivie semi-definite matrix for it to work properly,
if nargin<1 || isempty(M)
    M=eye(2);
end
if nargin<3
    ax=gca;
end

th=[0:.1:2*pi 0];
x=sin(th);
y=cos(th);
a=sqrt(1./sum([x;y].*(M*[x;y])));
eh=plot(ax,B(1)+a.*x,B(2)+a.*y);
%eh=plot(ax,B(1)+[a.*x a.*x(1)],B(2)+[a.*y a.*y(1)]);%plot command used to close the circle
end
