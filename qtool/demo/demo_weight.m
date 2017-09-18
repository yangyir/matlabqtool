clear;
close all;
%% 枚举配权重（五个指标）
load Hs300_bar.mat;
sigList = {'Asi', 'Alligator', 'Bollinger', 'Dmi', 'Sar'};
sig_long = getindicators(bar, sigList, 'long');
sig_short = getindicators(bar, sigList, 'short');
nsig = length(sigList);
nPeriod = size(bar.close, 1);
nCase = 975;
%% 设置权重步长0.1，阈值0.3
step = 0.1;
thred = 0.3;
w = zeros(1, nsig);
nav = zeros(nPeriod, nCase);
cases = zeros(nCase, nsig);
trade = zeros(1, nCase);
hit = zeros(1, nCase);
mdd = zeros(1, nCase);
iCase = 0;
set(gcf, 'Position', [200 200 560 840]);
%% 枚举搜索
for i1 = 0:step:1
    w(1) = i1;
    for i2 = 0:step:1-sum(w)
        w(2) = i2;
        for i3 = 0:step:1-sum(w)
            w(3) = i3;
            for i4 = 0:step:1-sum(w)
                w(4) = i4;
                w(5) = 1 - sum(w);
                
                iCase = iCase+1;
                cases(iCase, :) = w;
                sigcom_long = (w * sig_long')';
                sigcom_long(sigcom_long > thred) = 1;
                sigcom_long(sigcom_long < -thred) = -1;
                sigcom_long(sigcom_long >= -thred & sigcom_long <= thred) = 0;
                sigcom_short = (w * sig_short')';
                sigcom_short(sigcom_short > thred) = 1;
                sigcom_short(sigcom_short < -thred)= -1;
                sigcom_short(sigcom_short >= -thred & sigcom_short <= thred) = 0;

                sigcom = sigcomb(sigcom_long, sigcom_short);
                price = bar.close;
                [nav(:, iCase), buy, sell, sellshort, buycover ] = sig2nav2(price, sigcom);
                trade(iCase) = length(buy) + length(sell) + length(sellshort) + length(buycover);
                hit(iCase) = eval.HitRetio(price, buy, sell, sellshort, buycover);
                mdd(iCase) = eval.MaxDrawdown(nav(:, iCase));
                %% 选出最终收益>1.4且hit>0.6的作图
                if nav(end, iCase) > 1.4 && hit(iCase) > 0.6 && mdd(iCase) < 15 || iCase == 66
                    subplot(2,1,1);
                    plot(1:size(price,1), price, buy, price(buy), '+r', sell, price(sell), 'or', sellshort, price(sellshort), '+g', buycover, price(buycover), 'og');
                    legend('close', 'buy', 'sell', 'sellshort', 'buycover');
                    subplot(2,1,2);
                    plot(nav(:, iCase));
                    title(['Case=',num2str(w), 'Return=', num2str(nav(end, iCase),3), 'Hit=', num2str(hit(iCase), 3),'Mdd=',num2str(mdd(iCase),3)]);
                end
                w(5) = 0;
            end
            w(4) = 0;
        end
        w(3) = 0;
    end
    w(2) = 0;
end
                    