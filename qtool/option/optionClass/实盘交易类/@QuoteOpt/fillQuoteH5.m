function [ self ] = fillQuoteH5( self )
% ȡ ��ֻ��Ȩ ��ʵʱ�������ݣ� ���뵽����Ȩ��prof��
% --------------------------------
% �ο���20160108


% �����������������������Ϊ1ʱ��ʾ��¼�ɹ�
% mktlogin
% pause(5)

% [mkt, level] = getCurrentPrice(code,marketNo);
% marketNo: �Ϻ�֤ȯ������='1';���='2'; �Ͻ�����Ȩ='3';�н���='5'
% mkt: 5*1��ֵ����, ����Ϊ���¼�,�ɽ���,����״̬(=0��ʾȡ������;=1��ʾδȡ������)��
% ���׷�����,������������ۣ����̼ۣ��г�����
% level: �̿�����(5*4����), ��1~4������Ϊί���,ί����,ί����,ί����

% Level �����嵵����Ĺ�Ʊ����Ȩ��˵��
% ������Ϊ ��1�е�����������Ϊ��һ������
% ��������Ϊ �����е���һ������Ϊ��һ�����壬 ����
% �����ڻ�����һ������ģ� ���������ݾ��ڵ�һ�����С�

%        bidQ1;%������1	
%        bidP1;%�����1	
%        bidQ2;%������2	
%        bidP2;%�����2
%        bidQ3;%������3	
%        bidP3;%�����3	
%        bidQ4;%������4	
%        bidP4;%�����4	
%        bidQ5;%������5	
%        bidP5;%�����5	


[mkt, level] = getCurrentPrice(num2str(self.code),'3');
%������¼�
%  underCode Ӧ����510050 ������510050.SH�����޷���ȡ����
self.S = getCurrentPrice(num2str(self.underCode),'1');
self.S = self.S(1);
self.last = mkt(1);%��Ȩ���¼�
self.diffVolume = mkt(2) - self.volume;%��Ȩ�ۼƳɽ�������
self.volume = mkt(2);%��Ȩ�ۼƳɽ���
% ��¼ʱ��
L = length(mkt);
if L > 3
min = mkt(4);
sec = mkt(5);
self.min = min;
self.sec = sec;
% seconds = min * 60 + sec;
self.quoteTime = [num2str(min), ':', num2str(sec)];
end

if L > 5
    self.preClose  = mkt(6);
    self.preSettle = mkt(7);
    self.open      = mkt(8);
end

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

self.askP1 = level(5,3);%������1	
self.askQ1 = level(5,4);%������1	
self.askP2 = level(4,3);%������2	
self.askQ2 = level(4,4);%������2	
self.askP3 = level(3,3);%������3	
self.askQ3 = level(3,4);%������3	
self.askP4 = level(2,3);%������4	
self.askQ4 = level(2,4);%������4	
self.askP5 = level(1,3);%������5	
self.askQ5 = level(1,4);%������5	


end

