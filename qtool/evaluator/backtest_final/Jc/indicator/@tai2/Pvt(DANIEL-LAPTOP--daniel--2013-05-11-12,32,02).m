function [sig_long, sig_short,sig_rs] = Pvt(bar, mu_up, mu_down, type)
% Price Volume Trend ��������ָ��
%
% PVTָ����㹫ʽ[1]
% �����x��(�������̼ۡ��������̼�)���������̼ۡ����ճɽ�����
% ��ô����PVTָ��ֵ��Ϊ�ӵ�һ����������ÿ��Xֵ���ۼӡ�


%% Ԥ����
ClosePrice = bar.close;
Volume = bar.volume;
if ~exist('mu_up', 'var') || isempty(mu_up), mu_up = 0.02; end
if ~exist('mu_down', 'var') || isempty(mu_down), mu_down = 0.02; end
if ~exist('type', 'var') || isempty(type), type = 1; end

%% ���㲽
[sig_long, sig_short, sig_rs] = tai.Pvt( ClosePrice, Volume, mu_up, mu_down, type);

if nargout == 0
    pvt.pvt = ind.pvt(ClosePrice, Volume);
    bar.plotind2(sig_long + sig_short, pvt, true);
    title('pvt long and short');
    bar.plotind2(sig_rs, pvt, true);
    title('pvt rs');
end
end



