function [port] = posQmat2nav( posQmat, pmat )
% 从持仓数量矩阵posQmat算净值nav，如不提供价格，则DH取close
% [port] = posQmat2nav( posQmat, pmat )
%   posQmat: 持仓数量矩阵，TsMatrix类
%   pmat：价格矩阵，TsMatrix类。默认DH取close
%   port：持仓市值放在里面，SingleAsset类
% --------------------
% 程刚，20150520，初版本


%% 预处理

% 判断类型
if ~isa(posQmat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的posMat');
end

% 默认pmat 
if ~exist('pmat', 'var')
    pmat = th.dhPriceMat(posQmat);
end

%% main
port        = SingleAsset;
port.des    = '投资组合';
port.des2   = '持仓市值';
port.yProps = posQmat.yProps;


holdingM2M = nansum(posQmat.data .* pmat.data,2);
port.insertCol( holdingM2M, '持仓市值')

end

