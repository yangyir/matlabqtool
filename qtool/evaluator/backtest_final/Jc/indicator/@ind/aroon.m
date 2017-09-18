function [ aroon_up, aroon_down ] = aroon(HighPrice,LowPrice,nDay)
% 指标 Aroon 
% 返回：aroon.up, aroon.down
% 输入：【数据】 最高价，最低价
%       【参数】 nDay 回顾天数（默认25）
% daniel 2013/4/16

% 预处理
if nargin<2, error('not enough inputs'); end
if ~exist('nDay','var'),    nDay = 25;   end
[nPeriod, nAsset] = size(HighPrice);
aroon_up   = nan(nPeriod, nAsset);
aroon_down = nan(nPeriod, nAsset);

% 计算步
for iPeriod = nDay : nPeriod
    [~, maxp] = max(HighPrice(iPeriod - nDay+1:iPeriod,:));
    [~, minp] = min( LowPrice(iPeriod - nDay+1:iPeriod,:));
    aroon_up(iPeriod,:) =  100*maxp/nDay;
    aroon_down(iPeriod,:) = 100*minp/nDay;
end

end %EOF