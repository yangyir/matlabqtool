function [sig_long, sig_short, sig_rs ] = Rsi(bar, long, short,type)
%% ������� RSI ���������ǿ���ź�;
% rsi Ϊ����ָ�꣬���ֻ���ǿ���źţ�
% ���� price Ϊÿ�����̼ۣ�
% ���� long��short �������㲻ͬ�����µ� rsi
% ���Ϊǿ���ź� sig_rs �Լ� rsi

%% ����Ԥ�����Լ���ʼ��
if ~exist('long', 'var') || isempty(long), long = 14; end
if ~exist('short', 'var') || isempty(short), short = 7; end
if ~exist('type', 'var') || isempty(type), type=1; end
price = bar.close;

%% ָ��
[sig_long, sig_short, sig_rs] = tai.Rsi(price, long, short, type);


if nargout == 0
    rsi.long = ind.rsi(price, long);
    rsi.short = ind.rsi(price, short);
    bar.plotind2(sig_rs, rsi, true);
    title('rsi rs');
end
end