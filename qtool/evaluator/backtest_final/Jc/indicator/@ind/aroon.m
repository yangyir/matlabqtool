function [ aroon_up, aroon_down ] = aroon(HighPrice,LowPrice,nDay)
% ָ�� Aroon 
% ���أ�aroon.up, aroon.down
% ���룺�����ݡ� ��߼ۣ���ͼ�
%       �������� nDay �ع�������Ĭ��25��
% daniel 2013/4/16

% Ԥ����
if nargin<2, error('not enough inputs'); end
if ~exist('nDay','var'),    nDay = 25;   end
[nPeriod, nAsset] = size(HighPrice);
aroon_up   = nan(nPeriod, nAsset);
aroon_down = nan(nPeriod, nAsset);

% ���㲽
for iPeriod = nDay : nPeriod
    [~, maxp] = max(HighPrice(iPeriod - nDay+1:iPeriod,:));
    [~, minp] = min( LowPrice(iPeriod - nDay+1:iPeriod,:));
    aroon_up(iPeriod,:) =  100*maxp/nDay;
    aroon_down(iPeriod,:) = 100*minp/nDay;
end

end %EOF