%% ��counter�� qms_, book, �ȵȵ����ɶ��ŵ�����ȥ��һ��ֻ����һ��
% Ϊ�˱����F5��ÿ������һ�κ�ע�͵�

% demo3S_init_CTP

%% ���ɲ���ʵ������strat����counter�� book�� quote, volsurf
stra = OptStraddleTradingCTP;

% ��
stra.counter    = c_opt;
stra.book       = b1;
% stra.book       = b_2016;

% ��
stra.quote          = qms_.optquotes_;
stra.m2tkCallQuote  = qms_.callQuotes_;
stra.m2tkPutQuote   = qms_.putQuotes_;
stra.volsurf        = qms_.impvol_surface_;
% ��
stra.quoteS     = qms_.stkmap_.getQuote('510300');

% ��EOD handler
qms_.eod_handler = @stra.end_day;

%% 

stra2 = OptStraddleTradingCTP;

% ��
stra2.counter    = c_opt2;
stra2.book       = b2;
book = b1;
% stra.book       = b_2016;

% ��
stra2.quote          = qms_.optquotes_;
stra2.m2tkCallQuote  = qms_.callQuotes_;
stra2.m2tkPutQuote   = qms_.putQuotes_;
stra2.volsurf        = qms_.impvol_surface_;
% ��
stra2.quoteS     = qms_.stkmap_.getQuote('510300');

% ��EOD handler
qms_.eod_handler = @stra2.end_day;


% % ��OptionOne
% stra.m2tkCallOne = qms_.m2cOptOne;
% stra.m2tkPutOne  = qms_.m2pOptOne;



% % ��OptionOne
% [c_ones, p_ones] = OptionOneM2TK.GetInstance();
% c_ones.attach_to_qms(qms_);
% p_ones.attach_to_qms(qms_);
% stra.m2tkCallOne = c_ones;
% stra.m2tkPutOne  = p_ones;
% 
% % ��counter
% stra.set_counters;


%% ����OptionOneM2TK ��Excel, ��excel��ȡOptionOneM2TK

% call_optone_output_fn = 'D:\intern\5.���Ʒ�\optionStraddleTrading\market_making_call_ones.xlsx';
% put_optone_output_fn = 'D:\intern\5.���Ʒ�\optionStraddleTrading\market_making_put_ones.xlsx';
% 
% 
% 
% [c_ones2, p_ones2] = OptionOneM2TK.GetInstance();
% c_ones2.load_from_excel(call_optone_output_fn);
% p_ones2.load_from_excel(put_optone_output_fn);



% ��OptionOne( ��Ҫ�ٽ��в��� )
% stramm.m2tkCallOne = qms_.m2cOptOne;
% stramm.m2tkPutOne  = qms_.m2pOptOne;

% ��counter
% stra.set_counters;


%% �鿴
% vs.update_VolSurface;
% vs.plot

stra.set_call(1, 3.2);
stra.set_put(1, 3.2);
stra.monitor_strangle_delta0_S0;
stra.monitor_iv_vega_theta('both');



stra.set_call(1, 2.25);
stra.set_put(1, 1.85);
stra.monitor_strangle_delta0_S0;
stra.monitor_iv_vega_theta('both');




stra.set_call(1, 2.2);
stra.set_put(1, 1.90);
stra.monitor_strangle_delta0_S0;
stra.monitor_iv_vega_theta('both');



stra.set_call(1, 2.25);
stra.set_put(1, 1.90);
stra.monitor_strangle_delta0_S0;
stra.monitor_iv_vega_theta('both');


stra.set_call(1, 2.2);
stra.set_put(1, 1.95);
stra.monitor_strangle_delta0_S0;
stra.monitor_iv_vega_theta('both');


stra.set_call(2, 2.15);
stra.set_put(2, 2.0);
stra.monitor_strangle_delta0_S0;
stra.monitor_iv_vega_theta('both');

stra.set_call(1, 2.15);
stra.set_put(1, 2.00);
stra.monitor_strangle_delta0_S0;
stra.monitor_iv_vega_theta('both');




stra.set_call(1, 2.20);
stra.set_put(1, 2.05);
stra.monitor_strangle_delta0_S0;
stra.monitor_iv_vega_theta('both');


stra.set_call(1, 2.15);
stra.set_put(1, 2.15);
stra.monitor_strangle_delta0_S0;
stra.monitor_iv_vega_theta('both');


%% ���ڲ����
stra.set_call(1, 2.10);
stra.set_put(1, 2.05);
stra.monitor_strangle_delta0_S0;
stra.monitor_iv_vega_theta('both');

%% ���ڲ�һ��
stra.set_call(2, 2.10);
stra.set_put(2, 2.05);
stra.monitor_strangle_delta0_S0;
stra.monitor_iv_vega_theta('both');

%%
stra.monitor_strangle_delta0_S0;
stra.monitor_iv_vega_theta('both');

% stra.plot_theoritical_analysis;

