function [ self ] = fillQuoteCTP(self)
% [ self ] = fillQuoteCTP(self)
%  [mktdata, level_p, update_time] = getoptquote(asset_code) 
%  ����mktΪ 6*1 ����ֵ����������Ϊ���¼ۣ����̼ۣ���߼ۣ���ͼۣ��ɽ���, �����̼�
%  level_p Ϊ�����۸��̿����ݣ�5*4����
%  update_time ������ʱ����ַ�����
%-----------------------------
% �콭 20160622 first draft
% �콭 20170111 ��������
if self.srcId == -1
[mkt, level, updatetime] = getoptquote(num2str(self.code));
else
    [mkt, level, updatetime] = ctpgetquote_mex(self.srcId, num2str(self.code));
end

%������¼�
s_mkt = getoptquote(num2str(self.underCode));
self.S = s_mkt(1);
self.last = mkt(1);%��Ȩ���¼�
self.open = mkt(2);
self.high = mkt(3);
self.low = mkt(4);
self.diffVolume = mkt(5) - self.volume;%��Ȩ�ۼƳɽ�������
self.volume = mkt(5);%��Ȩ�ۼƳɽ���
self.preClose = mkt(6);
self.preSettle = mkt(7);
self.quoteTime = updatetime;

self.bidP1 = level(1,1);%�����1
self.bidQ1 = level(1,2);%������1
self.bidP2 = level(2,1);%�����2
self.bidQ2 = level(2,2);%������2
self.bidP3 = level(3,1);%�����3
self.bidQ3 = level(3,2);%������3
self.bidP4 = level(4,1);%�����4
self.bidQ4 = level(4,2);%������4
self.bidP5 = level(5,1);%�����5
self.bidQ5 = level(5,2);%������5

self.askP1 = level(1,3);%������1	
self.askQ1 = level(1,4);%������1	
self.askP2 = level(2,3);%������2	
self.askQ2 = level(2,4);%������2	
self.askP3 = level(3,3);%������3	
self.askQ3 = level(3,4);%������3	
self.askP4 = level(4,3);%������4	
self.askQ4 = level(4,4);%������4	
self.askP5 = level(5,3);%������5	
self.askQ5 = level(5,4);%������5	

end