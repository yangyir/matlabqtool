function cmfVal = cmf ( HighPrice, LowPrice, ClosePrice, Volume, nDay)
% Chaikin Money Flow 
% default nDay = 20
% daniel 2013/4/16

% 预处理
if ~exist('nDay','var')
    nDay = 20; %默认回溯天数为20日
end
[nPeriod, nAsset] = size(ClosePrice);
cmfVal   = zeros(nPeriod, nAsset);

% 计算步
% 1. Money Flow Multiplier = [(Close  -  Low) - (High - Close)] /(High - Low) 
% 2. Money Flow Volume = Money Flow Multiplier x Volume for the Period
% 3. 20-period CMF = 20-period Sum of Money Flow Volume / 20 period Sum of Volume 

% Money Flow Multiplier
mfm = ((ClosePrice-LowPrice)-(HighPrice-ClosePrice))./(HighPrice-LowPrice);

% Money Flow Volume
mfv = mfm.*Volume;

% Chaikin Money Flow
for iPeriod = nDay : nPeriod
    cmfVal(iPeriod, :) = sum(mfv(iPeriod-nDay+1:iPeriod,:))./sum(Volume(iPeriod-nDay+1:iPeriod,:));
end

end %EOF
