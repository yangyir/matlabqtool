function histBas( ticks, asklevel, bidlevel )
%HISTBAS hist�����ҵ��ļ۲�
% @luhuaibao
% 2014.6.3

if ~isa(ticks, 'Ticks')
    disp('�����������ͱ�����Ticks');
    return;
end



if ~exist('asklevel','var'), asklevel = 1; end
if ~exist('bidlevel','var'), bidlevel = 1; end


[ bid_ask_spread ] = AnaTicks.bas( ticks, asklevel, bidlevel ) ; 
 
iplot.ihist(bid_ask_spread );
s1 = ['ask',num2str(asklevel),'������,','bid',num2str(bidlevel),'������'];
title(s1,'fontsize',7);
 

end

