function [tsiVal] = tsi (ClosePrice, fast, slow)
% TSI ��ʵǿ��ָ��
% default fast = 13, slow =25
% daniel 2013/4/16

% Ԥ����
if ~exist('fast','var')
    fast = 13;
end
if ~exist('slow','var')
    slow = 25;
end
[~, nAsset] = size(ClosePrice);

% ���㲽
momentum = [zeros(1,nAsset); diff(ClosePrice) ];
absMomentum = abs(momentum);

tsiVal = 100*(ind.ma( ind.ma(momentum, slow,'e'), fast, 'e'))./ind.ma(ind.ma(absMomentum,slow,'e'), fast, 'e');

end