function [port] = posVmat2nav( posVmat )
% 从持仓价值矩阵posVmat算净值nav
% [port] = posVmat2nav( posVmat )
%     posVmat: 持仓价值矩阵，TsMatrix类
%     port：持仓市值放在里面，SingleAsset类
% --------------------
% 程刚，20150520，初版本


%% 预处理
% 判断类型
if ~isa(posVmat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的posMat');
end


%% main
port        = SingleAsset;
port.des    = '投资组合';
port.des2   = '持仓市值';
port.yProps = posVmat.yProps;

holdingM2M  = nansum(posVmat.data,2);
port.insertCol( holdingM2M, '持仓市值');

end

