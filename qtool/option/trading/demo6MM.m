%%

% 首先将数据进行载入
% load qms_

stramm = MarketMaking;
% 挂
stramm.counter    = c2;
stramm.book       = b2;
% 挂
stramm.quote          = qms_.optquotes_;
stramm.m2tkCallQuote  = qms_.callQuotes_;
stramm.m2tkPutQuote   = qms_.putQuotes_;
stramm.volsurf        = qms_.impvol_surface_;
% 挂
stramm.quoteS     = qms_.stkmap_.getQuote('510050');

% 挂OptionOne
% [c_ones, p_ones] = OptionOneM2TK.GetInstance();
% c_ones.attach_to_qms(qms_);
% p_ones.attach_to_qms(qms_);
% stramm.m2tkCallOne = c_ones;
% stramm.m2tkPutOne  = p_ones;
% 
% % 挂counter
% stramm.set_counters;

%% 保存OptionOneM2TK 到Excel

call_optone_output_fn = 'D:\intern\5.吴云峰\optionStraddleTrading\market_making_call_ones.xlsx';
put_optone_output_fn = 'D:\intern\5.吴云峰\optionStraddleTrading\market_making_put_ones.xlsx';
% stramm.m2tkCallOne.save_to_excel(call_optone_output_fn);
% stramm.m2tkPutOne.save_to_excel(put_optone_output_fn);
% 
% 
% [c_ones2, p_ones2] = OptionOneM2TK.GetInstance();
% c_ones2.load_from_excel(call_optone_output_fn);
% p_ones2.load_from_excel(put_optone_output_fn);

% 挂OptionOne( 需要再进行补上 )
% stramm.m2tkCallOne = qms_.m2cOptOne;
% stramm.m2tkPutOne  = qms_.m2pOptOne;


%% 从book里拿positions
[c_ones, p_ones] = OptionOneM2TK.GetInstance();

c_ones.load_positions_from_book( b2 )
p_ones.load_positions_from_book( b2)


c_ones.attach_to_qms(qms_);
p_ones.attach_to_qms(qms_);
stramm.m2tkCallOne = c_ones;
stramm.m2tkPutOne  = p_ones;

% 挂counter
stramm.set_counters;


%% UI部分

h = QuoteQmsPresentation_V0;
set( h , 'UserData' , qms_ )
setappdata( h , 'AppDataStra' , stramm )

%% 下单部分, ok  - 无逻辑下单

cOne = stramm.set_optOne(1, 2.3, 'call');
cOne.quote.print_risk;
e = cOne.place_entrust_autoOffset_autoPx('1', 7, 'mid');
b2.push_pendingEntrust(e);


%%  单票手动买卖
% cOne = stramm.set_optOne(1, 2.5, 'call');
cOne = stramm.set_optOne(1, 2.2, 'put');
quote = cOne.quote;
quote.fillQuoteH5();cOne.quote.print_risk;

quote.margin
%     e = cOne.place_entrust_opt('1', 1, '2',0.426);b2.push_pendingEntrust(e);


% % 买
% for dp = -1:1
%     e = cOne.place_entrust_opt('1', 1, '2',quote.bidP1*(1-0.00-0.01*dp) );b2.push_pendingEntrust(e);
% end
    

% % 卖
% for dp = 3:1:5
%     e = cOne.place_entrust_opt('2', 7, '1',quote.askP1*(1 + 0.0+ 0.01*dp));b2.push_pendingEntrust(e);
% end
                                                                                                                                                                                                                                                                                                                                                                                                                                      


%% 
% cOne = stramm.set_optOne(3, 2.45, 'call');
cOne = stramm.set_optOne(1, 2.3, 'put');
quote = cOne.quote;
quote.fillQuoteH5();quote.print_risk;

% 
for dp = -2:2:2
    e = cOne.place_entrust_opt('2', 6, '1',quote.askP1*(1 + 0.01*dp));b2.push_pendingEntrust(e);
end





   
%% 平call
cOne = stramm.set_optOne(1, 2.3, 'call');
% cOne = stramm.set_optOne(1, 2.4, 'put');
quote = cOne.quote;
quote.fillQuoteH5();quote.print_risk;
% 
% 买平
for dp = 5:1:10
    e = cOne.place_entrust_opt('1', 3, '2',quote.bidP1*(1 - 0.0000-0.01*dp));b2.push_pendingEntrust(e);
end
% % 

% % 卖
% for dp =     1:1:1
%     e = cOne.place_entrust_opt('2', 1, '2',quote.askP1 *( 1 + 0.0000+0.01*dp));b2.push_pendingEntrust(e);
% end

