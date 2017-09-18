function [sig_long, sig_short] = Ac(bars, nDay, mDay, type)
%accelerator oscillator  ���ؽ����ź�(-1,0,1)��acֵ
%����
% �����ݡ�HighPrice, LowPrice ��ʱ�� X ��Ʊ����
% ��������nDay, mDay ���ٺ������ƶ�ƽ���������� ����Ȼ����
%   Yan Zhang   version 1.0 2013/3/12
highPrice = bars.high;
lowPrice = bars.low;

%% Ԥ����
if ~exist('nDay', 'var') || isempty(nDay), nDay = 2; end
if ~exist('mDay', 'var') || isempty(mDay), mDay = 20; end
if ~exist('type', 'var') || isempty(type), type = 1; end

%% ����tai
[sig_long, sig_short] = tai.Ac(highPrice,lowPrice,nDay,mDay, type);

%% ��ͼ
if nargout == 0
    ac.aco = ind.aco(highPrice, lowPrice, nDay, mDay);
    bars.plotind2( sig_long + sig_short, ac, true);
    title('AC long and short');
end
end %EOF
 