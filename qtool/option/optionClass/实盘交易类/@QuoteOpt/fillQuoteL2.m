% [ self ] = fillQuoteL2(self, l2_str);
function [ self ] = fillQuoteL2( self, str)

% ����38�� 37λ���ַ���������������
% Data Sample:
% ����ʱ��(s)	DataStatus	֤ȯ����	ȫ��(1)/����(2)	���ս����	���ս����	���̼�	��߼�	��ͼ�	���¼�	���̼�	��̬�ο��۸�	����ƥ������	��ǰ��Լδƽ����	������1	�����1	������2	�����2	������3	�����3	������4	�����4	������5	�����5	������1	������1	������2	������2	������3	������3	������4	������4	������5	������5	�ɽ�����	�ɽ����	��Ʒʵʱ�׶α�־	�г�ʱ��(0.01s)
% 83834,0,00000000,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, ,83833950
data = regexp(str,',','split');

for i  = 1:36
    d(i) = str2double(data{i});
end

%

t = self.latest;
if isempty(t)||isnan(t) || t == 0
    t = 1;
end

if (d(4) == 1) % ȫ������
    self.quoteTime   = data{1};%     ����ʱ��(s)
    % self.dataStatus  = d(2);%    DataStatus
    % self.secCode     = data{3};%֤ȯ����
    % self.accDeltaFlag= d(4);%ȫ��(1)/����(2)
    self.preSettle   = d(5);%���ս����
    % self.settle      = d(6);%���ս����
    self.open        = d(7);%���̼�
    self.high    = d(8);%��߼�
    self.low     = d(9);%��ͼ�
    self.last    = d(10);%���¼�
    self.close   = d(11);%���̼�
    self.refP    = d(12);%��̬�ο��۸�
    self.virQ    = d(13);%����ƥ������
    self.openInt = d(14);%��ǰ��Լδƽ����
    self.bidQ1   = d(15);%������1
    self.bidP1   = d(16);%�����1
    self.bidQ2   = d(17);%������2
    self.bidP2   = d(18);%�����2
    self.bidQ3   = d(19);%������3
    self.bidP3   = d(20);%�����3
    self.bidQ4   = d(21);%������4
    self.bidP4   = d(22);%�����4
    self.bidQ5   = d(23);%������5
    self.bidP5   = d(24);%�����5
    self.askQ1   = d(25);%������1
    self.askP1   = d(26);%������1
    self.askQ2   = d(27);%������2
    self.askP2   = d(28);%������2
    self.askQ3   = d(29);%������3
    self.askP3   = d(30);%������3
    self.askQ4   = d(31);%������4
    self.askP4   = d(32);%������4
    self.askQ5   = d(33);%������5
    self.askP5   = d(34);%������5
    self.diffVolume = d(35) - self.volume;
    self.volume  = d(35);%�ɽ�����
    self.diffAmount = d(36) - self.amount;
    self.amount  = d(36);%�ɽ����
else %��������
    % ��ʱ��ʹ���������飬�������̫��Ƶ��
end


end

