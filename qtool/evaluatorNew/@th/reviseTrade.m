function [ newTradeQmat, log, log2 ] = reviseTrade( tradeQmat, tradableMat, pMat)
% 修正交易矩阵：不交易（停牌）的股票交易量为0，其他票rebalance
% [ newTradeQmat, log, log2 ] = reviseTrade( tradeQmat, tradableMat, pMat)
%   tradeQmat：原交易数量矩阵，TsMatrix类
%   tradableMat：可交易状况矩阵，0/1数值，TsMatrix类，默认DH取停牌与否
%   pMat：价格矩阵，TsMatrix类，默认close
%   newTradeQmat：修正后交易数量矩阵，TsMatrix类
%   log：记录每一条修正
%   log2：记录每一天的修正
% ----------------
% 程刚，20150524，初版本


%% 预处理
% 判断类型
if ~isa(tradeQmat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的tradeQmat');
end


if ~exist('tradableMat', 'var')
    tradableMat = th.dhTradableMat( tradeQmat );
elseif ~isa(tradableMat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的tradableMat');
end


if ~exist('pMat', 'var')
    pMat = th.dhPriceMat(tradeQmat);
elseif ~isa(pMat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的pMat');    
end

log = '';
log2 = '';


newTradeQmat = tradeQmat.getCopy;
newTradeQmat.des = [ newTradeQmat.des, '-清洗后'];

%% main
% 资金分为3类：买、卖、冻

% q = tradeQmat.data;
% t = tradableMat.data;
% p = pMat.data;

% 第1天区别对待



% 第2天到最后一天
for i = 2:size(tradeQmat.data,1)
    
    q = tradeQmat.data(i,:);        q(isnan(q) ) = 0;
    t = tradableMat.data(i,:);
    p = pMat.data(i,:);
    
     % 价值
    v = q .* t .* p;
    v( isnan(v) ) = 0;
    
    % 欲买和欲卖
    ttlBuy  = sum(v .* (v>0) );
    ttlSell = -sum(v .* (v<0) );
 
    % 重调 买额 = 卖额 = max(欲买，欲卖）

    newBuy = max(ttlBuy, ttlSell);
%     newBuy = (ttlBuy + ttlSell) * 0.5;
    newSell = newBuy;
    
    % 买的当中，重新归一化，按比例分配
    % 卖的当中，重新归一化，按比例分配
    % 不可交易的，置零
    newV = v .* (v>0) / ttlBuy * newBuy + v.*(v<0) / ttlSell * newSell;
    newQ = newV ./ p;
    newQ( isnan(newQ) ) = 0;
    newTradeQmat.data(i,:) = newQ;

    
    
    % log
    idx = find( (q~=0) & ( t==0 | isnan(p) ) );
    for j = 1:length(idx)
        ii      = idx(j);
        dtStr   = tradeQmat.yProps{i};
        codeStr = tradeQmat.xProps{ii};
        if t(ii) == 0,         typeStr = '停牌'; end
        
        log = sprintf( '%s%s, %s: [%s] 原交易%d，调整后交易%d\n', log,...
           dtStr, codeStr, typeStr, q(ii), newQ(ii));
    end
    
    log2 = sprintf( '%s%s: 原买%0.0f, 原卖%0.0f, 调整后买%0.0f，卖%0.0f\n', log2, ...
            tradeQmat.yProps{i}, ttlBuy, ttlSell, newBuy, newSell);
        
        
        
end





end

