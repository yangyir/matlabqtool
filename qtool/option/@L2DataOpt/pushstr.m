function [ obj ] = pushstr( obj, str)
% ��struct�����l2���ݣ�ʹ��xml��Ĭ��˳�򣬶��Ÿ���
% �̸գ�20151112

% ����38�� 37λ���ַ���������������
data = regexp(str,',','split');

for i  = 1:36
    d(i) = str2double(data{i});
end

%

% ȡlatest
t = obj.latest;
if isnan(t) %|| t == 0
    t = 1;
end
t = t+1;
obj.latest = t;


try 
obj.quoteTime(t)   = d(1);%     ����ʱ��(s)
obj.dataStatus(t)  = d(2);%    DataStatus
obj.secCode{t}     = data{3};%֤ȯ����
obj.accDeltaFlag(t)= d(4);%ȫ��(1)/����(2)
obj.preSettle(t)   = d(5);%���ս����
obj.settle(t)      = d(6);%���ս����
obj.open(t)        = d(7);%���̼�
obj.high(t)    = d(8);%��߼�
obj.low(t)     = d(9);%��ͼ�
obj.last(t)    = d(10);%���¼�
obj.close(t)   = d(11);%���̼�
obj.refP(t)    = d(12);%��̬�ο��۸�
obj.virQ(t)    = d(13);%����ƥ������
obj.openInt(t) = d(14);%��ǰ��Լδƽ����
obj.bidQ1(t)   = d(15);%������1
obj.bidP1(t)   = d(16);%�����1
obj.bidQ2(t)   = d(17);%������2
obj.bidP2(t)   = d(18);%�����2
obj.bidQ3(t)   = d(19);%������3
obj.bidP3(t)   = d(20);%�����3
obj.bidQ4(t)   = d(21);%������4
obj.bidP4(t)   = d(22);%�����4
obj.bidQ5(t)   = d(23);%������5
obj.bidP5(t)   = d(24);%�����5
obj.askQ1(t)   = d(25);%������1
obj.askP1(t)   = d(26);%������1
obj.askQ2(t)   = d(27);%������2
obj.askP2(t)   = d(28);%������2
obj.askQ3(t)   = d(29);%������3
obj.askP3(t)   = d(30);%������3
obj.askQ4(t)   = d(31);%������4
obj.askP4(t)   = d(32);%������4
obj.askQ5(t)   = d(33);%������5
obj.askP5(t)   = d(34);%������5
obj.volume(t)  = d(35);%�ɽ�����
obj.amount(t)  = d(36);%�ɽ����
obj.rtflag{t}  = data{37};%��Ʒʵʱ�׶α�־
obj.mktTime(t) = str2num(data{38});%�г�ʱ��(0.01s)
catch
    % ��ʧ�ܣ��ع�
    obj.latest = obj.latest - 1;
end


end

