function [ newPosPCTmat, log ] = reviseHoldingPCTmat(  posPCTmat, holdableMat )
% 修正持仓矩阵：不可持仓的股票持仓量为0，其他票rebalance。只能对pctmat进行调整，否则无法保证没有出入金
% [ newPosPCTmat, log ] = reviseHoldingPCTmat(  posPCTmat, holdableMat )
%   posPCTmat：  持仓占比矩阵，TsMatrix类
%   holdableMat：可持仓矩阵，TsMatrix类，或者直接简单矩阵，默认取IPO后涨停打开
% -------------------------
% 程刚，20150622，从原有版本改来 [ newPosPCTmat, log ] = revisePosPCTmatBeforeIPO( posPCTmat )



%% 预处理
if ~isa(posPCTmat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的posPCTmat');
end


% 默认的holdable是用新股来鉴定——上市后20天后，都holdable
if ~exist('holdableMat', 'var')
    holdableMat = th.dhXinguHoldable(  posPCTmat );
end


% hMat为简单矩阵，主程序计算用
if isa(holdableMat, 'TsMatrix')
    hMat = holdableMat.data;
elseif isa(holdableMat, 'double')
    if size(holdableMat) == size(posPCTmat.data)
        hMat = holdableMat;
    else
        error('holdableMat类型应为TsMatrix');
    end
end

%
log = '';


%% main
d2 = posPCTmat.data;
d3 = d2;

% 逐日修正持仓矩阵
for i = 1:size(d2,1)
    % 取出当日持仓（原），和当日股票上市情况
    pct1        = d2(i,:);
    holdable    = hMat(i,:);
    
    % 不可持仓的，持仓PCT置零，重调占比
    ttl     = sum( pct1(holdable==1) );
    pct2    = pct1 / ttl;
    pct2    = pct2 .* holdable;
    
    d3(i,:) = pct2;
    
    % 计入log
    dtStr = posPCTmat.yProps{i};
    log = sprintf('%s%s: 可持仓%d/总%d\n', log, ...
            dtStr, sum(holdable), length(holdable));
    
    
    % 计入修正了的个股
    for j = 1:length(pct1)
        if abs( pct1(j) - pct2(j) ) > 1e-8
            log = sprintf('%s  新股修正%s：原仓%0.1f%%，现仓%0.1f%%\n', log, ...
                posPCTmat.xProps{j}, pct1(j)*100, pct2(j)*100);
        end
    end
end

newPosPCTmat       = posPCTmat.getCopy;
newPosPCTmat.data  = d3;
end

