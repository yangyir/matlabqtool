function  [ psyVal ] = psy(ClosePrice,nDay)
% Psy 心理线
% default nDay  = 12
% daniel 2013/4/16

% 预处理
[nPeriod, nAsset]= size(ClosePrice);
if ~exist('nDay','var')
    nDay = 12;
end

% 计算步
% PSY=N日内上涨天数/N*100
upordown =[nan(1,nAsset); ClosePrice(2:end,:)>ClosePrice(1:end-1,:)];
psyVal = nan(nPeriod, nAsset);

for iPeriod = nDay : nPeriod
    psyVal(iPeriod,:) = 100*nansum(upordown(iPeriod-nDay+1:iPeriod,:))/nDay;
end

end %EOF



    
