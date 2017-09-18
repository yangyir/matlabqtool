function [bbiVal] = bbi(ClosePrice, lag1, lag2, lag3, lag4)
% Bull And Bear Index 
% ���롾���ݡ� ���̼�
% �������� 4���ƶ�ƽ���Ļ���������Ĭ�� 3 6 12 24)
% 2013/4/16 daniel

% Ԥ����
[nPeriod, nAsset] = size(ClosePrice);
bbiVal = nan(nPeriod , nAsset);
if ~exist('lag4','var')
    lag4 = 24;
end
if ~exist('lag3','var')
    lag3 = 12;
end
if ~exist('lag2','var')
    lag2 = 6;
end
if ~exist('lag1','var')
    lag1 = 3;
end

% ����
% BBI��(���վ��ۣ����վ��ۣ������վ��ۣ������վ���)�£�
ma1 = ind.ma(ClosePrice,lag1,'e');
ma2 = ind.ma(ClosePrice,lag2,'e');
ma3 = ind.ma(ClosePrice,lag3,'e');
ma4 = ind.ma(ClosePrice,lag4,'e');
bbiVal = 0.25*(ma1+ma2+ma3+ma4);

end %EOF