% 
% % 卖平
% for dp = 0:2
%     e = cOne.place_entrust_opt('2', 1, '2',quote.askP1 + 0.0000+0.0005*dp);b2.push_pendingEntrust(e);
% end


%%
%% call spread
cOne = stramm.set_optOne(1, 2.25, 'call');
% cOne = stramm.set_optOne(1, 2.25, 'put');
quote = cOne.quote;
quote.fillQuoteH5();quote.print_risk;
% 
% 买平
for dp = 0:1:2
    e = cOne.place_entrust_opt('1', 3, '1',quote.bidP1*(1 - 0.0000-0.01*dp));b2.push_pendingEntrust(e);
end


cOne = stramm.set_optOne(1, 2.3, 'call');
% cOne = stramm.set_optOne(1, 2.25, 'put');
quote = cOne.quote;
quote.fillQuoteH5();quote.print_risk;

% 卖开
for dp = -1:1:2
    e = cOne.place_entrust_opt('2', 3, '1',quote.askP1 *( 1 + 0.0000+0.01*dp));b2.push_pendingEntrust(e);
end

%% 1元票甩平 - 买平

% 1729手P2000
% oOne = stramm.set_optOne(1, 2.45, 'call');
oOne = stramm.set_optOne(1, 2.25, 'put');

for i = 1:4
%     e = oOne.place_entrust_opt('1', 10, '2', 0.0003);b2.push_pendingEntrust(e);

    e = oOne.place_entrust_opt('1', 10, '2', 0.0001);b2.push_pendingEntrust(e);
end






%% 买平put，
pOne = stramm.set_optOne(1, 2.10, 'put');
quote = pOne.quote;
quote.fillQuoteH5();quote.print_risk;

% mid = ( quote.askP1 + quote.bidP1 ) / 2 
% e = cOne.place_entrust_autoOffset('2',7, quote.askP1-0.0001);b2.push_pendingEntrust(e);
e = pOne.place_entrust_opt('1', 7, '2', quote.bidP1);b2.push_pendingEntrust(e);
e = pOne.place_entrust_opt('1', 7, '2', quote.bidP1+0.0001);b2.push_pendingEntrust(e);

 
%% 看
cOne.print_pendingEntrusts_quotes
cOne.quote.print_pankou



% 全book查订单
% b2.query_pendingEntrusts( c2);
% b2.pendingEntrusts.print;

%单票
cOne.query_pendingEntrusts( c2)
cOne.sweep_pendingEntrusts;
cOne.pendingEntrusts.print;

cOne.positionLong.println;
cOne.positionShort.println;




%% 单票做市 - 双边挂单
% thisOne = stramm.set_optOne(1, 2.2, 'call');
% thisOne = stramm.set_optOne(1, 2.15, 'put');
% thisOne = stramm.set_optOne(1, 2.1, 'put');


for K = [2.1, 2.15, 2.2]
    thisOne = stramm.set_optOne(1, K, 'put');
    
    
    quote = thisOne.quote;
    
    
    % 盘口够宽，就挂单
    quote.fillQuoteH5();
    absp = quote.askP1 - quote.bidP1
    
    if absp >=0.0012
        % 挂卖单
        e = thisOne.place_entrust_autoOffset('2', 2, quote.askP1-0.0002);b2.push_pendingEntrust(e);
        
        % 挂买单
        e = thisOne.place_entrust_autoOffset('1', 2, quote.bidP1+0.0002);b2.push_pendingEntrust(e);
        
        
        % 看一下盘口
        %     thisOne.quote.print_pankou
        
    elseif absp >=0.0008
        % 挂卖单
        e = thisOne.place_entrust_autoOffset('2', 2, quote.askP1-0.0001);b2.push_pendingEntrust(e);
        
        % 挂买单
        e = thisOne.place_entrust_autoOffset('1', 2, quote.bidP1+0.0001);b2.push_pendingEntrust(e);
        
        
        % 看一下盘口
        %     thisOne.quote.print_pankou
        
    elseif absp >=0.0006
        % 挂卖单
        if quote.askQ1 >= 30
            pxa =  quote.askP1-0.0001;
        else
            pxa =  quote.askP1;
        end
        e = thisOne.place_entrust_autoOffset('2', 2, pxa);b2.push_pendingEntrust(e);
        
        % 挂买单
        if quote.bidQ1 >= 30
            pxb =  quote.bidP1+0.0001;
        else
            pxb =  quote.bidP1;
        end
        e = thisOne.place_entrust_autoOffset('1', 2, pxb);b2.push_pendingEntrust(e);
        
        
        % 看一下盘口
        %     thisOne.quote.print_pankou
        
    elseif absp >=0.0004
        % 挂卖单
        
        e = thisOne.place_entrust_autoOffset('2', 2, quote.askP1);b2.push_pendingEntrust(e);
        
        % 挂买单
        e = thisOne.place_entrust_autoOffset('1', 2, quote.bidP1);b2.push_pendingEntrust(e);
        
        
        % 看一下盘口
        %     thisOne.quote.print_pankou
        
    end
    
