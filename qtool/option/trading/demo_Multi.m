

%% ��Counter ��book�Ĳ���

multi = OptStraddleTradingMulti;

% ����
set(multi , '2016' , stra)
set(multi , '2034' , stra2)

% ��ȡ
stra  = get(multi , '2016');
stra2 = get(multi , '2034');
keys(multi)


%% ��������

multi.set_opt(1, 2.3 , 'put');
multi.place_entrust_opt_equal('2', 1, '1', 0.0047)
multi.place_entrust_opt_proportion('2', 1, '1', 0.0047);

multi.set_call(1, 2.3);
multi.set_put(1, 2.3);
multi.buy_once_equal(1, '1')


multi.set_call(1, 2.5);
multi.set_put(1, 2.5);
multi.sell_once_equal(1, '1')

stra.set_opt(1, 2.3 , 'put');
stra.place_entrust_opt('2', 1, '1', 0.0045)

%% ��������
% ��ѯ
multi.query_all_pendingEntrusts;


% ����
multi.cancel_all_pendingEntrusts;

%% ����

multi.merge_books
multi.BookMulti.positions.print;
multi.monitor_book_risk_merge(2.2, 2.55)




