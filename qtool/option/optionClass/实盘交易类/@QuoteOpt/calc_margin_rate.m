
function [ m2tkCallMarginRate , m2tkPutMarginRate ] = calc_margin_rate( OptInfoXls , w )
%计算margin_rate即基于ask和bid来计算margin_rate
%吴云峰，20160217
% 输入
%OptInfoXls是输入的xlsx的名称
%w是windmatlab的接口的API
%DEMO
% w = windmatlab;
% [ CallMarginRate , PutMarginRate ] = QuoteOpt.calc_margin_rate( 'OptInfo.xlsx' , w );

if ~exist('OptInfoXls' , 'var')
    OptInfoXls = 'OptInfo.xlsx';
end

if ~isobject( w )
    return;
end

%% 读取excel文件OptInfo.xlsx(OptInfoXls默认是OptInfo.xlsx)

[~, ~, optinfo] = xlsread( OptInfoXls ,'Sheet1');
optinfo( cellfun(  @(x)(~isempty(x) && isnumeric(x) && isnan(x)) , optinfo ) ) = {''};

%% 创建M2TK

% 构建call和put的数据
m2tkCallQuote = M2TK( 'call' );
m2tkPutQuote  = M2TK( 'put' );

% 找到call对应的行
callLines = strcmp( optinfo( :,3 ) , '认购' );
% 找到put对应的行
putLines = strcmp( optinfo( :,3 ) , '认沽' );

% 取到unique K ， unique T， 放入
callOptInfo = optinfo( callLines, : );
putOptInfo  = optinfo( putLines, : );

% 看涨期权的K和T的属性数据
uniqueK_call = unique( cell2mat( callOptInfo( :,5 ) ) );
uniqueT_call = unique( callOptInfo( :,6 )  );
m2tkCallQuote.xProps = uniqueK_call';
m2tkCallQuote.yProps = uniqueT_call;
nK = length( uniqueK_call );
nT = length( uniqueT_call );
data( nT, nK  ) = QuoteOpt;
m2tkCallQuote.data = data; % 将数据进行赋予

% 看跌期权的K和T的属性数据
uniqueK_put = unique( cell2mat( putOptInfo( :,5 ) ) );
uniqueT_put = unique(  putOptInfo( :,6 ) );
m2tkPutQuote.xProps = uniqueK_put';
m2tkPutQuote.yProps = uniqueT_put;
nK = length( uniqueK_put );
nT = length( uniqueT_put );
data( nT, nK ) = QuoteOpt;
m2tkPutQuote.data = data; % 将数据进行赋予

m2tkCallSel = false( nT , nK );
m2tkPutSel  = false( nT , nK );

%% 填充QuoteOpt和M2TK

for line = 2 : size(optinfo,1)
    
    % 读一行
    [code,optName,CP,underCode,K,T] = optinfo{line,:};
    code = str2double(code(1:8));
    if isa(underCode, 'char')
        underCode = str2double(underCode);
    end
    
    % 生成，填充
    tmp = QuoteOpt; %OptInfo;
    tmp.fillOptInfo( code, optName, underCode, T, K, CP );
    tmp.currentDate = today;
    tmp.calcTau;
    
    % TODO： 把tmp 放入相应的m2tk中
    switch tmp.CP
        case 'call'
            posT = find( strcmp( T , m2tkCallQuote.yProps ) ); % T的位置
            posK = find( abs(  K - m2tkCallQuote.xProps ) < 1e-8 ); % K的位置
            % 需要两者非空
            if ~isempty( posT ) && ~isempty( posK )
                % 注意： data(indexT , indexK) ，先纵轴（行坐标），再横轴（列坐标）
                m2tkCallQuote.data( posT(1), posK(1)  ) = tmp;
                m2tkCallSel( posT(1), posK(1)  )        = true;
                % 针对行情进行填充
                m2tkCallQuote.data( posT(1), posK(1)  ).fillQuoteWind( w );
                % 针对已经获取的行情进行输出
                str_Call = m2tkCallQuote.data( posT(1), posK(1)  ).infoLongstr;
                str_Call = sprintf( '%s 行情已经获取完毕....' , str_Call );
                disp( str_Call )
            end
        case 'put'
            posT = find( strcmp( T, m2tkPutQuote.yProps) ); % T的位置
            posK = find( abs(  K - m2tkPutQuote.xProps ) < 1e-8 ); % K的位置
            if ~isempty( posT ) && ~isempty( posK )
                % 注意： data(indexT , indexK) ，先纵轴（行坐标），再横轴（列坐标）
                m2tkPutQuote.data(  posT(1), posK(1)  ) = tmp;
                m2tkPutSel( posT(1) , posK(1) )         = true;
                % 再针对行情进行填充
                m2tkPutQuote.data( posT(1) , posK(1) ).fillQuoteWind( w );
                % 针对已经获取的行情进行输出
                str_Put = m2tkPutQuote.data( posT(1) , posK(1) ).infoLongstr;
                str_Put = sprintf( '%s 行情已经获取完毕....' , str_Put );
                disp( str_Put )
            end
    end
    

end

%% 针对数据进行输出margin rate

CallMarginRate = nan( nT , nK );
PutMarginRate  = nan( nT , nK );

for i = 1:nT
    for j = 1:nK
        if m2tkCallSel( i , j )
            CallMarginRate( i , j ) = m2tkCallQuote.data( i , j ).calcMarginRate_bid;
        end
        if m2tkPutSel( i , j )
            PutMarginRate( i , j ) = m2tkPutQuote.data( i , j ).calcMarginRate_bid;
        end
    end
end

m2tkCallMarginRate = m2tkCallQuote.getCopy;
m2tkPutMarginRate  = m2tkPutQuote.getCopy;

m2tkCallMarginRate.data = CallMarginRate;
m2tkPutMarginRate.data  = PutMarginRate;

end

%% ---------------EOF-----------------
