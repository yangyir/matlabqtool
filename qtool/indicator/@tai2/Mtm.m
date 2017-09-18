function [sig_long, sig_short] = Mtm(bar, nDay)
% MTM ����ָ��
% sig_long: mtm>0; sig_short: mtm<0
% 2013/3/21 daniel

%% Ԥ�����mtm mtm����
closePrice = bar.close;
[nPeriod, nAsset] = size(closePrice);
if nargin<=1 || isempty(nDay)
    nDay = 10;
end

idx = [nan(nDay-1,nAsset) ; closePrice(nDay:end,:)-closePrice(1:end-nDay+1,:)];

%% �ź�
sig_long = zeros(nPeriod, nAsset);
sig_long(logical(crossOver(idx,zeros(nPeriod,nAsset))))=1;

sig_short = zeros(nPeriod, nAsset);
sig_short(logical(crossOver(zeros(nPeriod,nAsset),idx)))=-1;
mtm.mtm = idx;
if nargout == 0
    bar.plotind2(sig_long + sig_short, mtm, true);
    title('sig long and short');
end

end %EOF