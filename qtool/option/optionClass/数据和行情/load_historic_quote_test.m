

% �������������Ĭ�Ϸ������������
hist_test = HistoricOptQuoteStore;
hist_test.optCode = '11111111';
hist_test.optName = '������Ȩ';
t_q = QuoteOpt;
t_q.code = '11111111';
t_q.optName = '������Ȩ';
t_q.impvol = 0.3;
hist_test.push(t_q);

t_q2 = QuoteOpt;
t_q2.code = '11111111';
t_q2.optName = '������Ȩ';
t_q2.impvol = 0.4;
hist_test.push(t_q2);

out_put_file = 'rick_test.xlsx';
hist_test.toExcel(out_put_file);


test_load = HistoricOptQuoteStore;
test_load.optCode = '11111111';
test_load.optName = '������Ȩ';
test_load.loadExcel(out_put_file);

% ������ʷ�������ݣ����ļ����ҵ������뵥������Ԫ��

%% ����HistoricQuoteM2TK
hq_m2tk = HistoricQuoteM2TK('call');
hq_m2tk.init_by_quote_mat(qms_.callQuotes_);
hq_m2tk.load_from_file;