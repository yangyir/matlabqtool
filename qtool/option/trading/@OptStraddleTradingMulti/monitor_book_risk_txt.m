function monitor_book_risk_txt( obj, S_low, S_high )
% multi book的总体监控与txt输出
% monitor_book_risk_txt( obj, S_low, S_high )
% TODO: 加入printtype

nCount = obj.optstraddletrading_multi.Count;
if nCount == 0
    return;
end
if ~exist('S_low', 'var')
    S_low = 2.15;
end
if ~exist('S_high', 'var')
    S_high = 2.5;
end


%% 1,分别打印各自的Book

keys_value = obj.keys;
%{
for straddle_t = 1:nCount
    fprintf('------------------------------%s------------------------------\n', keys_value{straddle_t})
    optstratrade_object = get(obj, keys_value{straddle_t});
    optstratrade_object.monitor_book_risk_txt(S_low, S_high);
    optstratrade_object.book.calc_m2m_pnl_etc;
    optstratrade_object.book.positions
    fprintf('------------------------------------------------------------------\n')
    fprintf('------------------------------------------------------------------\n')
end
%}

%% 2,合并book的打印
optstratrade_object            = get(obj, keys_value{1});
new_optStraddleTrading         = eval(class(optstratrade_object));
new_optStraddleTrading.book    = obj.merge_books;
new_optStraddleTrading.quote   = optstratrade_object.quote;
new_optStraddleTrading.volsurf = optstratrade_object.volsurf;
new_optStraddleTrading.quoteS  = optstratrade_object.quoteS;
fprintf('---------------------------总体仓位风险监控--------------------------\n')
new_optStraddleTrading.monitor_book_risk_txt(S_low, S_high);



%% 3,Delta展示
%{
for straddle_t = 1:nCount
    straddle_name = keys_value{straddle_t};
    optstratrade_object = get(obj, straddle_name);
    total_delta   = optstratrade_object.calc_position_delta;
    fprintf('%s 仓位总Delta为 %.4f\n', straddle_name, total_delta)
end
total_delta = new_optStraddleTrading.calc_position_delta;
fprintf('总仓位 Delta为 %.4f\n', total_delta);
%}








end