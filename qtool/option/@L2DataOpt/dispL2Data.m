function [ obj ] = dispL2Data( obj )
%DISPL2DATA ��ʾһ��L2Data����Ϣ
% �̸գ�20151109


% disp(obj.quoteTime)
l1 = sprintf('ʱ%d\t��%s\t̬%d' , obj.quoteTime, obj.secCode, obj.dataStatus);

if obj.accDeltaFlag == 2 % ����
    l1 = sprintf('%s\t����',l1);         
elseif obj.accDeltaFlag == 1 % ȫ��
    l1 = sprintf('%s\tȫ��',l1);
end
l1 = sprintf('%s\trtFlag%s\t��ʱ%d\n',l1, obj.rtflag,obj.mktTime);


kgds = sprintf('���%0.4f\t��%0.4f\t��%0.4f\t��%0.4f\t��%0.4f\t��%0.4f\n', obj.preSettle,obj.open, obj.high, obj.low, obj.close,obj.settle);
price = sprintf('��%0.4f\t����%0.4f\t����%0.4f\n', obj.last, obj.refP, obj.virQ);
liang = sprintf('��%d\t��%0.4f\t��%d\n', obj.volume, obj.amount, obj.openInt);

order = '';
order = sprintf(    ' ��5��   %0.4f\t%d', obj.askP5, obj.askQ5);
order = sprintf('%s\n ��4��   %0.4f\t%d',order, obj.askP4, obj.askQ4);
order = sprintf('%s\n ��3��   %0.4f\t%d',order, obj.askP3, obj.askQ3);
order = sprintf('%s\n ��2��   %0.4f\t%d',order, obj.askP2, obj.askQ2);
order = sprintf('%s\n ��1��   %0.4f\t%d',order, obj.askP1, obj.askQ1);
order = sprintf('%s\n ��1��   %0.4f\t%d',order, obj.bidP1, obj.bidQ1);
order = sprintf('%s\n ��2��   %0.4f\t%d',order, obj.bidP2, obj.bidQ2);
order = sprintf('%s\n ��3��   %0.4f\t%d',order, obj.bidP3, obj.bidQ3);
order = sprintf('%s\n ��4��   %0.4f\t%d',order, obj.bidP4, obj.bidQ4);
order = sprintf('%s\n ��5��   %0.4f\t%d',order, obj.bidP5, obj.bidQ5);

disp([l1,kgds,price,liang,order])




end

