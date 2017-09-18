%%

% ���Ƚ����ݽ�������
% load qms_

stramm = MarketMaking;
% ��
stramm.counter    = c2;
stramm.book       = b2;
% ��
stramm.quote          = qms_.optquotes_;
stramm.m2tkCallQuote  = qms_.callQuotes_;
stramm.m2tkPutQuote   = qms_.putQuotes_;
stramm.volsurf        = qms_.impvol_surface_;
% ��
stramm.quoteS     = qms_.stkmap_.getQuote('510050');

% ��OptionOne
% [c_ones, p_ones] = OptionOneM2TK.GetInstance();
% c_ones.attach_to_qms(qms_);
% p_ones.attach_to_qms(qms_);
% stramm.m2tkCallOne = c_ones;
% stramm.m2tkPutOne  = p_ones;
% 
% % ��counter
% stramm.set_counters;

%% ����OptionOneM2TK ��Excel

call_optone_output_fn = 'D:\intern\5.���Ʒ�\optionStraddleTrading\market_making_call_ones.xlsx';
put_optone_output_fn = 'D:\intern\5.���Ʒ�\optionStraddleTrading\market_making_put_ones.xlsx';
% stramm.m2tkCallOne.save_to_excel(call_optone_output_fn);
% stramm.m2tkPutOne.save_to_excel(put_optone_output_fn);
% 
% 
% [c_ones2, p_ones2] = OptionOneM2TK.GetInstance();
% c_ones2.load_from_excel(call_optone_output_fn);
% p_ones2.load_from_excel(put_optone_output_fn);

% ��OptionOne( ��Ҫ�ٽ��в��� )
% stramm.m2tkCallOne = qms_.m2cOptOne;
% stramm.m2tkPutOne  = qms_.m2pOptOne;


%% ��book����positions
[c_ones, p_ones] = OptionOneM2TK.GetInstance();

c_ones.load_positions_from_book( b2 )
p_ones.load_positions_from_book( b2)


c_ones.attach_to_qms(qms_);
p_ones.attach_to_qms(qms_);
stramm.m2tkCallOne = c_ones;
stramm.m2tkPutOne  = p_ones;

% ��counter
stramm.set_counters;


%% UI����

h = QuoteQmsPresentation_V0;
set( h , 'UserData' , qms_ )
setappdata( h , 'AppDataStra' , stramm )

%% �µ�����, ok  - ���߼��µ�

cOne = stramm.set_optOne(1, 2.3, 'call');
cOne.quote.print_risk;
e = cOne.place_entrust_autoOffset_autoPx('1', 7, 'mid');
b2.push_pendingEntrust(e);


%%  ��Ʊ�ֶ�����
% cOne = stramm.set_optOne(1, 2.5, 'call');
cOne = stramm.set_optOne(1, 2.2, 'put');
quote = cOne.quote;
quote.fillQuoteH5();cOne.quote.print_risk;

quote.margin
%     e = cOne.place_entrust_opt('1', 1, '2',0.426);b2.push_pendingEntrust(e);


% % ��
% for dp = -1:1
%     e = cOne.place_entrust_opt('1', 1, '2',quote.bidP1*(1-0.00-0.01*dp) );b2.push_pendingEntrust(e);
% end
    

% % ��
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





   
%% ƽcall
cOne = stramm.set_optOne(1, 2.3, 'call');
% cOne = stramm.set_optOne(1, 2.4, 'put');
quote = cOne.quote;
quote.fillQuoteH5();quote.print_risk;
% 
% ��ƽ
for dp = 5:1:10
    e = cOne.place_entrust_opt('1', 3, '2',quote.bidP1*(1 - 0.0000-0.01*dp));b2.push_pendingEntrust(e);
end
% % 

% % ��
% for dp =     1:1:1
%     e = cOne.place_entrust_opt('2', 1, '2',quote.askP1 *( 1 + 0.0000+0.01*dp));b2.push_pendingEntrust(e);
% end

