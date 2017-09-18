function  [sig_rs] = Mfi(bar, nDay,type)
% money flow index �ʽ�����ָ��
% ���Կ��Ǽ��붥�ױ�����Ϊ�ж�����
% 2013/3/21 daniel
%
% ���㷽��
% 1.���ͼ۸�TP��=������߼ۡ���ͼ������̼۵�����ƽ��ֵ
% 2.����������MF��=���ͼ۸�TP����N���ڳɽ����
% 3.�������MF>����MF���򽫵��յ�MFֵ��Ϊ������������PMF��
% 4.�������MF<����MF���򽫵��յ�MFֵ��Ϊ������������NMF��
% 5.MFI=100-[100/(1+PMF/NMF)]
% 6.����Nһ����Ϊ14�ա�
%
% Ӧ�÷���
% 1.��ʾ��������MFIָ��������Ĺ��ܡ���MFI>80ʱΪ���������ͷ���µ���80ʱ��Ϊ��������ʱ����
% 2.��MFI<20ʱΪ�����������ͷ����ͻ��20ʱ��Ϊ�������ʱ����
% 3.��MFI>80����������������ʱ����Ϊ�����źš�
% 4.��MFI<20����������������ʱ����Ϊ����źš�

%% Ԥ��������
high = bar.high;
low = bar.low;
close = bar.close;
volume = bar.volume;

if ~exist('nDay', 'var') || isempty(nDay), nDay = 14; end
if ~exist('type', 'var') || isempty(type), type = 1; end

%% �ź�
sig_rs = tai.Mfi(high, low, close, volume, nDay, type);

if nargout == 0
    mfi.mfi = ind.mfi(high, low, close, volume, nDay);
    bar.plotind2(sig_rs, mfi, true);
    title('mfi rs');
end

end


