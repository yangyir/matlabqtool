function [ sig_rs ] = Obv( bar, type)
%% �ú����������� OBV �Լ�����Ӧ��ǿ���ź� �� 
% OBV ��������ָ��
% ���� close, vol �ֱ�Ϊ���յ����̼��Լ���������
% ��� sig_rs Ϊ���׵�ǿ���źţ�
% ��� obv Ϊָ�����ֵ��

%% ����Ԥ�������ʼ��
close = bar.close;
vol = bar.volume;
% ������������
long  = 20;
short = 5;
if ~exist('type', 'var') || isempty(type), type = 1; end

%% ���� obv �Լ���Ӧ���źţ�
sig_rs = tai.Obv(close, vol, type);

if nargout == 0
    obv.obv = ind.obv(close, vol);
    bar.plotind2(sig_rs, obv, true);
    title('sig rs');
end

end

