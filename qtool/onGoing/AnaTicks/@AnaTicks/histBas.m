function histBas( ticks, asklevel, bidlevel )
%HISTBAS hist买卖挂单的价差
% @luhuaibao
% 2014.6.3

if ~isa(ticks, 'Ticks')
    disp('错误：数据类型必须是Ticks');
    return;
end



if ~exist('asklevel','var'), asklevel = 1; end
if ~exist('bidlevel','var'), bidlevel = 1; end


[ bid_ask_spread ] = AnaTicks.bas( ticks, asklevel, bidlevel ) ; 
 
iplot.ihist(bid_ask_spread );
s1 = ['ask',num2str(asklevel),'档行情,','bid',num2str(bidlevel),'档行情'];
title(s1,'fontsize',7);
 

end

