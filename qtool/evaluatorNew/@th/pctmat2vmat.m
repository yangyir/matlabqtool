function [ vmat ] = pctmat2vmat( pctmat, initValue )
% 从占比矩阵算价值矩阵，比较烦，须逐日算
%  [ vmat ] = pctmat2vmat( pctmat, initValue )
% -------------
% 程刚，初版本，20150521

%% 预处理

% 默认初始价值1亿元
if ~exist('initValue', 'var')
    initValue = 100000000;
end


% 判断类型
if ~isa(pctmat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的pctmat');
end

% 判断数值类型
dtype = pctmat.datatype;
warning('vmat.datatype = %s，请确认为百分比小数', dtype);

% 找数据里有nan
if isnan( pctmat.data )
    warning(' vmat.data 中含有nan，可能会造成麻烦!');
end


%% main, 横向归一化即可
% 是否要处理nan问题？


% 计算价值
vmat            = pctmat.getCopy;
vmat.datatype   = '价值';
vmat.des2       = '持仓价值';
vmat.data       = zeros(size(vmat.data));
vmat.autoFill;

% 取价格变化
pmat = th.dhPriceMat(vmat, 'PCTChange',2);
% 把变化率nan的置为0
pmat.data( isnan( pmat.data ) ) = 0;

%
%% 逐日算vmat
ttlValue        = zeros( size(vmat.yProps) );

% 第1天
ttlValue(1)     = initValue;  % 当天240pm的价值
vmat.data(1,:)  = ttlValue(1) * pctmat.data(1,:);

% 第2天到最后一天
for idt = 2:vmat.Ny
    % 算当天交易前价值 == 交易后价值    
    ttlValue(idt)   =  nansum( vmat.data(idt-1, :) .* (1 + pmat.data(idt,:)) ) ;    
    
    % 当天日末的价值仓位
    vmat.data(idt,:) = ttlValue(idt) * pctmat.data(idt,:);
    
end

% plot(ttlValue)
