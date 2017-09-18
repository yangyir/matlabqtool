function [ quote, quote_map ] = init_from_excel( stockInfoXls )
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

%% ----------------------------------------------------

if ~exist('stockInfoXls' , 'var')
    stockInfoXls = 'StockInfo.xlsx';
end

%% 读取excel文件FutureInfo.xlsx(FutureInfoXls默认是FutureInfo.xlsx)

[~, ~, stockinfo] = xlsread( stockInfoXls ,'Sheet1');
stockinfo( cellfun(  @(x)(~isempty(x) && isnumeric(x) && isnan(x)) , stockinfo ) ) = {''};

%% 创建QuoteMap
quote_map = QuoteMap;

%% 填充QuoteFuture和QuoteMap
for line = 2 : size(stockinfo,1)
    % 读一行
    [code,stockName,market] = stockinfo{line,:};
    
    % 生成，填充
    tmp = QuoteStock;
    tmp.fillStockInfo( code, stockName, market);
    
    % 生成struct
    varname = ['quotestk', code];
    quote.(varname) = tmp;    
    quote_map.add(code, tmp);
end

end

