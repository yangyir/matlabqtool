function [ pricer , m2tkCallPricer, m2tkPutPricer ] = init_from_sse_excel( optInfoxlsx )
%INIT_FROM_SSE_EXCEL 从上交所的期权列表中初始化所有的optpricer，建立一系列，如optPricer10000283
% 输入是读取的文件名OptInfoXls（这个文件从上级所网站爬虫获取，每日要更新）
% 输出pricer是一系列OptPricer
% 输出m2tkCallinfo, m2tkPutinfo是M2TK，存放指向pricer中OptPricer的指针
%DEMO
% [ pricer , m2tkCallPricer, m2tkPutPricer ] = OptPricer.init_from_sse_excel;
% -------------------------------------------
% 程刚，20160121
% 吴云峰，20160122，将读取文件改为输入名称OptInfoXls
% 程刚，20160212，yProps强制为cell（datestr）类型 （之前是 [ datenum ] )
% 吴云峰，20160229，修改为获取Pricer的方法
% 吴云峰 20170524 增加Multiplier和兼容商品期权

%% ----------------------------------------------------

if ~exist('optInfoxlsx' , 'var')
    optInfoxlsx = 'OptInfo.xlsx';
end

%% 读取excel文件OptInfo.xlsx(OptInfoXls默认是OptInfo.xlsx)

[~, ~, optinfo] = xlsread( optInfoxlsx ,'Sheet1');
optinfo( cellfun(  @(x)(~isempty(x) && isnumeric(x) && isnan(x)) , optinfo ) ) = {''};

%% 创建M2TK

% 构建call和put的数据
m2tkCallPricer = M2TK( 'call' );
m2tkPutPricer  = M2TK( 'put' );

% 找到call对应的行
callLines = strcmp( optinfo( :,3 ) , '认购' );
% 找到put对应的行
putLines  = strcmp( optinfo( :,3 ) , '认沽' );

% 取到unique K ， unique T， 放入
callOptInfo = optinfo( callLines, : );
putOptInfo  = optinfo( putLines, : );

% 看涨期权的K和T的属性数据
uniqueK_call = unique( cell2mat( callOptInfo( :,5 ) ) );
uniqueT_call = unique( callOptInfo( :,6 )  );
[sorted, idx] = sort(datenum(uniqueT_call));
uniqueT_call = uniqueT_call(idx);
m2tkCallPricer.xProps = uniqueK_call';
m2tkCallPricer.yProps = uniqueT_call;
nK = length( uniqueK_call );
nT = length( uniqueT_call );
data( nT, nK  ) = OptPricer;
m2tkCallPricer.data = data; 

% 看跌期权的K和T的属性数据
uniqueK_put = unique( cell2mat( putOptInfo( :,5 ) ) );
uniqueT_put = unique(  putOptInfo( :,6 ) );
[sorted, idx] = sort(datenum(uniqueT_put));
uniqueT_put = uniqueT_put(idx);
m2tkPutPricer.xProps = uniqueK_put';
m2tkPutPricer.yProps = uniqueT_put;
nK = length( uniqueK_put );
nT = length( uniqueT_put );
data( nT, nK ) = OptPricer;
m2tkPutPricer.data = data; 

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
    tmp = OptPricer;
    tmp.fillOptInfo( code, optName,underCode, T, K, CP );
    tmp.currentDate = today;
    tmp.calcTau;
    
    % 添加multiplier
    if colnum == 6
    else
        tmp.multiplier = multiplier;
    end
    
    % 生成optinfo
    varname = ['optpricer',num2str(code)];
    varname(ismember(varname, '-')) = '_';
    pricer.(varname) = tmp;
    
    % TODO： 把tmp 放入相应的m2tk中
    switch tmp.CP
        case 'call'
            posT = find( strcmp( T , m2tkCallPricer.yProps ) ); % T的位置
            posK = find( abs(  K - m2tkCallPricer.xProps ) < 1e-8 ); % K的位置
            % 需要两者非空
            if ~isempty( posT ) && ~isempty( posK )
                m2tkCallPricer.data( posT(1), posK(1)  ) = tmp;
            end
        case 'put'
            posT = find( strcmp( T, m2tkPutPricer.yProps) ); % T的位置
            posK = find( abs(  K - m2tkPutPricer.xProps ) < 1e-8 ); % K的位置
            if ~isempty( posT ) && ~isempty( posK )
                m2tkPutPricer.data(  posT(1), posK(1)  ) = tmp;
            end
    end
    
end



end

