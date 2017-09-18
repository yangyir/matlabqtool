function StockList = getStockList( StartDate,EndDate )
sql1 = ['select distinct a.SecuCode from SecuMain a join QT_DailyQuote b on a.InnerCode = b.InnerCode ',...
    'where a.SecuCategory = 1  and a.ListedDate<=''',StartDate,''' and a.ListedState = 1 and a.SecuMarket in (90) '...
    'and b.TradingDay >= ''',StartDate,'''and b.TradingDay <=''',EndDate,''' order by a.SecuCode'];

output1 = dsql_JYDB(sql1);
StockList1 = strcat(output1,'.SZ');

sql2 = ['select distinct a.SecuCode from SecuMain a join QT_DailyQuote b on a.InnerCode = b.InnerCode ',...
    'where a.SecuCategory = 1  and a.ListedDate<=''',StartDate,''' and a.ListedState = 1 and a.SecuMarket in (83) '...
    'and b.TradingDay >= ''',StartDate,'''and b.TradingDay <=''',EndDate,''' order by a.SecuCode'];
output2 = dsql_JYDB(sql2);
StockList2 = strcat(output2,'.SH');

StockList = [StockList1;StockList2];
end

