function  forceVal = force(ClosePrice,Volume,nDay)
% force index
% 输入 Close,volume,表示周期的nDay（默认 13）

% 预处理
if ~exist('nDay','var') 
    nDay = 13;
end
[~, nAsset] = size(ClosePrice);

% 计算步
% FORCE INDEX (i) = VOLUME (i) * ((MA (ApPRICE, N, i) - MA (ApPRICE, N, i-1))
MA = ind.ma(ClosePrice,nDay,'s');
diffMA = [nan(1:nAsset) ; diff(MA)];
forceVal = Volume.* diffMA;

end %EOF




 