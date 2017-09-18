function [acVal] = aco(HighPrice,LowPrice,nDay,mDay)
% accelerator oscillator 
% ���� �����ݡ�HighPrice, LowPrice ��ʱ�� X ��Ʊ����
%      ��������nDay, mDay ���ٺ������ƶ�ƽ���������� ��Ĭ�� 5�� 34��
% daniel 2013/4/16

% Ԥ����
if nargin <2, error('not enough input');end
if ~exist('nDay','var'), nDay = 5;  end
if ~exist('mDay','var'), mDay = 34; end

if nDay > mDay %��������������������
    temp = nDay; nDay = mDay; mDay = temp;
end

%  ����acֵ
% AO = SMA(�����, 5)-SMA(�����, 34)
% AC = AO-SMA(AO, 5)

MedPrice = (HighPrice+LowPrice)/2;
ao = ind.ma(MedPrice,nDay,0) - ind.ma(MedPrice,mDay, 0);
acVal = ao - ind.ma(ao, nDay, 0);

end %EOF
 
