function [ l ] = dispOpt( obj )
%DISPOPT 输出显示期权的相关信息
% 程刚，20151120


l = '';
if obj.CP == 1, cp = 'call'; elseif obj.CP==2, cp='put'; else cp='na'; end
l = sprintf('%s, %s(K=%0.2f, T=%0.4fyr), %d ',obj.secCode, cp, obj.K, obj.T,obj.quoteTime);

l = sprintf('%s\n         px    qt     vol',l);
l = sprintf('%s\nlast: %7.4f \t%4d \t%6.4f', l, obj.last, obj.volume, obj.vol);
l = sprintf('%s\nask1: %7.4f \t%4d \t%6.4f', l, obj.askP1, obj.askQ1, obj.askvol);
l = sprintf('%s\nbid1: %7.4f \t%4d \t%6.4f', l, obj.bidP1, obj.bidQ1, obj.bidvol);

disp(l)


end

