function [sig_long, sig_short,sig_rs] = Pvt(bar, nBar, type)
% Price Volume Trend ��������ָ��
%
% PVTָ����㹫ʽ[1]
% �����x��(�������̼ۡ��������̼�)���������̼ۡ����ճɽ�����
% ��ô����PVTָ��ֵ��Ϊ�ӵ�һ����������ÿ��Xֵ���ۼӡ�


%% Ԥ����
ClosePrice = bar.close;
Volume = bar.volume;
if ~exist('nBar', 'var'), nBar = 5; end
if ~exist('type', 'var') || isempty(type), type = 1; end

%% ���㲽
[sig_long, sig_short, sig_rs] = tai.Pvt( ClosePrice, Volume, nBar, type);

if nargout == 0
    pvt.pvt = ind.pvt(ClosePrice, Volume);
    bar.plotind2(sig_long + sig_short, pvt, true);
    title('pvt long and short');
    bar.plotind2(sig_rs, pvt, true);
    title('pvt rs');
end
end



