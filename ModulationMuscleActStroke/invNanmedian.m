function y = invNanmedian(x,dim)


if nargin == 1
    y = -1*prctile(x, 50);
else
    y = -1*prctile(x, 50,dim);
end