% 
% % ��ƽ
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
% ��ƽ
for dp = 0:1:2
    e = cOne.place_entrust_opt('1', 3, '1',quote.bidP1*(1 - 0.0000-0.01*dp));b2.push_pendingEntrust(e);
end


cOne = stramm.set_optOne(1, 2.3, 'call');
% cOne = stramm.set_optOne(1, 2.25, 'put');
quote = cOne.quote;
quote.fillQuoteH5();quote.print_risk;

% ����
for dp = -1:1:2
    e = cOne.place_entrust_opt('2', 3, '1',quote.askP1 *( 1 + 0.0000+0.01*dp));b2.push_pendingEntrust(e);
end

%% 1ԪƱ˦ƽ - ��ƽ

% 1729��P2000
% oOne = stramm.set_optOne(1, 2.45, 'call');
oOne = stramm.set_optOne(1, 2.25, 'put');

for i = 1:4
%     e = oOne.place_entrust_opt('1', 10, '2', 0.0003);b2.push_pendingEntrust(e);

    e = oOne.place_entrust_opt('1', 10, '2', 0.0001);b2.push_pendingEntrust(e);
end






%% ��ƽput��
pOne = stramm.set_optOne(1, 2.10, 'put');
quote = pOne.quote;
quote.fillQuoteH5();quote.print_risk;

% mid = ( quote.askP1 + quote.bidP1 ) / 2 
% e = cOne.place_entrust_autoOffset('2',7, quote.askP1-0.0001);b2.push_pendingEntrust(e);
e = pOne.place_entrust_opt('1', 7, '2', quote.bidP1);b2.push_pendingEntrust(e);
e = pOne.place_entrust_opt('1', 7, '2', quote.bidP1+0.0001);b2.push_pendingEntrust(e);

 
%% ��
cOne.print_pendingEntrusts_quotes
cOne.quote.print_pankou



% ȫbook�鶩��
% b2.query_pendingEntrusts( c2);
% b2.pendingEntrusts.print;

%��Ʊ
cOne.query_pendingEntrusts( c2)
cOne.sweep_pendingEntrusts;
cOne.pendingEntrusts.print;

cOne.positionLong.println;
cOne.positionShort.println;




%% ��Ʊ���� - ˫�߹ҵ�
% thisOne = stramm.set_optOne(1, 2.2, 'call');
% thisOne = stramm.set_optOne(1, 2.15, 'put');
% thisOne = stramm.set_optOne(1, 2.1, 'put');


for K = [2.1, 2.15, 2.2]
    thisOne = stramm.set_optOne(1, K, 'put');
    
    
    quote = thisOne.quote;
    
    
    % �̿ڹ����͹ҵ�
    quote.fillQuoteH5();
    absp = quote.askP1 - quote.bidP1
    
    if absp >=0.0012
        % ������
        e = thisOne.place_entrust_autoOffset('2', 2, quote.askP1-0.0002);b2.push_pendingEntrust(e);
        
        % ����
        e = thisOne.place_entrust_autoOffset('1', 2, quote.bidP1+0.0002);b2.push_pendingEntrust(e);
        
        
        % ��һ���̿�
        %     thisOne.quote.print_pankou
        
    elseif absp >=0.0008
        % ������
        e = thisOne.place_entrust_autoOffset('2', 2, quote.askP1-0.0001);b2.push_pendingEntrust(e);
        
        % ����
        e = thisOne.place_entrust_autoOffset('1', 2, quote.bidP1+0.0001);b2.push_pendingEntrust(e);
        
        
        % ��һ���̿�
        %     thisOne.quote.print_pankou
        
    elseif absp >=0.0006
        % ������
        if quote.askQ1 >= 30
            pxa =  quote.askP1-0.0001;
        else
            pxa =  quote.askP1;
        end
        e = thisOne.place_entrust_autoOffset('2', 2, pxa);b2.push_pendingEntrust(e);
        
        % ����
        if quote.bidQ1 >= 30
            pxb =  quote.bidP1+0.0001;
        else
            pxb =  quote.bidP1;
        end
        e = thisOne.place_entrust_autoOffset('1', 2, pxb);b2.push_pendingEntrust(e);
        
        
        % ��һ���̿�
        %     thisOne.quote.print_pankou
        
    elseif absp >=0.0004
        % ������
        
        e = thisOne.place_entrust_autoOffset('2', 2, quote.askP1);b2.push_pendingEntrust(e);
        
        % ����
        e = thisOne.place_entrust_autoOffset('1', 2, quote.bidP1);b2.push_pendingEntrust(e);
        
        
        % ��һ���̿�
        %     thisOne.quote.print_pankou
        
    end
    
