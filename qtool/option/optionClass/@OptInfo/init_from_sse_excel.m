function [ oi, m2tkCallinfo, m2tkPutinfo ] = init_from_sse_excel( OptInfoXls )
%INIT_FROM_SSE_EXCEL 从上交所的期权列表中初始化所有的optinfo，建立一系列，如optinfo10000283
% 输入是读取的文件名OptInfoXls（这个文件从上级所网站下载，每日要更新）
% 输出oi是一系列optinfo
% 输出m2tkCallinfo, m2tkPutinfo是M2TK，存放指向oi中optinfo的指针
% 原来写成单独的script，现在放入static方法
% -------------------------------------------
% 程刚，20160121
% 吴云峰，20160122，将读取文件改为输入名称OptInfoXls
% 程刚，20160212，yProps强制为cell（datestr）类型 （之前是 [ datenum ] )
% 程刚，20161018，填入OptInfo.iT， OptInfo.iK， 反身索引用
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
m2tkCallinfo = M2TK( 'call' );
m2tkPutinfo = M2TK( 'put' );

% 找到call对应的行
callLines = strcmp( optinfo( :,3 ) , '认购' );
% 找到put对应的行
putLines = strcmp( optinfo( :,3 ) , '认沽' );

% 取到unique K ， unique T， 放入
callOptInfo = optinfo( callLines , : );
putOptInfo = optinfo( putLines , : );

% 看涨期权的K和T的属性数据
uniqueK_call = unique( cell2mat( callOptInfo( :,5 ) ) );
uniqueT_call = unique( callOptInfo( :,6 ) );
[sorted, idx] = sort(datenum(uniqueT_call));
uniqueT_call = uniqueT_call(idx);
m2tkCallinfo.xProps = uniqueK_call';
m2tkCallinfo.yProps = uniqueT_call;
nK = length( uniqueK_call );
nT = length( uniqueT_call );
data( nT, nK  ) = OptInfo;
m2tkCallinfo.data = data; % 将数据进行赋予

% 看跌期权的K和T的属性数据
uniqueK_put = unique( cell2mat( putOptInfo( :,5 ) ) );
uniqueT_put = unique( putOptInfo( :,6 ) );
[sorted, idx] = sort(datenum(uniqueT_put));
uniqueT_put = uniqueT_put(idx);
m2tkPutinfo.xProps = uniqueK_put';
m2tkPutinfo.yProps = uniqueT_put;
nK = length( uniqueK_put );
nT = length( uniqueT_put );
data( nT, nK ) = OptInfo;
m2tkPutinfo.data = data; % 将数据进行赋予

%% 填充OptInfo和M2TK
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
    tmp = OptInfo;
    tmp.fillOptInfo( code, optName,underCode, T, K, CP );
    tmp.currentDate = today;
    tmp.calcTau;
    
    % 添加multiplier
    if colnum == 6
    else
        tmp.multiplier = multiplier;
    end
    
    % 生成optinfo
    varname = ['optinfo',num2str(code)];
    varname(ismember(varname, '-')) = '_';
    oi.(varname) = tmp;
    
    % TODO： 把tmp 放入相应的m2tk中
    switch tmp.CP
        case 'call'
%             posT = find( T == m2tkCallinfo.yProps ); % T的位置
            posT = find( strcmp( T , m2tkCallinfo.yProps ) ); % T的位置
            posK = find( abs(  K - m2tkCallinfo.xProps ) < 1e-8 ); % K的位置
            % 需要两者非空
            if ~isempty( posT ) && ~isempty( posK )
                % 注意： data(indexT , indexK) ，先纵轴（行坐标），再横轴（列坐标）
                m2tkCallinfo.data( posT(1), posK(1)  ) = tmp;
            end
        case 'put'
%             posT = find( T == m2tkPutinfo.yProps ); % T的位置
            posT = find( strcmp( T , m2tkPutinfo.yProps ) ); % T的位置
            posK = find( abs(  K - m2tkPutinfo.xProps ) < 1e-8 ); % K的位置
            if ~isempty( posT ) && ~isempty( posK )
                % 注意： data(indexT , indexK) ，先纵轴（行坐标），再横轴（列坐标）
                m2tkPutinfo.data(  posT(1), posK(1)  ) = tmp;
            end
    end
    
end

%% 在每个OptInfo里填充上iT， iK， 反身引用用，因为所有的M2TK都是同样维度的
[TT, KK ] = size( m2tkCallinfo.data);
for iT = 1:TT
    for iK = 1:KK
        m2tkCallinfo.data(iT, iK).iT = iT;
        m2tkCallinfo.data(iT, iK).iK = iK;
        m2tkPutinfo.data(iT, iK).iT = iT;
        m2tkPutinfo.data(iT, iK).iK = iK;
    end
end


end

