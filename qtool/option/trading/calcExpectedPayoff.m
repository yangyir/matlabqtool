
function [ ExpectedPayoff ] = calcExpectedPayoff( obj , ST )
%����������paypff
%����
% ����obj�����ǵ�����Ҳ�����Ƕ������
% ����������OptInfo|Ҳ������OptPricer|Ҳ������QuoteOpt
%���
% ExpectedPayoff��ÿһ����Ȩ������payoffֵ
% ���Ʒ壬20160219

% �����������ST�����õ�һ�����ST�������
if ~exist( 'ST' , 'var' ),  ST = obj( 1, 1 ).ST;  end;

% �ж����ݵ�����
isOpt   = isa( obj , 'OptInfo' ) || isa( obj , 'OptPricer' ) || isa( obj , 'QuoteOpt' );
isM2TK  = isa( obj , 'M2TK' );

% ������ǹ̶������������ֻ���nan�����ݽṹ
ExpectedPayoff = nan;

% �������Ȩ��Info����ͼ̳���
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

% �����M2TK������
% ��Ҫע�����M2TK�ڲ�ͬ��T��STӦ���ǲ�ͬ�ģ�����M2TK
if isM2TK
    data = obj.data;
    % �ж�data������
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

