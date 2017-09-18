function  mtmVal  = mtm(ClosePrice, nDay)
% Momentum ָ��
% default nDay = 10
% 2013/3/21 daniel

% Ԥ����
[nPeriod, nAsset] = size(ClosePrice);
if ~exist('nDay','var')
    nDay = 10;
end

if nPeriod <  nDay
    error('data is not long enough');
end

% ���㲽
mtmVal = [nan(nDay-1,nAsset) ; ClosePrice(nDay:end,:)-ClosePrice(1:end-nDay+1,:)];

end %EOF