end


%% 看


for K = [2.1, 2.15, 2.2]
    thisOne = stramm.set_optOne(1, K, 'put');

% thisOne.quote.fillQuoteH5;
% thisOne.print_pendingEntrusts_quotes


%单票 - 下单
thisOne.query_pendingEntrusts( c2)
thisOne.sweep_pendingEntrusts;
thisOne.pendingEntrusts.print;

% 单票 - 仓位
% thisOne.positionLong.println;
% thisOne.positionShort.println;

end

%% 对一只票，给目标，自动挂单卖


aimVolume = 100;


%%
thisOne = stramm.set_optOne(1, 2.1, 'put');
quote = thisOne.quote;

if aimVolume > 0
    
    % 先查询前单状态，再做决定
    % 1，若前单filled，下新单
    % 2，若前单unfilled，且拟新单未变，等待
    % 3，若前单unfilled，且拟新单有变，撤前单，下新单
    
    %单票查询
    thisOne.query_pendingEntrusts( c2)
    thisOne.sweep_pendingEntrusts;
    thisOne.pendingEntrusts.print;
    
    
    
    status_entrust_filled = e_tmp.is_entrust_closed;
    
    
    status_newEntrust_changed = 0;

    quote.fillQuoteH5();
    
    direc = e_tmp.direction;
    prePx = e_tmp.price;
    
    if direc == 1
        newPx = quote.bidP1+0.0001;
    elseif direc == -1
        newPx = quote.askP1-0.0001;
    end
    
    % 这里阈值要是0.0002，防止自己跟自己竞争
    if abs( newPx - prePx) >= 0.0002
        status_newEntrust_changed = 1;
    end
    
    
    if status_entrust_filled
        fprintf('前单filled，下新单\n');
        
        % 更新aimVolume
        aimVolume = aimVolume - e_tmp.dealVolume

        
        % 下新单
        e_tmp = thisOne.place_entrust_autoOffset('2',7, newPx);
        b2.push_pendingEntrust(e_tmp);
        e_tmp.println;
        
        
    elseif status_newEntrust_changed
        
        fprintf('前单unfilled，且拟新单有变，撤前单，下新单\n');
        
        
        % 撤前，下新
        ems.HSO32_cancel_optEntrust_and_fill_cancelNo(e_tmp, c2);
        
        % 下新
        e_tmp = thisOne.place_entrust_autoOffset('2', 7, newPx);
        b2.push_pendingEntrust(e_tmp);
        e_tmp.println;

    else
        fprintf('前单unfilled，且拟新单未变，等待\n')
        
        % 等待，不做事
    end                   


    
    
end


% 
% cOne.positionLong.println;
% cOne.positionShort.println;

%% MarketMaking的下单逻辑在这里

% 先取S
% 计算impvol
% 计算盘口宽度
% 如 3<盘口宽度<6, 跟挂在两边第一档，跟的要快，撤的要快

% 如盘口宽度>6, 各让步1tick挂
pOne = stramm.set_putOne(1, 2.3);

% 用vol算价格，下出去
% 在bid 到ask之间各档下1单
quote = pOne.quote;
pOne.place_entrust_autoOffset('2', 1, 0.5 )
pOne.pendingEntrusts.print


% 查询
b2.query_pendingEntrusts(c2);


%% 初始化optionOne.askOrderBook ， optionOne.bidOrderBook
% oOne.askOrderBook = OrderBookPartial;
obp = OrderBookPartial;
obp.side = 'bid';
obp.code = oOne.optinfo.code;

oOne.bidOrderBook = obp;


% 
obp = OrderBookPartial;
obp.side = 'ask';
obp.code = oOne.optinfo.code;

oOne.askOrderBook = obp;




%% 把Entrusts分类放入OrderBook

oOne.sweep_pendingEntrusts
oOne.pendingEntrusts.print;
oOne.finishedEntrusts.print;

pe = oOne.pendingEntrusts;
L = pe.latest;

for i = 1:L
    e = pe.node(i);
    if e.direction  == 1
        oOne.bidOrderBook.push_entrust(e);
    elseif e.direction == 2
        oOne.askOrderBook.push_entrust(e);
    end
end

% 重整OrderBook
oOne.askOrderBook.reorganize_pending;
oOne.bidOrderBook.reorganize_pending;




%% OrderBook自身重整

   
