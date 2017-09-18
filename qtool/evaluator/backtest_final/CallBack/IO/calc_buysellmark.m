%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڼ����֤ȯ����ʱ�����š�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output_b,output_s, output_shortb, output_shorts] = calc_buysellmark(signal,configure)
% Ԥ�������ʼ��
nPeriod  =  size(signal, 1);
output_b{1}  =  zeros(nPeriod,1);
output_s{1}  =  zeros(nPeriod,1);
output_shortb{1}  =  zeros(nPeriod,1);
output_shorts{1}  =  zeros(nPeriod,1);
lag = configure.lag;

% ���źŷ�Ϊ sig_long, sig_short ���֣������������շֱ��¼
% �ź����˳��һ����λ
signal  =  [zeros(lag,1); signal(1:end - lag)];
sig_long  =  zeros(nPeriod, 1);
sig_short =  zeros(nPeriod, 1);
sig_long(signal > 0)  =  signal(signal > 0);
sig_short(signal< 0)  =  signal(signal < 0);

% �����źţ�������ʵ������ֵ��Ҳ��Ϊ�������������
spread_long  =  sig_long - [0;sig_long(1:end-1)];
spread_short =  sig_short- [0;sig_short(1:end-1)];

% ��¼�ź�
% output_b ��������Ϊ�Ӷ�֣�����Ϊ�ӿղ�
output_b{1}(spread_long > 0)  =  spread_long(spread_long > 0);
output_shortb{1}(spread_short< 0)  =  spread_short(spread_short<0);
% output_c ��������Ϊƽ�ղ֣�����Ϊƽ���
output_s{1}(spread_long < 0)  =  spread_long(spread_long < 0);
output_shorts{1}(spread_short> 0)  =  spread_short(spread_short>0);

end