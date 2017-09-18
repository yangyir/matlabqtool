function [dmiup, dmidown, adx ]=dmi(highPrice, lowPrice, closePrice, lag)

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

%%
if ~exist('lag', 'var') || isempty(lag), lag = 14; end
[nPeriod, nAsset] = size(highPrice);

%%
dmup = nan(nPeriod, nAsset);
dmdown = nan(nPeriod, nAsset);
dmup(2:nPeriod, :) = highPrice(2:end,:) - highPrice(1:end-1,:);
dmdown(2:nPeriod, :) = -(lowPrice(2:end,:) - lowPrice(1:end-1,:));
dmup(dmup<0) = 0;
dmdown(dmdown<0) = 0;
dmup(dmup < dmdown) = 0;
dmdown (dmdown < dmup) = 0;

%% ����TR
tr = nan(nPeriod, nAsset);
tr(2:nPeriod, :) = max(abs(highPrice(2:end, :)-lowPrice(2:end, :)),abs(closePrice(1:end-1, :)-highPrice(2:end,:)));
tr(2:nPeriod, :) = max(tr(2:nPeriod, :), abs(closePrice(1:end-1, :) - lowPrice(2:end, :)));
trm = tai.Ma(tr, lag, 0);

dmiup = tai.Ma(dmup, lag, 0)./trm * 100;
dmidown = tai.Ma(dmdown, lag, 0)./trm * 100;

dx = abs(( dmiup - dmidown )./( dmiup + dmidown )) * 100;
adx = tai.Ma( dx, lag, 'e');

