function [ sig_long,sig_short, sig_rs] = Rsi(price, long, short,type)
%% ������� RSI ���������ǿ���ź�;
% rsi Ϊ����ָ�꣬���ֻ���ǿ���źţ�
% ���� price Ϊÿ�����̼ۣ�
% ���� long��short �������㲻ͬ�����µ� rsi
% ���Ϊǿ���ź� sig_rs �Լ� rsi

%% ����Ԥ�����Լ���ʼ��
if ~exist('long', 'var') || isempty(long), long = 14; end
if ~exist('short', 'var') || isempty(short), short = 7; end
if ~exist('type', 'var') || isempty(type), type=1; end

[nPeriod, nAsset] = size(price);
sig_long   =  zeros(nPeriod,nAsset);
sig_short   =  zeros(nPeriod,nAsset);
sig_rs = zeros(nPeriod, nAsset);

%% ��Բ�ͬ�ʲ�����ź��Լ�ָ����
rsi_long = ind.rsi(price, long);
rsi_short = ind.rsi(price, short);

%% �����ź�
if type==1
     sig_long(crossOver(ones(nPeriod, nAsset)*30, rsi_long)) = 1;
     sig_short(crossOver(rsi_long, ones(nPeriod, nAsset)*70)) = -1;
     sig_rs(rsi_long > 70) = -1;
     sig_rs(rsi_long < 30) = 1;   
elseif type==2
    %��rsi�����ϴ���С��80������ֱ��С��20��ʱ������
    %��rsi�����´���С��80������ֱ�Ӵ���80��ʱ������
    sig_long(   crossOver(rsi_short,rsi_long)    & rsi_short< 80 | rsi_short <20) = 1;
    sig_short(  crossOver(rsi_long, rsi_short)  & rsi_short >20 | rsi_short >80) = -1;
    sig_rs(rsi_short    >   rsi_long   &   rsi_short   < 80    | rsi_short< 20) = 1;
    sig_rs(rsi_short    <   rsi_long   &   rsi_short   > 20    | rsi_short > 80) =-1;
else
    ;
end

end
