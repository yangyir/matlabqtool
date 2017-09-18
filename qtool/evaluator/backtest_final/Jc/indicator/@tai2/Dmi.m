function [ sig_long, sig_short, sig_rs] = Dmi( bar, lag, thred, type)
%DMI ����DMI(����ָ�����������ź�
%   ���룺
%    highPrice ��߼۸�
%    lowPrice ��ͼ۸�
%    closePrice ���̼۸�
%    lag ��ʱ��Ĭ��14��
%    thred ADXţƤ�з�ֵ
%   �����
%    sig �����ź�
%    dmi.diup +DI��
%    dmi.didown -DI
%    dmi.dx DXָ��
%    dmi.adx ADXָ����DX����EMA��õ���

if ~exist('lag', 'var') || isempty(lag), lag = 14; end
if ~exist('thred', 'var') || isempty(thred), thred = 18; end
if ~exist('type', 'var') || isempty(type), type = 1; end

highPrice = bar.high;
lowPrice = bar.low;
closePrice = bar.close;

% ����
[sig_long, sig_short, sig_rs] = tai.Dmi(highPrice, lowPrice, closePrice, lag, thred, type);

if nargout == 0
    [dmi.dmiup, dmi.dmidown, dmi.adx] = ind.dmi(highPrice, lowPrice, closePrice, lag);
    bar.plotind2(sig_long + sig_short, dmi, true);
    title('dmi long and short');
    bar.plotind2(sig_rs, dmi, true);
    title('dmi rs');
end

end