

% 测试行情输出的默认方法，看结果。
hist_test = HistoricOptQuoteStore;
hist_test.optCode = '11111111';
hist_test.optName = '测试期权';
t_q = QuoteOpt;
t_q.code = '11111111';
t_q.optName = '测试期权';
t_q.impvol = 0.3;
hist_test.push(t_q);

t_q2 = QuoteOpt;
t_q2.code = '11111111';
t_q2.optName = '测试期权';
t_q2.impvol = 0.4;
hist_test.push(t_q2);

out_put_file = 'rick_test.xlsx';
hist_test.toExcel(out_put_file);


test_load = HistoricOptQuoteStore;
test_load.optCode = '11111111';
test_load.optName = '测试期权';
test_load.loadExcel(out_put_file);

% 对于历史行情数据，从文件中找到并载入单个行情元。

%% 测试HistoricQuoteM2TK
hq_m2tk = HistoricQuoteM2TK('call');
hq_m2tk.init_by_quote_mat(qms_.callQuotes_);
hq_m2tk.load_from_file;