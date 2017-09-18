function [ rsiVal, rsVal] = rsi_v2( ClosePrice, nDay, mode)
% Relative Strength Index ���ǿ��ָ��
% ����rsi��rs����ֵ��[nPeriod, nAsset] ����
% default nDay =14
% daniel 2013/4/16

%%20130815 �޸İ汾 �����˼���RSIʱ��ʹ�þ��߼��㷽����ѡ��
% mode��  MA���㷽��
%         e = ָ���ƶ�ƽ��
%         0 = ���ƶ�ƽ��
%         0.5 = ƽ������Ȩƽ��
%         1 = ����ƽ��
%         2 = ƽ����Ȩƽ��

% Ԥ����
if ~exist('nDay','var')
    nDay = 14;
end
[nPeriod, nAsset] = size(ClosePrice);
rsiVal = nan(nPeriod, nAsset);
rsVal  = nan(nPeriod, nAsset);

if nargin<3 || isempty(mode)
    mode = '0';
end

% ���㲽
% RSI = 100 - 100/(1 + RS)
% Where RS = Average of x days' up closes / Average of x days' down closes.
diffClose = [nan(1,nAsset);  diff(ClosePrice)];
diffChg   = abs(diffClose);
advances = diffChg;
declines = diffChg;
advances(diffClose < 0 ) = 0;
declines(diffClose > 0 ) = 0;

[maadv] = ind.ma(advances,nDay,mode);
[madec] = ind.ma(declines,nDay,mode);

for iAsset = 1 : nAsset
    for jPeriod = nDay : nPeriod
        totalGain = maadv(jPeriod);
        totalLoss = madec(jPeriod);
        rsVal(jPeriod,:) = totalGain./totalLoss;
        rsiVal(jPeriod,:) = 100 - (100./(1+rsVal(jPeriod,:)));
    end
end      

end

