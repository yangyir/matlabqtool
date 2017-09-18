function [obj] = calcPseudoIndex(obj, tm)
% CALCPSEUDOINDEX 计算合成指数点位
% 对涨跌停股的处理要斟酌


% 出现问题：有个股封涨停，没有卖单，怎么办？
% 涨停的也挂单，期待或可打开

% 涨停出现，价格可能是nan，至少回测时是这样
sProf = obj.stockProfile;

idx_zhangting = isnan(sProf(:,3));
idx_dieting   = isnan( sProf(:,5));

% ask1， ask2
sProf(idx_zhangting, [2,6]) = sProf(idx_zhangting,1);
sProf(idx_zhangting, [3,7]) = 0;

% bid1, bid2
sProf(idx_dieting, [4,8])   = sProf(idx_dieting, 1);
sProf(idx_dieting, [5,9])   = 0 ;


tmp = sProf' * obj.stockQ;

% 生成last是最简单的了


% 可以用最简单的方法生成a1,a2,b1,b2


tks = obj.pseudoIndexTicks;
tks.latest = tks.latest + 1;
l = tks.latest;

tks.time(l,1)   = tm;
tks.last(l,1)   = tmp(1);
tks.askP(l,1)   = tmp(2);
tks.bidP(l,1)   = tmp(4);
tks.askP(l,2)   = tmp(6);
tks.bidP(l,2)   = tmp(8);

% 生成volume要费点劲


end
