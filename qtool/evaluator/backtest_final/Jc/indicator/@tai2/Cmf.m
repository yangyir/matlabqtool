function [sig_rs] = Cmf (bar, nDay, threshold, type)
% Chaikin Money Flow ���������źż�CMF��ֵ

%% Ԥ����
highPrice = bar.high;
lowPrice = bar.low;
closePrice = bar.close;
volume = bar.volume;

if ~exist('threshold', 'var') || isempty(threshold), threshold = 0.05; end
if ~exist('nDay', 'var') || isempty(nDay), nDay = 20; end
if ~exist('type', 'var') || isempty(type), type = 1; end

%% ���㲽
[sig_rs] = tai.Cmf(highPrice, lowPrice, closePrice, volume, nDay, threshold, type);

%% �ź�
if nargout == 0
    cmf.cmf = ind.cmf(highPrice, lowPrice, closePrice, volume, nDay);
    bar.plotind2(sig_rs, cmf, true);
    title('sig long and short');
end

end %EOF
