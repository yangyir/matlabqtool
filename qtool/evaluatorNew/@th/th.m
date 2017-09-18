classdef th
% Trading 和 Holding相关的函数工具包
% 包含几类函数：
%   1，取数据（调用DH，wind等）
%   2，TsMatrix之间的转换
%   3，正义性检查（保证backtest结果可信的关键）
%   4，统计结果NAV等
% 关于数据，从类型上，有tradeMat 和 posMat
% 从数据属性上， 有Qmat（数量），Vmat（价值），PCTmat（占比）
% 综合起来:（都是TsMatrix类）
% 
% tradeQmat <--> tradeVmat 
%     ^
%     |
%     v
% posQmat   <--> posVmat   <--> posPCTmat
% 
% -------------
% 程刚，20150521


properties
end


%% 用dh获取常用数据矩阵
methods (Access = 'public', Static = true, Hidden = false)
    [ pMat ]        = dhPriceMat( tsMat, datatype, fuquan );
    [ tradableM ]   = dhTradableMat( tsMat );
    [ztMat, dtMat]  = dhZhangDieTingMat( tsMat, type);
    [ holdableM ]   = dhXinguHoldable(  tsMat  );

end

%% trade矩阵,pos矩阵之间的互相转换
% qmat数量，pmat价格，vmat金额，pctmat占比
% TsMatrix.datatype里存放数据类型
methods (Access = 'public', Static = true, Hidden = false)    
    %% qmat，vmat，pctmat之间的转换
    [Vmat]      = qmat2vmat(qMat, pMat);
    [ qMat ]    = vmat2qmat( vmat, pMat);
    [pctmat]    = vmat2pctmat(vmat);
    
    % 这个函数不是这么简单，超级复杂，基本把回测的全过程走了一遍
    [ vmat ]    = pctmat2vmat(pctmat, initValue);
    


    %% trade和pos之间的转换
    [ posQmat ]     = tradeQmat2posQmat( tradeQmat );
    [ tradeQmat ]   = posQmat2tradeQmat( posQmat );
    
end

%% 统计交易结果portfolio
% posMat, tradeMat 都是TsMatrix类
% port是SingleAsset类，每一列是一个独立向量
methods (Access = 'public', Static = true, Hidden = false)
    % 计算nav
    [port] = posQmat2nav( posMat, pMat );
    [port] = posVmat2nav( posVMat );
    
    % 计算买量/额、卖量/额、净买、
    [port] = tradeVmat2volume( tradeVMat );    
    
    
    
end

%% trade和hold的正义性检查
methods (Access = 'public', Static = true, Hidden = false)
    % 把不可交易的交易置零
    [ tradeMat ] = setZeroUntradable( tradeMat, tradableMat );
    
    % Qmat数量矩阵，取整
    [  qmat    ] = setIntQmat( qmat, round_type);
    
    % 清洗tradeQmat
    [ newTradeQmat, log, log2]  = reviseTrade( tradeQmat, tradableMat, pMat) 
    
    % 清洗不可持仓的部分
    [ newPosPCTmat, log]    = reviseHoldingPCTmat( posPCTmat, holdableMat)
    % 未上市的，不可持仓，如果严格一点，上市后，也不可持仓，直至打开涨停
    [ newPosMat, log ]          = revisePosPCTmatBeforeIPO( posMat ); 
    
    
    % 清洗tradeQmat：使用涨跌停信息清洗
    [ newTradeQmat, log, log2]  = reviseTradeZDT( tradeQmat, ztMat, dtMat, pMat);
    

    
    % 把holdingMat中不可交易的个股持仓数量冻结住，其余的重新分配
    freezeUntradable( posMat, tradableMat);
    
    
    % 计算手续费，毛估估，直接用交易量*费率，没有复利
    [ port ] = feeMaogugu( tradeVmat, feeRatio );
    
end

        



   
    
end

