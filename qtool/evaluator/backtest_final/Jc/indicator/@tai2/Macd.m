function [ sig_long, sig_short, sig_rs ] = Macd( bar, short, long, compare, type)
% �ú��������ֻ��Ʊ��MACDֵ���Լ�����MACD�Ľ����źź�ǿ���ź�
% macd���ź��ж�����Ϊ��macd�����������������ʱ��sig_rs = 1�����Ǹ���ʱ��sig_rs = -1��
% ���� price Ϊÿ�����̼۵�ʱ�����У�
% ���� short Ϊ�����ƶ�ƽ����������Ĭ��Ϊ 12��
% ���� long  Ϊ�����ƶ�ƽ����������Ĭ��Ϊ 26��
% ����compareΪ��ֵ���ƶ�ƽ��������Ĭ��Ϊ  9��
% ��� sig_long Ϊ����Ľ����źţ�
% ��� sig_shortΪ���յĽ����źţ�
% ��� sig_rsΪǿ���źţ���ʾ����macdָ�����������״̬��
% ��� macd Ϊ struct ���ͣ����а����� macd ָ���������������
% macd ���������źţ���˸�����ƽ�ֽ����źţ�

% ����Ԥ����
if ~exist('short', 'var') || isempty(short), short = 12; end
if ~exist('long', 'var') || isempty(long), long = 26; end
if ~exist('compare', 'var') || isempty(compare), compare = 9; end
if ~exist('type', 'var') || isempty(type), type = 1; end
price = bar.close;

% ����
[sig_long, sig_short, sig_rs] = tai.Macd(price, short, long, compare, type);

if nargout == 0
    [macd.diff, macd.dae, macd.bar] = ind.macd(price, short, long, compare);
    bar.plotind2(sig_long + sig_short, macd, true);
    title('macd long and short');
    bar.plotind2(sig_rs, macd, true);
    title('macd rs');
end

end
