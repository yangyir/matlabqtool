function [ ztMat, dtMat ]      = dhZhangDieTingMat( tsMat, type)
%用DH计算个股的涨跌停状况
%[ ztMat, dtMat ]  = dhZhangDieTingMat( tsMat, type)
% type： 
%     1 - 一字涨停（几无机会买）
%     2 - 收盘涨停（日末几无机会买）
%     3 - 开盘涨停
%     4 - 盘中涨停，日末打开
% --------------------
% 程刚，20150525，初版本


%% 预处理
% 判断类型
if ~isa(tsMat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的tradeQmat');
end

if ~exist('type', 'var')
    type = 1;
end

%% 记录
ztMat = tsMat.getCopy;
ztMat.des = '涨停';
ztMat.datatype = '0/1';
ztMat.data   = zeros( size(ztMat.data) );

dtMat = ztMat.getCopy;
dtMat.des = '跌停';

%% 
hiMat   = th.dhPriceMat( tsMat, 'High', 2);
preCMat = th.dhPriceMat( tsMat, 'PreClose', 2);
loMat   = th.dhPriceMat( tsMat, 'Low', 2);
hi      = hiMat.data;
preC    = preCMat.data;
lo      = loMat.data;

switch type
    case{1, '1'}
        % 判断一字涨停： 高 = 低 〉 前收
        ztMat.data = ( hi==lo)  & ( hi>preC) ;
        ztMat.des2 = '一字';
        
        % 判断一字跌停： 高 = 低 < 前收
        dtMat.data = ( hi==lo)  & ( hi<preC) ;
        dtMat.des2 = '一字';
        
        
    case{2,'2'}
        clMat   = th.dhPriceMat( tsMat, 'Close', 2);
        cl      = clMat.data;
        
        % 判断日末涨停： 收 = 高 = 前收*1.1
        ztMat.data = (hi==cl)  & ( hi >= preC*1.1 - 0.01) ;
        ztMat.des2 = '日末';
        
        % 判断日末跌停： 收 = 低 = 前收*0.9
        dtMat.data = (cl==lo)  & ( lo <= preC*0.9 + 0.01) ;
        dtMat.des2 = '日末';
        
    case{3,'3'}
        opMat   = th.dhPriceMat( tsMat, 'Open', 2);
        op      = opMat.data;
        
        % 判断开盘涨停： 开 = 高 = 前收*1.1
        ztMat.data = (op==hi)  & ( hi >= preC*1.1 - 0.01) ;
        ztMat.des2 = '开盘';
        
        % 判断开盘跌停： 开 = 低 = 前收*0.9
        dtMat.data = (op==lo)  & ( lo <= preC*0.9 + 0.01) ;
        dtMat.des2 = '开盘';
        
    case{4, '4'}
        clMat   = th.dhPriceMat( tsMat, 'Close', 2);
        cl      = clMat.data;
        
        % 判断日中涨停： 收 < 高 = 前收*1.1
        ztMat.data =  (cl<hi) & ( hi >= preC*1.1 - 0.01) ;
        ztMat.des2 = '日中';
        
        
        % 判断日中跌停： 收 〉 低 = 前收*0.9
        dtMat.data = (cl>lo) & ( lo <= preC*0.9 + 0.01) ;
        dtMat.des2 = '日中';


        
        
end




end