%% �������� - �Լ�
stra.sell_once(1, '1' );
stra.sell_once(2, '1' );
stra.sell_once(4, '1' );
stra.sell_once(7, '1' );
%% ��ƽ
% stra.sell_once(4, '2' );
% 
% stra.sell_once(7, '2' );
%% ��ƽ���� - �Լ�
% stra.buy_once(1, '2' ); 
stra.buy_once(3, '2' ); 
stra.buy_once(5, '2' ); 
stra.buy_once(7, '2' );

%% �򿪽��� - �Լ�
stra.buy_once(2, '1' ); 

stra.buy_once(4, '1' ); 
stra.buy_once(7, '1' );




%% �ҵ�����
stra.sell_once(1, '1', 0.8);
% stra.monitor_positions;
stra.sell_once(3, '1', 0.7);
% stra.buy_once(3, '2',0.7)
stra.sell_once(7, '1', 0.7 );


%%
QMS.set_quoteopt_ptr_in_position_array(b2.positions, qms_.optquotes_)

% ɨ�账�� pendingEntrusts
book.pendingEntrusts.print;
stra.query_book_pendingEntrusts
book.query_pendingEntrusts(c_opt);
book.pendingEntrusts.print;
% book.finishedEntrusts.print;

book.positions.print;
 
% �۲�PNL��
pa = book.positions;
pa.node(2)
pa.node(3)
pa.node(6)
pa.node(7)
pa.node(8)
pa.node(9)
pa.node(10)
pa.node(11)
pa.node(12)
pa.node(17)

%% �۲�ֲ�
book.plot_position_bars;
stra.monitor_book_risk;
book.calc_m2m_pnl_etc; book.positions

stra1.book.toExcel()

%% ȫ��
% stra1.cancel_book_pendingEntrusts;
book.cancel_pendingOptEntrusts(c_opt);

%% ������ĳί��
c_opt.optEntrustCancel(659192)


%% �۲쵥����Ȩ��Risk
stra.call.print_risk;
stra.put.print_risk;

stra.opt.print_risk;

%% ����ATM
stra.set_opt(1, 3.5, 'call');
stra.opt.fillQuoteCTP;stra.opt.print_risk;

stra.set_opt(1, 3.4, 'put');
stra.opt.fillQuoteCTP;stra.opt.print_risk;

%% ����

% direct��1��Ϊ��, '2' Ϊ��
% offset '1' Ϊ���� '2' Ϊƽ
e = stra.place_entrust_opt( '2', 1, '1', 0.2085);
e = stra.place_entrust_opt( '2', 1, '1');

%% ��ƽ
e = stra.place_entrust_opt( '1', 2, '2', 0.0013);

e = stra.place_entrust_opt( '1', 2, '2');


%% ��
e = stra.place_entrust_opt( '1', 10, '1', 0.1059);

%% ��ƽ
e = stra.place_entrust_opt( '2', 2, '2');
e = stra.place_entrust_opt( '2', 5, '2');
e = stra.place_entrust_opt( '2', 8, '2');
e = stra.place_entrust_opt( '2', 10, '2');

% c2.optEntrustCancel(560055)
% b2.pendingEntrusts.removeByIndex(1)
% enew = book.pendingEntrusts.node(1).getCopy
% enew.entrustNo = []

%% ȫ��
% b2.cancel_pendingOptEntrusts(c2);

%% ������ĩ�ҵ�
    b2.eod_virtual_cancel_all_pendingEntrusts(c2);    

% b2.virtual_settlement(2.074)
%% ��OptionOne�����µ�


%% �����Ҫ�����µ�

opt = stra.set_opt(1, 2.05, 'call');
opt.fillQuoteCTP;
mid = (opt.askP1 + opt.bidP1) *0.5
e = stra.place_entrust_opt( '1', 1, '2', mid);

% ��ƽ2.05put����
% 28
opt = stra.set_opt(1, 2.05, 'put');
opt.fillQuoteCTP;
mid = (opt.askP1 + opt.bidP1) /2
% e = stra.place_entrust_opt( '1', 7, '2', opt.askP1 - 0.0001);
e = stra.place_entrust_opt( '1', 7, '2', mid);






%% �Լ�����
opt = stra.set_opt(3, 2.2, 'call');
opt.fillQuoteCTP;
e = stra.place_entrust_opt( '1', 5, '1', opt.askP1);


opt = stra.set_opt(3, 2.2, 'put');
opt.fillQuoteCTP;
e = stra.place_entrust_opt( '2', 5, '1', opt.bidP1);
% c2.optEntrustCancel(283409)



%% Section 2 Title
% Description of second code block
stra.end_day();
mktlogout;




%% plot theta surface
cq = stra.m2tkCallQuote ;
Ks = cq.xProps;
L = length(Ks);

tic
for xx = 1:L
    for yy = 1:4
        cthetas(yy,xx) = cq.data(yy,xx).theta * 10000 / 365;
    end
end
toc

pq = stra.m2tkPutQuote ;
tic
for xx = 1:L
    for yy = 1:4
        pthetas(yy,xx) = pq.data(yy,xx).theta * 10000 / 365;
    end
end
toc


