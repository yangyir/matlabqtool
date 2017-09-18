function [ quote, m2tkCallQuote, m2tkPutQuote ] = init_from_sse_excel( OptInfoXls )
%INIT_FROM_SSE_EXCEL 从上交所的期权列表中初始化所有的quoteOpt，建立一系列，如quoteOpt10000283
% 输入是读取的文件名OptInfoXls（这个文件从上级所网站下载，每日要更新）
% 输出quote是一系列quoteOpt
% 输出m2tkCallinfo, m2tkPutinfo是M2TK，存放指向quote中quoteOpt的指针
% 原来写成单独的script，现在放入static方法
% -------------------------------------------
% 程刚，20160121
% 吴云峰，20160122，将读取文件改为输入名称OptInfoXls
% 程刚，20160211,输出扩展成QuoteOpt<OptInfo类 的方法
% 程刚，20160212，yProps强制为cell（datestr）类型 （之前是 [ datenum ] )
% 吴云峰 20170524 增加Multiplier和兼容商品期权

%% ----------------------------------------------------

if ~exist('OptInfoXls' , 'var')
    OptInfoXls = 'OptInfo.xlsx';
end

%% 读取excel文件OptInfo.xlsx(OptInfoXls默认是OptInfo.xlsx)

[~, ~, optinfo] = xlsread( OptInfoXls ,'Sheet1');
optinfo( cellfun(  @(x)(~isempty(x) && isnumeric(x) && isnan(x)) , optinfo ) ) = {''};

%% 创建M2TK

% 构建call和put的数据
m2tkCallQuote = M2TK( 'call' );
m2tkPutQuote = M2TK( 'put' );

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
[sorted, idx] = sort(datenum(uniqueT_call));
uniqueT_call = uniqueT_call(idx);
m2tkCallQuote.xProps = uniqueK_call';
m2tkCallQuote.yProps = uniqueT_call;
nK = length( uniqueK_call );
nT = length( uniqueT_call );
data( nT, nK  ) = QuoteOpt;
m2tkCallQuote.data = data; % 将数据进行赋予

% 看跌期权的K和T的属性数据
uniqueK_put = unique( cell2mat( putOptInfo( :,5 ) ) );
uniqueT_put = unique(  putOptInfo( :,6 ) );
[sorted, idx] = sort(datenum(uniqueT_put));
uniqueT_put = uniqueT_put(idx);
m2tkPutQuote.xProps = uniqueK_put';
m2tkPutQuote.yProps = uniqueT_put;
nK = length( uniqueK_put );
nT = length( uniqueT_put );
data( nT, nK ) = QuoteOpt;
m2tkPutQuote.data = data; % 将数据进行赋予

%% 填充QuoteOpt和M2TK
colnum = size(optinfo, 2);
for line = 2 : size(optinfo,1)
    
    % 读一行
    if colnum == 6
        [code,optName,CP,underCode,K,T] = optinfo{line,:};
    else
        [code,optName,CP,underCode,K,T,multiplier] = optinfo{line,:};
        if ischar(multiplier)
            multiplier = str2double(multiplier);
        end
    end
    
    % 生成，填充
    code = regexp(code, '\.', 'split');
    code = code{1};
    tmp  = QuoteOpt;
    tmp.fillOptInfo( code, optName,underCode, T, K, CP );
    tmp.currentDate = today;
    tmp.calcTau;
    
    % 添加multiplier
    if colnum == 6
    else
        tmp.multiplier = multiplier;
    end
    
    % 生成optinfo
    varname = ['quoteopt',num2str(code)];
    varname(ismember(varname, '-')) = '_';
    quote.(varname) = tmp;
    
    % TODO： 把tmp 放入相应的m2tk中
    switch tmp.CP
        case 'call'
            posT = find( strcmp( T , m2tkCallQuote.yProps ) ); % T的位置
            posK = find( abs(  K - m2tkCallQuote.xProps ) < 1e-8 ); % K的位置
            % 需要两者非空
            if ~isempty( posT ) && ~isempty( posK )
                % 注意： data(indexT , indexK) ，先纵轴（行坐标），再横轴（列坐标）
                m2tkCallQuote.data( posT(1), posK(1)  ) = tmp;
                tmp.iT = posT(1);
                tmp.iK = posK(1);
            end
        case 'put'
            posT = find( strcmp( T, m2tkPutQuote.yProps) ); % T的位置
            posK = find( abs(  K - m2tkPutQuote.xProps ) < 1e-8 ); % K的位置
            if ~isempty( posT ) && ~isempty( posK )
                % 注意： data(indexT , indexK) ，先纵轴（行坐标），再横轴（列坐标）
                m2tkPutQuote.data(  posT(1), posK(1)  ) = tmp;
                tmp.iT = posT(1);
                tmp.iK = posK(1);                
            end
    end
    
end

end

