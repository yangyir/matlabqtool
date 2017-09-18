%% ��counter�� qms_, book, �ȵȵ����ɶ��ŵ�����ȥ��һ��ֻ����һ��
% Ϊ�˱����F5��ÿ������һ�κ�ע�͵�

% demo3S_init

%% ���ɲ���ʵ������strat����counter�� book�� quote, volsurf
stra = OptStraddleTrading;

% ��
stra.counter    = c2;
stra.book       = b2;
% stra.book       = b_2016;

% ��
stra.quote          = qms_.optquotes_;
stra.m2tkCallQuote  = qms_.callQuotes_;
stra.m2tkPutQuote   = qms_.putQuotes_;
stra.volsurf        = qms_.impvol_surface_;
% ��
stra.quoteS     = qms_.stkmap_.getQuote('510050');

% ��EOD handler
qms_.eod_handler = @stra.end_day;

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

call_optone_output_fn = 'D:\intern\5.���Ʒ�\optionStraddleTrading\market_making_call_ones.xlsx';
put_optone_output_fn = 'D:\intern\5.���Ʒ�\optionStraddleTrading\market_making_put_ones.xlsx';



[c_ones2, p_ones2] = OptionOneM2TK.GetInstance();
c_ones2.load_from_excel(call_optone_output_fn);
p_ones2.load_from_excel(put_optone_output_fn);



% ��OptionOne( ��Ҫ�ٽ��в��� )
% stramm.m2tkCallOne = qms_.m2cOptOne;
% stramm.m2tkPutOne  = qms_.m2pOptOne;

% ��counter
stra.set_counters;

%%
% h = OptionStraddingTradingGUI;
% set( h , 'UserData' , stra )

% qms_.isRunning
% start( qms_.regular_timer_ )





%% �鿴
% vs.update_VolSurface;
% vs.plot



%%
stra.set_call(4, 2.45);
stra.set_put(4, 2.2);
stra.monitor_strangle_delta0_S0;
stra.monitor_iv_vega_theta('both');


%%
stra.set_call(3, 2.45);
stra.set_put(3, 2.2);
stra.monitor_strangle_delta0_S0;
stra.monitor_iv_vega_theta('both');

%%
stra.set_call(2, 2.4);
stra.set_put(2, 2.2);
stra.monitor_strangle_delta0_S0;
stra.monitor_iv_vega_theta('both');

%%
stra.set_call(2, 2.4);
stra.set_put(2, 2.25);
stra.monitor_strangle_delta0_S0;
stra.monitor_iv_vega_theta('both');

%% ���ڲ���� 
stra.set_call(1, 2.3);
stra.set_put(1, 2.3);
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
stra.sell_once(4, '2' );

stra.sell_once(7, '2' );
%% ��ƽ���� - �Լ�
stra.buy_once(1, '2' ); 
stra.buy_once(2, '2' ); 
stra.buy_once(5, '2' ); 
stra.buy_once(8, '2' );

%% �򿪽��� - �Լ�
stra.buy_once(2, '1' ); 
stra.buy_once(3, '1' ); 
stra.buy_once(6, '1' );




%% �ҵ�����
stra.sell_once(1, '1', 0.8);
% stra.monitor_positions;
stra.sell_once(3, '1', 0.7);
% stra.buy_once(3, '2',0.7)
stra.sell_once(7, '1', 0.7 );


%%
QMS.set_quoteopt_ptr_in_position_array(b2.positions, qms_.optquotes_)

% ɨ�账�� pendingEntrusts 
stra.query_book_pendingEntrusts;
b2.pendingEntrusts.print;

% �۲�PNL
stra.monitor_book_risk(2.05,2.45);
b2.calc_m2m_pnl_etc; b2.positions

tic; stra.book.toExcel(); toc 


% c2.optEntrustCancel(71154)
% b2.pendingEntrusts.removeByIndex(1)
% enew = book.pendingEntrusts.node(1).getCopy
% enew.entrustNo = []

%% ȫ��
% b2.cancel_pendingOptEntrusts(c2);

pe = b2.pendingEntrusts;
L = pe.latest;
for i = L-5:L
% ֱ��ɾ����
    e  = pe.node(i);
    eno = e.entrustNo;
    code = e.instrumentCode;
    % ���������������
    if strcmp(code, '10000703')
        c2.optEntrustCancel(eno);
    end
end

%%
b2.plot_position_bars

%%  �������

b2.eod_netof_positions

%% ������ĩ�ҵ�
b2.eod_virtual_cancel_all_pendingEntrusts(c2);    
tic; stra.book.toExcel(); toc 


%% ��ĩģ�⽻��
% b2.virtual_settlement(2.312)




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

set_r  = 0.04;

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