figure(110);
subplot(2,1,1)
plot(Ks, cthetas(:, : ), '*-')
grid on
legend(cq.yProps)
title('call 1��thetaͼ')
subplot(2,1,2)
plot(Ks, pthetas(:, : ), '*-')
grid on
legend(pq.yProps)
title('put 1��thetaͼ')


%% plot vega surface
cq = stra.m2tkCallQuote ;
Ks = cq.xProps;
L = length(Ks);

tic
for xx = 1:L
    for yy = 1:4
        cvegas(yy,xx) = cq.data(yy,xx).vega * 10000 / 365;
    end
end

pq = stra.m2tkPutQuote ;
for xx = 1:L
    for yy = 1:4
        pvegas(yy,xx) = pq.data(yy,xx).vega * 10000 / 365;
    end
end
toc


figure(111);
subplot(2,1,1)
plot(Ks, cvegas(:, : ), '*-')
grid on
legend(cq.yProps)
title('call 1%vega ͼ')
subplot(2,1,2)
plot(Ks, pvegas(:, : ), '*-')
grid on
legend(pq.yProps)
title('put 1%vega ͼ')


%% plot timeValue surface

cq = stra.m2tkCallQuote ;
pq = stra.m2tkPutQuote ;

Ks = cq.xProps;
L = length(Ks);

tic
ctm = zeros(4,L);
ptm = zeros(4,L);
cdelta = zeros(4,L);
pdelta = zeros(4,L);
for xx = 1:L
    for yy = 1:4
        try
        cq.data(yy,xx).calcIntrinsicValue;
        pq.data(yy,xx).calcIntrinsicValue;
     
        ctm(yy,xx) = cq.data(yy,xx).timeValue ;
        ptm(yy,xx) = pq.data(yy,xx).timeValue ;
        catch
        end
        
        try
            cdelta(yy,xx) = cq.data(yy,xx).askdelta ;
            pdelta(yy,xx) = pq.data(yy,xx).askdelta ;
        catch
        end
    end
end
toc


figure(111);
subplot(2,1,1)
plot(Ks, ctm(:, : ), '*-')
grid on
legend(cq.yProps)
title(['call timeValue ͼ : ' datestr(now)]);
subplot(2,1,2)
plot(Ks, ptm(:, : ), '*-')
grid on
legend(pq.yProps)
title(['put timeValue ͼ : ' datestr(now)]);



figure(112);
subplot(2,1,1)
plot(Ks, cdelta(:, : ), '*-')
grid on
legend(cq.yProps)
title(['call delta ͼ : ' datestr(now)]);
subplot(2,1,2)
plot(Ks, pdelta(:, : ), '*-')
grid on
legend(pq.yProps)
title(['put delta ͼ : ' datestr(now)]);


%% imp vol surfaceͼ

cq = stra.m2tkCallQuote ;
pq = stra.m2tkPutQuote ;

Ks = cq.xProps;
L = length(Ks);
tic
civ = zeros(4,L);
piv = zeros(4,L);
for xx = 1:L
    for yy = 1:4
        try
            civ(yy,xx) = cq.data(yy,xx).askimpvol ;
            piv(yy,xx) = pq.data(yy,xx).askimpvol ;
        catch
        end
    end
end
toc



figure(116);
subplot(2,1,1)
plot(Ks, civ(:, : ), '*-')
grid on
legend(cq.yProps)
title(['call ask IV ͼ : ' datestr(now)]);
subplot(2,1,2)
plot(Ks, piv(:, : ), '*-')
grid on
legend(pq.yProps)
title(['put ask IV ͼ : ' datestr(now)]);


%% ���Ӻϳ�S

cq = stra.m2tkCallQuote ;
pq = stra.m2tkPutQuote ;

Ks = cq.xProps;

% ����������
% taus = (datenum( cq.yProps ) - today +1) /365;
r = 0.035;
df = exp( - r* qms_.tauPrecise );

L = length(Ks);
tic
oask = zeros(4,L);
obid = zeros(4,L);
for xx = 1:L
    for yy = 1:4
        try
            oask(yy,xx) = cq.data(yy,xx).askP1 - pq.data(yy,xx).bidP1 + Ks(xx) ;
            obid(yy,xx) = cq.data(yy,xx).bidP1 - pq.data(yy,xx).askP1 + Ks(xx);
        catch
        end
    end
end
toc





figure(119); hold off
% subplot(2,1,1)
plot(Ks, oask(:, : ), '*-')
grid on
legend(cq.yProps)
title(['O:=C-P+K, ask bid ͼ : ' datestr(now)]);
hold on
plot(Ks, obid(:, : ), '*-')
legend(pq.yProps)


%% set QuoteOpt r

set_r  = 0.045;

cq = stra.m2tkCallQuote ;
pq = stra.m2tkPutQuote ;

Ks = cq.xProps;


L = length(Ks);
tic
oask = zeros(4,L);
obid = zeros(4,L);
for xx = 1:L
    for yy = 1:4
        try
            cq.data(yy, xx).r = set_r;
            cp.data(yy, xx).r = set_r;
        catch
        end
    end
end
toc 

vs.update_VolSurface

toc


