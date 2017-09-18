function [ output_args ] = freezeUntradable( posQmat, tradableMat )
% 停牌股票持仓量冻结
% 最准确的冻结，是用数量冻结，
%     同时，考虑拆股等复权问题（全部用后复权数据，就可以解决这个忧虑）
% 比较糙的方法，是用市值冻结（不适用于涨跌停冻结）
% 不能用百分比冻结
% -------------
% 程刚，初版本，20150522

%% 前处理
% 判断类型
if ~isa(posQmat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的posMat');
end


if ~exist('tradableMat', 'var')
    tradableMat = th.dhTradableMat( tradeMat );
end



% 打开DH


%% 
% 先把已有矩阵转成Qmat


% 再冻结Qmat的相关仓位，计算V冻结仓位

% 再回去算Vmat，按比例重分配V可交易仓位

% 再回到Qmat或PCTmat




end

