function  [ sig_long, sig_short] = reframeSig( bars , ind , freq )
% ���ɻ��ڲ�ͬƵ���µ��ź�
% ���ص��ź��ǻ���ԭʼ���ݵ�Ƶ�ʣ����1����Ƶ������1����Ϊ����
% bars���������ݣ�Ĭ��1����Ƶ���ڻ����ݣ�
% ind���źź���, ��ҪԤ������
% freq�� Ƶ�� ��Ĭ��=5�� ��ʾ5���ӣ�, ��ֵ���ڡ�1~269������������
%       ���磬5���Ӽ������һ�������źţ���һֱ����һ��������߿�ʼǰ��ָ�겻��
% @ daniel 20130605 version 1.0
if ~exist('freq','var'), freq = 5; end

barsFreq = reframeBars(bars, freq);
sig_long = zeros(size(bars.time,1), 1);
sig_short = sig_long;

[sigLongFreq, sigShortFreq]  = ind(barsFreq);

for i = 1:length(barsFreq.time)-1
    idxFirst = find(bars.time == barsFreq.time(i));
    idxLast  = find(bars.time == barsFreq.time(i+1))-1;
    sig_long(idxFirst:idxLast) = sigLongFreq(i);
    sig_short(idxFirst:idxLast) = sigShortFreq(i);
end
%EOF
        
    