
function [ ExpectedPayoff ] = calcExpectedPayoff( obj , ST )
%计算期望的paypff
%输入
% 其中obj可以是单个类也可以是多个的类
% 这个类可以是OptInfo|也可以是OptPricer|也可以是QuoteOpt
%输出
% ExpectedPayoff是每一个期权的期望payoff值
% 吴云峰，20160219

% 如果不存在着ST，则用第一个类的ST进行替代
if ~exist( 'ST' , 'var' ),  ST = obj( 1, 1 ).ST;  end;

% 判断数据的类型
isOpt   = isa( obj , 'OptInfo' ) || isa( obj , 'OptPricer' ) || isa( obj , 'QuoteOpt' );
isM2TK  = isa( obj , 'M2TK' );

% 如果不是固定输出的类型则只输出nan的数据结构
ExpectedPayoff = nan;

% 如果是期权的Info的类和继承类
if isOpt
    [ L1 , L2 ] = size( obj );
    ExpectedPayoff = nan( L1 , L2 );
    for i = 1:L1
        for j = 1:L2
            obj( i  ,j ).ST = ST;
            obj( i  ,j ).calcPayoff;
            ExpectedPayoff( i , j ) = nanmean( obj( i  ,j ).payoff );
        end
    end
end

% 如果是M2TK的数据
% 需要注意的是M2TK在不同的T下ST应该是不同的，所以M2TK
if isM2TK
    data = obj.data;
    % 判断data的类型
    isDataOpt = isa( data , 'OptInfo' ) || isa( data , 'OptPricer' ) || isa( data , 'QuoteOpt' );
    if isDataOpt
        [ L1 , L2 ] = size( data );
        ExpectedPayoff = nan( L1 , L2 );
        for i = 1:L1
            for j = 1:L2
                data( i  ,j ).ST = ST;
                data( i  ,j ).calcPayoff;
                ExpectedPayoff( i , j ) = nanmean( obj( i  ,j ).payoff );
            end
        end
    end
end



end

