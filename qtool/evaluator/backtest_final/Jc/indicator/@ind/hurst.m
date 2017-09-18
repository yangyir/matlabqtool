function [hurstVal]  =  hurst(ClosePrice, nDay)
% Hurst Index
% daniel 2013/4/17

% Ԥ����
if ~exist('nDay', 'var'), nDay = 250; end
[nPeriod, nAsset] = size(ClosePrice);
hurstVal = nan(nPeriod, nAsset);

% ���㲽
for i = 1:nAsset
    for j= nDay:nPeriod    
        H = wfbmesti(ClosePrice(j-nDay+1:j,i));
        hurstVal(j,i) = H(1);
    end
end

end

