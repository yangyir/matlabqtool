function [ holdableMat ] = dhXinguHoldable( tsMat )
% 用DH取数据：股票的可持仓性（未上市，新股未打开，已退市，都不可持仓）
%   tsMat:  提供一个矩阵框架，assets * dates， 是TsMatrix类
% ---------------------------
% 程刚，20150616，初版本

%% 预处理



%% 未上市
assets = tsMat.xProps;
dtsStr = tsMat.yProps;
dtsNum = datenum(dtsStr);
listedDt = DH_D_OTH_ListedDay(assets);
listedDtnum = datenum(listedDt);

% 可持仓
h_listed = zeros(size(tsMat.data));
for ix = 1:length(assets)
    h_listed(:,ix) = dtsNum >= listedDtnum(ix);
end



%% 简单规则：上市后20d不能持仓

% 可持仓
h_simple = zeros(size(tsMat.data));
for ix = 1:length(assets)
    h_simple(:,ix) = dtsNum >= listedDtnum(ix) + 20;
end





%% 细致检查：上市后未打开, 只检查上市后30交易日内有否打开
% % 粗查：close == open 即认为未打开
% hiMat   = th.dhPriceMat( tsMat, 'High', 2);
% preCMat = th.dhPriceMat( tsMat, 'PreClose', 2);
% loMat   = th.dhPriceMat( tsMat, 'Low', 2);
% hi      = hiMat.data;
% preC    = preCMat.data;
% lo      = loMat.data;
% clMat   = th.dhPriceMat( tsMat, 'Close', 2);
% cl      = clMat.data;
% 
% yiziZhangting = ( hi == lo ) & (hi == cl) & (cl > preC*1.09) ;
% 
% % 逐支股票循环
% for ix = 1:length(assets)
%     shangshi = h_listed(:,ix);  % 1 为可交易， 0 为未上市
%     
%     % 已经上市的，不管了，直接跳出循环
%     if shangshi(1) == shangshi(end) % 始终的上市状态无变化
%         if max(shangshi) == min(shangshi)  % 过程的上市状态无变化
%             continue;
%         end
%     end
%     
%     
%     % 中间经历了上市
% %     才上市，并且未打开
%     % 找到上市日
%     sh = shangshi(1:end-1)==0 & shangshi(2:end)==1;
%     sh = [0;sh];
%     % 上市日之后，连续涨停，未打开，全部不可持仓
%     yzzt = yiziZhangting(:,ix);  % 1 - 一字涨停
%     weidakai = zeros(size(yzzt));
%     
%     
%     h_listed(:,ix) = dtsNum > listedDtnum(ix);
%     
%     
%     
% end









%% 已退市

% DH_D_OTH_DelistedDay('')



%% 最后结果
holdableMat = tsMat.getCopy;
holdableMat.des = '可持仓';
holdableMat.des2 = '0/1';
holdableMat.datatype = '0/1';
holdableMat.data = h_simple;


end

