function [ self ] = fillQuoteH5( self )
% ȡ ��ֻ��ָ�ڻ� ��ʵʱ�������ݣ� ���뵽����Ȩ��prof��
% --------------------------------
% �ο���20160108
% �콭��20160314


% �����������������������Ϊ1ʱ��ʾ��¼�ɹ�
% mktlogin
% pause(5)

% [mkt, level] = getCurrentPrice(code,marketNo);
% marketNo: �Ϻ�֤ȯ������='1';���='2'; �Ͻ�����Ȩ='3';�н���='5'
% mkt: 5*1��ֵ����, ����Ϊ���¼�,�ɽ���,����״̬(=0��ʾȡ������;=1��ʾδȡ������),���׷�����,������
% level: �̿�����(5*4����), ��1~4������Ϊί���,ί����,ί����,ί����


[mkt, level] = getCurrentPrice(num2str(self.code),'5');
%������¼�
self.last = mkt(1);%��ָ�ڻ����¼�
self.diffVolume = mkt(2) - self.volume;%�ڻ��ۼƳɽ�������
self.volume = mkt(2);%�ڻ��ۼƳɽ���
% ��¼ʱ��
L = length(mkt);
if L > 3
min = mkt(4);
sec = mkt(5);
self.quoteTime = [num2str(min), ':', num2str(sec)];
end

if L > 5
    self.preClose  = mkt(6);
    self.preSettle = mkt(7);
    self.open      = mkt(8);
end

self.bidP1 = level(1,1);%�����1
self.bidQ1 = level(1,2);%������1	
self.askP1 = level(1,3);%������1	
self.askQ1 = level(1,4);%������1	


end

