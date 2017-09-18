function [ tradableMat ] = dhTradableMat( tsMat )
% 从DH获取停牌信息矩阵，停牌为0，可交易为1，TsMatrix类
% ------------
% 程刚，20150521，初版本



%% 预处理
% 判断类型
if ~isa(tsMat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的posMat');
end

% 打开DH


%% 检查停牌股票
dtsCell = tsMat.yProps;
assetsCell = tsMat.xProps;



% 可交易1， 停牌0
tM = DH_D_TR_IsTradingDay(assetsCell, dtsCell);
tM = tM';
tM = double(tM);

% 计入TsMatrix
tradableMat = tsMat.getCopy;
tradableMat.des = '可交易';
tradableMat.des2 = '0/1';
tradableMat.datatype = '0/1';
tradableMat.data = tM;


end

