function [ obj ] = dispL2Data( obj )
%DISPL2DATA 显示一下L2Data的信息
% 程刚，20151109


% disp(obj.quoteTime)
l1 = sprintf('时%d\t码%s\t态%d' , obj.quoteTime, obj.secCode, obj.dataStatus);

if obj.accDeltaFlag == 2 % 增量
    l1 = sprintf('%s\t增量',l1);         
elseif obj.accDeltaFlag == 1 % 全量
    l1 = sprintf('%s\t全量',l1);
end
l1 = sprintf('%s\trtFlag%s\t市时%d\n',l1, obj.rtflag,obj.mktTime);


kgds = sprintf('昨结%0.4f\t开%0.4f\t高%0.4f\t低%0.4f\t收%0.4f\t结%0.4f\n', obj.preSettle,obj.open, obj.high, obj.low, obj.close,obj.settle);
price = sprintf('新%0.4f\t动参%0.4f\t虚配%0.4f\n', obj.last, obj.refP, obj.virQ);
liang = sprintf('量%d\t额%0.4f\t仓%d\n', obj.volume, obj.amount, obj.openInt);

order = '';
order = sprintf(    ' 卖5：   %0.4f\t%d', obj.askP5, obj.askQ5);
order = sprintf('%s\n 卖4：   %0.4f\t%d',order, obj.askP4, obj.askQ4);
order = sprintf('%s\n 卖3：   %0.4f\t%d',order, obj.askP3, obj.askQ3);
order = sprintf('%s\n 卖2：   %0.4f\t%d',order, obj.askP2, obj.askQ2);
order = sprintf('%s\n 卖1：   %0.4f\t%d',order, obj.askP1, obj.askQ1);
order = sprintf('%s\n 买1：   %0.4f\t%d',order, obj.bidP1, obj.bidQ1);
order = sprintf('%s\n 买2：   %0.4f\t%d',order, obj.bidP2, obj.bidQ2);
order = sprintf('%s\n 买3：   %0.4f\t%d',order, obj.bidP3, obj.bidQ3);
order = sprintf('%s\n 买4：   %0.4f\t%d',order, obj.bidP4, obj.bidQ4);
order = sprintf('%s\n 买5：   %0.4f\t%d',order, obj.bidP5, obj.bidQ5);

disp([l1,kgds,price,liang,order])




end

