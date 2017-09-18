function [sig_rs] = Cmf (bars, nDay, threshold, type)
% Chaikin Money Flow ���������źż�CMF��ֵ

%% Ԥ����
highPrice = bars.high;
lowPrice = bars.low;
closePrice = bars.close;
volume = bars.volume;

if ~exist('threshold', 'var') || isempty(threshold), threshold = 0.05; end
if ~exist('nDay', 'var') || isempty(nDay), nDay = 20; end
if ~exist('type', 'var') || isempty(type), type = 1; end

%% ���㲽
[sig_rs] = tai.Cmf(highPrice, lowPrice, closePrice, volume, nDay, threshold, type);

%% �ź�
if nargout == 0
    cmf.cmf = ind.cmf(highPrice, lowPrice, closePrice, volume, nDay);
    bars.plotind2(sig_rs, cmf, true);
    title('sig long and short');
end

end %EOF
