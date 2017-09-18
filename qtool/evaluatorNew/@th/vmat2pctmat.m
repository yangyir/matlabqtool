function [ pctmat ] = Untitled( vmat )
% 从价值矩阵横向归一化成占比矩阵
% -------------
% 程刚，初版本，20150521

%% 预处理

% 判断类型
if ~isa(vmat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的vmat');
end

% 判断数值类型
dtype = vmat.datatype;
warning('vmat.datatype = %s，请确认为金额', dtype)

% 找数据里有nan
if isnan( vmat.data )
    warning(' vmat.data 中含有nan，可能会造成麻烦!');
end


%% main, 横向归一化即可
% 是否要处理nan问题？

% 横向加和，变成矩阵
total       = nansum( vmat.data, 2) ;
totalMat    = total * ones( size(vmat.xProps) );

% 计算百分比
pctmat          = vmat.getCopy;
pctmat.datatype = '百分比';
pctmat.des2     = '横向归一后占比';
pctmat.data     = vmat.data ./ totalMat;



end

