function  mtmVal  = mtm(ClosePrice, nDay)
% Momentum 指标 
% default nDay = 10
% 2013/3/21 daniel
% 2013/10/25 , luhuaibao, 原当前天序列上指定为1，现改为0

% 预处理
[nPeriod, nAsset] = size(ClosePrice);
if ~exist('nDay','var')
    nDay = 10;
end

if nPeriod <  nDay
    error('data is not long enough');
end

% 计算步
% mtmVal = [nan(nDay-1,nAsset) ; ClosePrice(nDay:end,:)-ClosePrice(1:end-nDay+1,:)];
mtmVal = [nan(nDay,nAsset) ; ClosePrice(nDay+1:end,:)-ClosePrice(1:end-nDay,:)];

end %EOF