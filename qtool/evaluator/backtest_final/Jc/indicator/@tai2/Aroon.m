function [ sig_long, sig_short, sig_rs ] = Aroon(bar, nDay, upband, lowband, type)
% ����Aroonָ�꼰�ź�
% ���룺
% �����ݡ� ��߼ۣ���ͼ�
% �������� nDay�ع������� upband �Ͻ磨Ĭ��70���� downband�½磨Ĭ��30��
% ����� 
% ����ͷ�źš�sig_long �� ��aroon.up����aroon.downʱ���룬��ƽ��������
% ����ͷ�źš�sig_short�� ��aroon.down����aroon.upʱ���գ���ƽ��������
% ��ǿ����sig_rs����aroon.up��upband��70)���ϲ���aroon.down��lowband��30�����£�Ϊǿ�������г�
% ��aroon.up��upband��30)���²���aroon.down��lowband��70�����ϣ�Ϊ�����½��г�

% The word aroon is Sanskrit for "dawn��s early light". The Aroon indicator
% attempts to show when a new trend is dawning. The indicator consists of
% two lines (Up and Down) that measure how long it has been since the
% highest high/lowest low has occurred within an n period range.
% 
% When the Aroon Up is staying between 70 and 100 then it indicates an
% upward trend. When the Aroon Down is staying between 70 and 100 then it
% indicates an downward trend. A strong upward trend is indicated when the
% Aroon Up is above 70 while the Aroon Down is below 30. Likewise, a strong
% downward trend is indicated when the Aroon Down is above 70 while the
% Aroon Up is below 30. Also look for crossovers. When the Aroon Down
% crosses above the Aroon Up, it indicates a weakening of the upward trend
% (and vice versa).
% 
% The Aroon indicator was developed by Tushar S. Chande and first described
% in the September 1995 issue of Technical Analysis of Stocks & Commodities
% magazine.

%% 1. Ԥ����
if ~exist('lowband', 'var') || isempty(lowband), lowband = 30; end
if ~exist('upband', 'var') || isempty(upband), upband = 70; end
if ~exist('nDay', 'var') || isempty(nDay), nDay = 25; end
if ~exist('type', 'var') || isempty(type), type = 1; end

high = bar.high;
low = bar.low;

[sig_long, sig_short, sig_rs] = tai.Aroon(high, low, nDay, upband, lowband, type);

if nargout == 0
    [aroon.up, aroon.down] = ind.aroon(high, low, nDay);
    bar.plotind2(sig_long + sig_short, aroon, true);
    title('Aroon long and short');
    bar.plotind2(sig_rs, aroon, true);
    title('Aroon rs');
end