function  [sig_long, sig_short, sig_rs] = Psy(ClosePrice,nDay, mDay,type)
% Psy 心理线
% 返回 sig_long (上穿25为买入）， sig_short(下穿75为卖出）， sig_rs(25下方为超卖区，75上方为超买区）
% 默认回溯bar数 nDay = 12, mDay = 6; 
% psy算法参见 ind.psy
% @author daniel 20130506

% PSY指标的取值情况
% 1、PSY指标的取值始终是处在0——100之间，0值是PSY指标的下限极值，100是PSY指标的上限极值。50值为多空双方的分界线。
% 2、PSY值大于50为PSY指标的多方区域，说明N日内上涨的天数大于下跌的天数，多方占主导地位，投资者可持股待涨。
% 3、PSY值小于50为PSY指标的空方区域，说明N日内上涨的天数小于下跌的天数，空方占主导地位，投资者宜持币观望。
% 4、PSY在50左右徘徊，则反映近期股票指数或股价上涨的天数与下跌的天数基本相等，多空力量维持平衡，投资者以观望为主。

% 应用法则
% 1.一段下跌（上升）行情展开前，超买(超卖)的最高（低）点通常会出现两次。在出现第二次超买(超卖)的最高（低）点时，一般是卖出（买进）时机。由于PSY指标具有这种高点密集出现的特性，可给投资者带来充裕时间进行研判与介入。
% 2.PSY指标在25～75之间为常态分布。PSY指标主要反映市场心理的超买超卖，因此，当心理线指标在常态区域内上下移动时，一般应持观望态度。
% 3.PSY指标超过75或低于25时，表明股价开始步入超买区或超卖区,此时需要留心其动向。当PSY指标百分比值超过83或低于17时，表明市场出现超买区或超卖区,价位回跌或回升的机会增加，投资者应该准备卖出或买进，不必在意是否出现第二次信号。这种情况在个股中比较多见。
% 4.当PSY指标百分比值<10，是极度超卖。抢反弹的机会相对提高，此时为短期较佳的买进时机；反之，如果PSY指标百分比值>90，是极度超买。此时为短期卖出的有利时机。
% 5.当PSY曲线和PSYMA曲线同时向上运行时，为买入时机；相反，当PSY曲线与PSYMA曲线同时向下运行时，为卖出时机。而当PSY曲线向上突破PSYMA曲线时，为买入时机；相反，当PSY曲线向下跌破PSYMA曲线后，为卖出时机。
% 6.当PSY曲线向上突破PSYMA曲线后，开始向下回调至PSYMA曲线，只要PSY曲线未能跌破PSYMA曲线，都表明股价属于强势整理。一旦PSY曲线再度返身向上时，为买入时机；当PSY曲线和PSYMA曲线同时向上运行一段时间后，PSY曲线远离PSYMA曲线时，一旦PSY曲线掉头向下，说明股价上涨的动能消耗较大，为卖出时机。
% 7.当PSY曲线和PSYMA曲线再度同时向上延伸时，投资者应持股待涨；当PSY曲线在PSYMA曲线下方运行时，投资者应持币观望。
% 8.当PSY曲线和PSYMA曲线始终交织在一起，于一个波动幅度不大的空间内运动时，预示着股价处于盘整的格局中，投资者应以观望为主。

%% 预处理
[nPeriod, nAsset]= size(ClosePrice);
sig_long = zeros(nPeriod, nAsset);
sig_short = zeros(nPeriod, nAsset);

if ~exist('nDay', 'var') || isempty(nDay),   nDay = 12;
end
if ~exist('mDay', 'var') || isempty(mDay), mDay = 6; end
if ~exist('type', 'var') || isempty(type), type = 1; end



%% 计算步
 [ psyVal ] = ind.psy(ClosePrice,nDay);


%% 信号步
if type==1
    oneline  =  ones(nPeriod, nAsset );
    sig_long(logical(crossOver(psyVal, oneline*25))) = 1;
    sig_short(logical(crossOver(oneline*75, psyVal))) = -1;
    sig_rs(psyVal < 25 ) = 1;
    sig_rs(psyVal > 75 ) = -1;
else
;
end
end %EOF


    
