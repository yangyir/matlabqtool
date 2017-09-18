function [ self ] = fillQuoteCTP(self)
% [ self ] = fillQuoteCTP(self)
%  [mktdata, level_p, update_time] = getoptquote(asset_code) 
%  ����mktΪ 5*1 ����ֵ����������Ϊ���¼ۣ����̼ۣ���߼ۣ���ͼۣ��ɽ���
%  level_p Ϊ�����۸��̿����ݣ�5*4����
%  update_time ������ʱ����ַ�����
%-----------------------------
% �콭 20160622 first draft
if self.srcId == -1
[mkt, level, updatetime] = getoptquote(num2str(self.code));
else
    [mkt, level, updatetime] = ctpgetquote_mex(self.srcId, num2str(self.code));
end

%������¼�
self.last = mkt(1);%��Ȩ���¼�
self.open = mkt(2);
self.high = mkt(3);
self.low = mkt(4);
self.diffVolume = mkt(5) - self.volume;%��Ȩ�ۼƳɽ�������
self.volume = mkt(5);%��Ȩ�ۼƳɽ���
self.quoteTime = updatetime;

self.bidP1 = level(1,1);%�����1
self.bidQ1 = level(1,2);%������1
self.askP1 = level(1,3);%������1	
self.askQ1 = level(1,4);%������1	

end