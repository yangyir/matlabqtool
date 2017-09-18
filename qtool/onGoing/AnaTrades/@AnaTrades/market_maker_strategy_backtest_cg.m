function [ pnl, frq, text ] = market_maker_strategy_backtest_cg( entrustList, tradeList, FEE, outFlag)
%MARKET_MAKER_STRATEGY_BACKTEST_CG用一日的entrustList和tradeList联合分析做市商策略的效果
% 输入： entrustList下单（组合单），tradeList成交单（回测时用推测）
% 输出：frq，pnl； 分5种情形：双成，双败，买单成，卖单成，手续费
% text是一个格式好看的文本输出
% 使用范围很局限；单品种，做市商策略，每次下一手，限价单
% 程刚；20140608

%% 
if ~exist('entrustList', 'var') || ~exist('tradeList', 'var')
    disp('缺少输入变量');
    return;
end

if ~exist('outFlag', 'var'), outFlag = 1 ; end


%% 接下来是基于EntrustList和TradeList的分析


%% 先分成功失败和手续费5种情况统计freq和pnl

tlcombNo = nan(tradeList.latest, 1);
for i = 1:tradeList.latest
    tlcombNo(i) = entrustList.combNo( entrustList.entrustNo == tradeList.entrustNo(i) ) ;
end

arrRoundNo = unique(tlcombNo);

netPosition = 0;
roundPNL = 0;
for iComb = 1:length(arrRoundNo)
    idx  = find(tlcombNo == iComb);
    
    netPosition(iComb) = sum( - tradeList.specialMark(idx).*tradeList.direction(idx) ); 
    roundPNL(iComb)   = sum( - tradeList.price(idx) .* tradeList.direction(idx) .* tradeList.volume(idx) );
end

% 分类
% 第一类：双成    
frq(1) = sum( netPosition == 0);
pnl(1) = sum( roundPNL( netPosition == 0 ) );

% 第二类：双败, 其实不存在
frq(2) = 0;
pnl(2) = 0;

% 第三类：买成，卖败，裸多
frq(3) = sum( netPosition > 0 );
pnl(3) = sum( roundPNL( netPosition > 0 ) );

% 第四类：:卖成，买败，裸空
frq(4) = sum( netPosition < 0 );
pnl(4) = sum( roundPNL( netPosition < 0 ) );

% 情况5， 手续费
frq(5) = frq(1) + frq(2)+ frq(3) + frq(4);
pnl(5) = - FEE * frq(5);




%% 输出
avgpnl = pnl./frq;
avgpnl(2) = 0;
ratio = frq./sum(frq(1:4));

% figtext输出
text = nan;
text = sprintf(    '             双成   双败   裸多   裸空   手续费');
text = sprintf('%s\nfrq:        %6d %6d %6d %6d %6d',text, frq(1:5));
text = sprintf('%s\npnl:        %6.0f %6.0f %6.0f %6.0f %6.0f',text, pnl(1:5));
text = sprintf('%s\navgpnl:     %6.1f %6.0f %6.0f %6.0f %6.1f', text, avgpnl(1:5));
text = sprintf('%s\n%%  :        %6.1f %6.1f %6.1f %6.1f', text, ratio(1:4)*100);
text = sprintf('%s\nttlPNL:     %6.1f', text, sum(pnl));

if outFlag 
    text
end




end

