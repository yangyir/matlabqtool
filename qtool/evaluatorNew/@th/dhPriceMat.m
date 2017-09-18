function [pMat ] = dhPriceMat( tsMat, datatype, fuquan )
%用DH取股票行情，按照给定tsMat的格式（日期和代码），输出为TsMatrix类
%[pMat ] = dhPriceMat( tsMat, datatype, fuquan )
%   pMat：TsMatrix类型，输出值
%   tsMat: TsMatrix类型，有yProps（日期）和xProps（代码）
%   datatype：PreClose, Open, High, Low, Close,AvgPrice, Amount, Volume, Turn, Change, PCTChange
%   fuquan: 1-不复权，2-后复权（默认），3-前复权
% ------------
% 程刚，20150521，初版本

%% 预处理

% 判断类型
if ~isa( tsMat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的posMat');
end

if ~exist('datatype', 'var')
    datatype = 'Close';
end

if ~exist('fuquan', 'var')
    fuquan = 2;
end

validStr = {'PreClose', '0pen', 'High', 'Low', 'Close', ...
    'AvgPrice', 'Amount', 'Volume', 'Turn', 'Change', 'PCTChange'};
if ~strcmp(datatype, validStr)
    error('datatype=''%s''不正确。提示：首字母大写', datatype);
end

% 打开DH


%% 
pMat        = tsMat.getCopy;
pMat.des    = datatype;
pMat.des2   = sprintf('复权%d',fuquan);
pMat.datatype = '%0.2f';

assetsCell  = pMat.xProps;
dtsCell     = pMat.yProps;
tmpdata     = DH_Q_DQ_Stock(assetsCell, dtsCell, datatype, fuquan);
tmpdata     = tmpdata';
pMat.data   = tmpdata;


end

