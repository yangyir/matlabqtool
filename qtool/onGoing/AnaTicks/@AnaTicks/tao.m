function taovalue = tao( ticks0 , yields )
% 与r不同，tao一次计算ticks0一整天的下单成交时间，方便计算，灵活性差
% @luhuaibao
% 2014.5.29
% tao:
%       time-after-order, 下单后潜在等待时间；
%       tao.labels,  数据矩阵标签
%       tao.values,  数据矩阵
% tao为给定下单方式下，后验看，成交需等待时间
% inputs:
%       ticks0，为AnaTicks类，取出其ticks用以计算
%       yields, 下限价单时，让利的大小

if ~exist('yields','var')
    yields = 0 ;
end ;


%% ticks处理

ticks.time = ticks0.time(1:ticks0.latest);
ticks.bidP = ticks0.bidP(1:ticks0.latest,1);
ticks.askP = ticks0.askP(1:ticks0.latest,1);
ticks.last = ticks0.last(1:ticks0.latest,1);
ticks.volume = [nan; diff(ticks0.volume(1:ticks0.latest,1))];

labels = cell(1,4) ;
values = nan(ticks0.latest,4);




%% 市价买
labels{1} = 'buyAtMarket' ;

% 以last下单，未来判定时，仅用last
w1 = findFirstEqual(-ticks.last,-ticks.last,ticks.time ) ;
% volume小于意味着，没有真实成交，时间置为nan
w1(ticks.volume<=0) = nan ;
% 等待时间以s计
r  = w1*24*60*60  ;
values(:,1) = r ;




%% 市价卖
labels{2} = 'sellAtMarket' ;
% 以last下单，未来判定时，仅用last

w1 =  findFirstEqual(ticks.last,ticks.last,ticks.time ) ;
% volume小于意味着，没有真实成交，时间置为nan
w1(ticks.volume<=0) = nan ;
% 等待时间以s计
r = w1*24*60*60  ;
values(:,2) = r ;





%% 限价买
labels{3} = 'buyAtLimit' ;

% 未来挂卖单小于限价
w2 =  findFirstEqual(-(ticks.bidP(:,1)+yields),-ticks.askP(:,1),ticks.time ) ;
% 先令w1 = w2 , 然后再处理volume有变化的地方
w1 = w2 ;
% 未来last小于限价
w0 =  findFirstEqual(-(ticks.bidP(:,1)+yields),-ticks.last,ticks.time ) ;
w0 = w0(ticks.volume>0);
w1(ticks.volume>0) = w0 ;
w = min(w1,w2) ;
% 等待时间以s计
r = w*24*60*60  ;

values(:,3) = r ;





%% 限价卖
labels{4} = 'sellAtLimit' ;

% 未来挂买单大于限价
w2 =  findFirstEqual((ticks.askP(:,1)-yields),ticks.bidP(:,1),ticks.time ) ;
% 先令w1 = w2 , 然后再处理volume有变化的地方
w1 = w2 ;
% 未来last大于限价
w0 =  findFirstEqual((ticks.askP(:,1)-yields),ticks.last,ticks.time ) ;
w0 = w0(ticks.volume>0);
w1(ticks.volume>0) = w0 ;
w = min(w1,w2) ;
% 等待时间以s计
r = w*24*60*60  ;
values(:,4) = r ;




%%
taovalue.labels = labels ;
taovalue.values = values ;
taovalue.yields = yields ; 
taovalue.ticks = ticks0 ;  


end