end


%% ��


for K = [2.1, 2.15, 2.2]
    thisOne = stramm.set_optOne(1, K, 'put');

% thisOne.quote.fillQuoteH5;
% thisOne.print_pendingEntrusts_quotes


%��Ʊ - �µ�
thisOne.query_pendingEntrusts( c2)
thisOne.sweep_pendingEntrusts;
thisOne.pendingEntrusts.print;

% ��Ʊ - ��λ
% thisOne.positionLong.println;
% thisOne.positionShort.println;

end

%% ��һֻƱ����Ŀ�꣬�Զ��ҵ���


aimVolume = 100;


%%
thisOne = stramm.set_optOne(1, 2.1, 'put');
quote = thisOne.quote;

if aimVolume > 0
    
    % �Ȳ�ѯǰ��״̬����������
    % 1����ǰ��filled�����µ�
    % 2����ǰ��unfilled�������µ�δ�䣬�ȴ�
    % 3����ǰ��unfilled�������µ��б䣬��ǰ�������µ�
    
    %��Ʊ��ѯ
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
    
    % ������ֵҪ��0.0002����ֹ�Լ����Լ�����
    if abs( newPx - prePx) >= 0.0002
        status_newEntrust_changed = 1;
    end
    
    
    if status_entrust_filled
        fprintf('ǰ��filled�����µ�\n');
        
        % ����aimVolume
        aimVolume = aimVolume - e_tmp.dealVolume

        
        % ���µ�
        e_tmp = thisOne.place_entrust_autoOffset('2',7, newPx);
        b2.push_pendingEntrust(e_tmp);
        e_tmp.println;
        
        
    elseif status_newEntrust_changed
        
        fprintf('ǰ��unfilled�������µ��б䣬��ǰ�������µ�\n');
        
        
        % ��ǰ������
        ems.HSO32_cancel_optEntrust_and_fill_cancelNo(e_tmp, c2);
        
        % ����
        e_tmp = thisOne.place_entrust_autoOffset('2', 7, newPx);
        b2.push_pendingEntrust(e_tmp);
        e_tmp.println;

    else
        fprintf('ǰ��unfilled�������µ�δ�䣬�ȴ�\n')
        
        % �ȴ���������
    end                   


    
    
end


% 
% cOne.positionLong.println;
% cOne.positionShort.println;

%% MarketMaking���µ��߼�������

% ��ȡS
% ����impvol
% �����̿ڿ��
% �� 3<�̿ڿ��<6, ���������ߵ�һ��������Ҫ�죬����Ҫ��

% ���̿ڿ��>6, ���ò�1tick��
pOne = stramm.set_putOne(1, 2.3);

% ��vol��۸��³�ȥ
% ��bid ��ask֮�������1��
quote = pOne.quote;
pOne.place_entrust_autoOffset('2', 1, 0.5 )
pOne.pendingEntrusts.print


% ��ѯ
b2.query_pendingEntrusts(c2);


%% ��ʼ��optionOne.askOrderBook �� optionOne.bidOrderBook
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




%% ��Entrusts�������OrderBook

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

% ����OrderBook
oOne.askOrderBook.reorganize_pending;
oOne.bidOrderBook.reorganize_pending;




%% OrderBook��������

   
