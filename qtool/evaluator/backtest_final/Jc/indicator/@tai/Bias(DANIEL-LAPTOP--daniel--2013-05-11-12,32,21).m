function  [sig_rs] = Bias(close,nDay,type)
% bias 乖离率
% 只输出强弱信号
% 2013/3/21 daniel
%
% 计算公式
% Y值＝（当日收市价－N日内移动平均收市价）/N日内移动平均收市价×100％
% 其中，N日为设立参数，可按自己选用移动平均线日数设立，一般分定为6日，12日，24日
% 和72日，亦可按10日，30日，75日设定。
%
% BIAS指标的缺陷是买卖信号过于频繁，因此要与随机指标(KDJ)、布林线指标（BOLL）搭配使用。
% 乖离率的数值的大小可以直接用来研究股价的超买超卖现象，判断买卖股票的时机。
% 由于选用乖离率周期参数的不同，其对行情的研判标准也会随之变化，
% 但大致的方法基本相似。以5日和10日乖离率为例，具体方法如下：
% 1、一般而言，在弱势市场上，股价的5日乖离率达到－5以上，表示股价超卖现象出现，
%    可以考虑开始买入股票；而当股价的5日乖离率达到5以上，表示股价超买现象出现，
%    可以考虑卖出股票。
% 2、在强势市场上，股价的5日乖离率达到－10以上，表示股价超卖现象出现，为短线买入机会；
%    当股价的5日乖离率达到10以上，表示股价超买现象出现，为短线卖出股票的机会。

%% 预处理及bias计算
[nPeriod, nAsset] = size(close);
if ~exist('nDay', 'var') || isempty(nDay), nDay = 5; end
if ~exist('type', 'var') || isempty(type), type = 1; end

biasVal=ind.bias(close,nDay);

%% 信号
sig_rs = zeros(nPeriod, nAsset);
if type==1
sig_rs(biasVal > 5) = -1;
sig_rs(biasVal <-5) = 1;
else
;
end    
end %EOF

