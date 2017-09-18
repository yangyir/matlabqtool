% 假定已有b1, c_test，vs
%% 初始化测试柜台
javapath = 'C:\Users\Rick Zhu\Documents\Synology Cloud\共享工具\qtool\option\optionClass\实盘交易类\UFXdemo_MATLAB\ESBJavaAPI.jar';
c_test = CounterHSO32.hequn2038_2016_opttest;
c_test.login(javapath);

%% 初始化book hedger
bh = BookHedger(b1);
bh.dollarDelta = 20000;
bh.attachCounter(c_test);
bh.attachVolSurf(qms_.impvol_surface_);
bh.attachQuoteS(qms_.stkquotes_.quotestk510050);
call_quote = qms_.getOptQuoteByTK(1, 2.2, 'call');
call_quote2 = qms_.getOptQuoteByTK(1, 2.25, 'call');
bh.attachHedger(call_quote, 'buy', 'open');
bh.attachHedger(call_quote2, 'buy', 'open');

%% 测试
bh.check_and_prepare_hedge;

%% Init UI
h = hedge;
setappdata(h, 'BookHedger', bh);
setappdata(h, 'QMS', qms_);

%% 执行
hedge_done = false;
while ~hedge_done
    bh.place_hedge_entrusts;
    pause(1);
    bh.query_hedge_entrust;
    pause(1);
    hedge_done = bh.check_hedge_result;
end
