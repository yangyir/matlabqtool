function  [sig_long, sig_short, sig_rs ] = Trix (bar, nDay, mDay,type)
% Trix 三重指数平均
% sig_long: 金叉买入，没有设置平仓； sig_short：死叉卖出，没有设置平仓；
% 可以补充顶背离和底背离的反转情形
% 2013/3/21 daniel
%
% TRIX线基本用法
% TRIX指标是属于中长线指标，其最大的优点就是可以过滤短期波动的干扰，以避免频繁操作
% 而带来的失误和损失。因此TRIX指标最适合于对行情的中长期走势的研判。
% 在股市软件上TRIX指标有两条线，一条线为TRIX线，另一条线为TRMA线。
% TRIX指标的一般研判标准主要集中在TRIX线和TRMA线的交叉情况的考察上。
% 其基本分析内容如下：
% 1、当TRIX线一旦从下向上突破TRMA线，形成“金叉”时，预示着股价开始进入强势拉升阶段，
%    投资者应及时买进股票。
% 2、当TRIX线向上突破TRMA线后，TRIX线和TRMA线同时向上运动时，预示着股价强势依旧，
%    投资者应坚决持股待涨。
% 3、当TRIX线在高位有走平或掉头向下时，可能预示着股价强势特征即将结束，
%    投资者应密切注意股价的走势，一旦K线图上的股价出现大跌迹象，投资者应及时卖出股票。
% 4、当TRIX线在高位向下突破TRMA线，形成“死叉”时，预示着股价强势上涨行情已经结束，
%    投资者应坚决卖出余下股票，及时离场观望。
% 5、当TRIX线向下突破TRMA线后，TRIX线和TRMA线同时向下运动时，
%    预示着股价弱势特征依旧，投资者应坚决持币观望。
% 6、当TRIX线在TRMA下方向下运动很长一段时间后，并且股价已经有较大的跌幅时，
%    如果TRIX线在底部有走平或向上勾头迹象时，一旦股价在大的成交量的推动下向上攀升时，
%    投资者可以及时少量地中线建仓。
% 7、当TRIX线再次向上突破TRMA线时，预示着股价将重拾升势，投资者可及时买入，持股待涨。 
% 8、TRIX指标不适用于对股价的盘整行情的研判。

%% 数据预处理和tr trma 计算

close = bar.close;
%if ~exist('nday', 'var') || isempty(nDay), nDay = 12; end
if ~exist('nDay', 'var')|| isempty(nDay), nDay = 12; end % modified by Wu Zehui
if ~exist('mDay', 'var') || isempty(mDay), mDay = 20; end
if ~exist('type', 'var') || isempty(type), type = 1; end


%% 信号
[sig_long, sig_short, sig_rs] = tai.Trix(close, nDay, mDay, type);

if nargout == 0
    [trix.tr] = ind.trix(close, nDay, mDay);
    bar.plotind2(sig_long + sig_short, trix);
    title('trix long and short');
    bar.plotind2(sig_rs, trix);
    title('trix rs');
end
end


