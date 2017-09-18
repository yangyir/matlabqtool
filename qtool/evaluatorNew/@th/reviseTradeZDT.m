function  [ newTradeQmat, log, log2] = reviseTradeZDT( tradeQmat, ztMat, dtMat, pMat)
% 修正交易数量矩阵：涨跌停不能买卖
% [newTradeQmat, log, log2] = reviseTradeZDT( tradeQmat, ztMat, dtMat, pMat)
%   tradeQmat：原本交易Qmat，TsMatrix类
%   ztMat：涨停状态矩阵，数值0/1,TsMatrix类，默认用DH取
%   dtMat：跌停状态矩阵，数值0/1,TsMatrix类，默认用DH取
%   pMat：价格矩阵，TsMatrix类，默认用DH取
%   newTradeQmat：修正结果
%   log：每一笔修正
%   log2：每一天的修正
% 广义地讲，ztMat和dtMat也可以作为禁买和禁卖矩阵来用，接纳其他原因造成的禁买和禁买（如黑名单）
% ----------------
% 程刚，20150524，初版本


%% 预处理
% 判断类型
if ~isa(tradeQmat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的tradeQmat');
end

% 默认涨跌停矩阵
if ~exist('ztMat', 'var') & ~exist('dtMat', 'var')
    [ztMat, dtMat] = th.dhZhangDieTingMat(tradeQmat,2);
    warning('使用默认，涨跌停类型：日末');
elseif ~exist('ztMat', 'var')
    [ztMat, ~] = th.dhZhangDieTingMat(tradeQmat,2);
elseif ~exist('dtMat', 'var')    
    [ ~, dtMat] = th.dhZhangDieTingMat(tradeQmat,2);
end

% 涨跌停矩阵类型判断
if ~isa(ztMat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的ztMat');
end

if ~isa(dtMat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的dtMat');
end

% 价格矩阵
if ~exist('pMat', 'var')
    pMat = th.dhPriceMat(tradeQmat);
elseif ~isa(pMat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的pMat');    
end


log = '';
log2 = '';


newTradeQmat        = tradeQmat.getCopy;
newTradeQmat.des    = [ newTradeQmat.des, '-清洗后'];

%% main
% 第1天区别对待



% 第2天到最后一天
for i = 2:size(tradeQmat.data,1)
    
    q = tradeQmat.data(i,:);        q(isnan(q) ) = 0;
    zt = ztMat.data(i,:);
    dt = dtMat.data(i,:);
    p = pMat.data(i,:);
    
     % 价值
     vBuy = q .* (q>0) .* (zt==0) .* p;
     vBuy( isnan(vBuy) ) = 0;
     
     vSell = q .* (q<0) .* (dt==0) .* p;
     vSell( isnan(vSell) ) = 0;
     
     
    % 欲买和欲卖
    ttlBuy  = sum(vBuy );
    ttlSell = -sum(vSell);
 
    % 重调 买额 = 卖额 = max(欲买，欲卖）
    newBuy = max(ttlBuy, ttlSell);
%     newBuy = (ttlBuy + ttlSell) * 0.5;
    newSell = newBuy;
    
    % 买的当中，重新归一化，按比例分配
    % 卖的当中，重新归一化，按比例分配
    % 不可交易的，置零
    newV = vBuy / ttlBuy * newBuy + vSell / ttlSell * newSell;
    newQ = newV ./ p;
    newQ( isnan(newQ) ) = 0;
    newTradeQmat.data(i,:) = newQ;

    
    
    %% log
    idx = find( (q>0  & zt==1 )  | ( q<0 & dt==1)   );
    for j = 1:length(idx)
        ii      = idx(j);
        dtStr   = tradeQmat.yProps{i};
        codeStr = tradeQmat.xProps{ii};
%         if t(ii) == 0,         typeStr = '停牌'; end
        if zt(ii) == 1,         typeStr = '涨停'; end
        if dt(ii) == 1,         typeStr = '跌停'; end
        
        log = sprintf( '%s%s, %s[%s]: 原交易%d，调整后交易%d\n', log,...
           dtStr, codeStr, typeStr, q(ii), newQ(ii));
    end
    
    log2 = sprintf( '%s%s: 原买%0.0f, 原卖%0.0f, 调整后买%0.0f，卖%0.0f\n', log2, ...
            tradeQmat.yProps{i}, ttlBuy, ttlSell, newBuy, newSell);
        
        
        
end
end

