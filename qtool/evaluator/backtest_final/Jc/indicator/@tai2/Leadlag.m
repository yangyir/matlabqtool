function  [sig_long, sig_short, sig_rs] = Leadlag(bar, lead, lag, flag, type)
% �������ָ�꣬��2���ƶ�ƽ����Ԥ��۸����ƣ����������ź�
% varin����������ʲ��۸�����
% lead�������ƶ�����
% lag�� �����ƶ�����
% flag���ƶ������㷨

% ������ݼ�Ԥ������ռ�

price = bar.close;

if ~exist('type', 'var') || isempty(type), type = 1; end
if ~exist('lead', 'var') || isempty(lead), lead = 10; end
if ~exist('lag', 'var') || isempty(lag), lag = 30; end
if ~exist('flag', 'var') || isempty(flag), flag = 'e'; end

% ����
[sig_long, sig_short, sig_rs] = tai.Leadlag(price, lead, lag, flag, type);

if nargout == 0
    [leadlag.lead, leadlag.lag] = ind.leadlag(price, lead, lag, flag);
    bar.plotind2(sig_long + sig_short, leadlag);
    title('leadlag long and short');
    bar.plotind2(sig_rs, leadlag);
    title('leadlag rs');
end

end 

