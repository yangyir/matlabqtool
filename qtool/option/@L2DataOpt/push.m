function [ obj ] = push( obj, newL2DataRecord )
%PUSH ��һ������newL2DataRecordѹ����ʷ����obj
%   Detailed explanation goes here


%%
% newL2DataRecord = newL2DataRecord;
t = newL2DataRecord.latest;
if t<1, t=1; end;


%% main

l = obj.latest;
l = l+1;
obj.latest = l;


obj.quoteTime(l)    = newL2DataRecord.quoteTime(t);%     ����ʱ��(s)
obj.dataStatus(l)   = newL2DataRecord.dataStatus(t);%    DataStatus
% obj.secCode(l)      = newL2DataRecord.secCode(t);%֤ȯ����
obj.accDeltaFlag(l) = newL2DataRecord.accDeltaFlag(t);%ȫ��(1)/����(2)
obj.preSettle(l)    = newL2DataRecord.preSettle(t);%���ս����
obj.settle(l)   = newL2DataRecord.settle(t);%���ս����
obj.open(l)     = newL2DataRecord.open(t);%���̼�
obj.high(l)     = newL2DataRecord.high(t);%��߼�
obj.low(l)      = newL2DataRecord.high(t);%��ͼ�
obj.last(l)     = newL2DataRecord.last(t);%���¼�
obj.close(l)    = newL2DataRecord.close(t);%���̼�
obj.refP(l)     = newL2DataRecord.refP(t);%��̬�ο��۸�
obj.virQ(l)     = newL2DataRecord.virQ(t);%����ƥ������
obj.openInt(l)  = newL2DataRecord.openInt(t);%��ǰ��Լδƽ����
obj.bidQ1(l) = newL2DataRecord.bidQ1(t);%������1
obj.bidP1(l) = newL2DataRecord.bidP1(t);%�����1
obj.bidQ2(l) = newL2DataRecord.bidQ2(t);%������2
obj.bidP2(l) = newL2DataRecord.bidP2(t);%�����2
obj.bidQ3(l) = newL2DataRecord.bidQ3(t);%������3
obj.bidP3(l) = newL2DataRecord.bidP3(t);%�����3
obj.bidQ4(l) = newL2DataRecord.bidQ4(t);%������4
obj.bidP4(l) = newL2DataRecord.bidP4(t);%�����4
obj.bidQ5(l) = newL2DataRecord.bidQ5(t);%������5
obj.bidP5(l) = newL2DataRecord.bidP5(t);%�����5
obj.askQ1(l) = newL2DataRecord.askQ1(t);%������1
obj.askP1(l) = newL2DataRecord.askP1(t);%������1
obj.askQ2(l) = newL2DataRecord.askQ2(t);%������2
obj.askP2(l) = newL2DataRecord.askP2(t);%������2
obj.askQ3(l) = newL2DataRecord.askQ3(l) ;%������3
obj.askP3(l) = newL2DataRecord.askP3(t);%������3
obj.askQ4(l) = newL2DataRecord.askQ4(t);%������4
obj.askP4(l) = newL2DataRecord.askP4(t);%������4
obj.askQ5(l) = newL2DataRecord.askQ5(t);%������5
obj.askP5(l) = newL2DataRecord.askP5(t);%������5
obj.volume(l) = newL2DataRecord.volume(t);%�ɽ�����
obj.amount(l) = newL2DataRecord.amount(t);%�ɽ����
obj.rtflag(l) = newL2DataRecord.rtflag(t);%��Ʒʵʱ�׶α�־
obj.mktTime(l) = newL2DataRecord.mktTime(t);%�г�ʱ��(0.01s)



%% 
% flds = fields( obj ); 
% 
% 
% 
% 
% for i  =  1: length(flds)
%     fd = flds{i};
% %     if strcmp(fd, 
%     try
%         obj.(fd)(l) = newL2DataRecord.(fd);
%     catch
%         disp(fd);
%     end
%     
% end




end

