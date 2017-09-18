
function [sig_long, sig_short] = Asi(bar, nBar, type)
% ASI ������ָ��
% ���룺
%�����ݡ� ���̣���ߣ���ͣ�����
%�������� ����ǰ�ڸߵ͵��mu_up, mu_down
% �����sig_long, sig_short, asi

if ~exist('nBar', 'var') || isempty(nBar), nBar = 5; end
if ~exist('type', 'var') || isempty(type), type = 1; end

close = bar.close;
open = bar.open;
high = bar.high;
low = bar.low;

[sig_long, sig_short] = tai.Asi(open, high, low, close, nBar, type);

if nargout == 0
    [asi.asi, asi.si] = ind.asi(open, high, low, close);
    bar.plotind2(sig_long + sig_short, asi, true);
    title('Asi long and short');
end
end 











