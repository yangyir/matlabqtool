function [ obj ] = fillL2Data( obj, str)
% ��struct�����l2���ݣ�ʹ��xml��Ĭ��˳��


% ����38�� 37λ���ַ���������������
data = regexp(str,',','split');

for i  = 1:36
    d(i) = str2double(data{i});
end

% 

t = obj.latest;
if isempty(t)||isnan(t) || t == 0
    t = 1;
end

obj.quoteTime   = d(1);%     ����ʱ��(s)
obj.dataStatus  = d(2);%    DataStatus
obj.secCode     = data{3};%֤ȯ����
obj.accDeltaFlag= d(4);%ȫ��(1)/����(2)
obj.preSettle   = d(5);%���ս����
obj.settle      = d(6);%���ս����
obj.open        = d(7);%���̼�
obj.high    = d(8);%��߼�
obj.low     = d(9);%��ͼ�
obj.last    = d(10);%���¼�
obj.close   = d(11);%���̼�
obj.refP    = d(12);%��̬�ο��۸�
obj.virQ    = d(13);%����ƥ������
obj.openInt = d(14);%��ǰ��Լδƽ����
obj.bidQ1   = d(15);%������1
obj.bidP1   = d(16);%�����1
obj.bidQ2   = d(17);%������2
obj.bidP2   = d(18);%�����2
obj.bidQ3   = d(19);%������3
obj.bidP3   = d(20);%�����3
obj.bidQ4   = d(21);%������4
obj.bidP4   = d(22);%�����4
obj.bidQ5   = d(23);%������5
obj.bidP5   = d(24);%�����5
obj.askQ1   = d(25);%������1
obj.askP1   = d(26);%������1
obj.askQ2   = d(27);%������2
obj.askP2   = d(28);%������2
obj.askQ3   = d(29);%������3
obj.askP3   = d(30);%������3
obj.askQ4   = d(31);%������4
obj.askP4   = d(32);%������4
obj.askQ5   = d(33);%������5
obj.askP5   = d(34);%������5
obj.volume  = d(35);%�ɽ�����
obj.amount  = d(36);%�ɽ����
obj.rtflag  = data{37};%��Ʒʵʱ�׶α�־
obj.mktTime = str2num(data{38});%�г�ʱ��(0.01s)



end

