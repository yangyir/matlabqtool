function [   ] = demo3(   )
%DEMO3 此处显示有关此函数的摘要
%   此处显示详细说明

%% 读一本book
% b = Book;
% bookfn = 'D:\intern\5.吴云峰\optionStraddleTrading\book_straddle.xlsx';
% b.fromExcel(bookfn);

%% 把book里的positions都挂上quoteOpt
% 生成所有的quoteOpt，并用M2TK挂上
% fn = 'D:\intern\5.吴云峰\optionStraddleTrading\OptInfo.xlsx';
% [q, m2c, m2p] =  QuoteOpt.init_from_sse_excel( fn );

% 实盘时使用：
q = qms_.optquotes_;
qms.set_quoteopt_ptr_in_position_array(b.positions, q)


%% 把positions转成给structure，
% position 转成 pricer和num，加入structure
pa = b.positions;
L = pa.latest; 
L = length( pa.node );

s = Structure;
for i = 1:L
    pos = pa.node(i);
    quote = pos.quote;
    pricer = quote.QuoteOpt_2_OptPricer('ask');
    num = pos.volume * pos.longShortFlag;
    s.optPricers(i) = pricer;
    s.num(i)    = num;
end

%% 给structure一个volsurface
% load 'D:\intern\5.吴云峰\optionStraddleTrading\vs.mat'
% s.volsurf = vs;

s.volsurf = qms_.impvol_surface_;
%% s的市场变量
s.S = 2.057;
s.r = 0.035;
s.inject_environment_params


%% 现在，可以用structure进行定价和风险了
px1 = 0;
for i = 1:L 
px1 = px1 + s.optPricers(i).px * s.num(i);
end
px2 = s.calcPx;
s.plot_optprice_S
hold on
plot( s.S, px2, 'ro');


%% 现在，也可以用sturcture算风险
% 算
s.calcDelta;
s.calcGamma;
s.calcVega;
s.calcTheta;
s.calcRho;
s.calcIntrinsicValue;
s.calcTimeValue;

% 输出
% 输出， 形同：
%       optName	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
% [购3月2100]	25%	 46.70	 93.39	 5.07	 20.27	 -9.03	 15.03
% [沽3月1900]	34%	 -49.37	 -98.74	 3.73	 14.93	 -11.42	 15.50
fprintf('S = %0.4f  |  %s\n', s.S, datestr(now));
fprintf('optName\tpos\taskpx\tiv\t1%% 2%%delta\t1%% 2%%gamma\tDtheta\t1%%vega\n');
ttl = zeros(1,9);
for i = 1:L
    tmp = s.optPricers(i);
    num = s.num(i);
%     if i == 2, tmp = put; end
    on      = tmp.optName(6:end);
    bid     = tmp.px * tmp.multiplier;
    iv      = tmp.sigma*100;
    delta   = tmp.delta * tmp.multiplier * tmp.S*0.01;
    delta2  = tmp.delta * tmp.multiplier * tmp.S*0.02;
    gamma1  = tmp.gamma * tmp.multiplier * tmp.S*tmp.S*0.0001/2 ;
    gamma2  = tmp.gamma * tmp.multiplier * tmp.S*tmp.S*0.0004/2 ;
    theta   = tmp.theta * tmp.multiplier / 365 ;
    vega    = tmp.vega * tmp.multiplier * 0.01;
    
    sss(i,:) = [num, bid, iv, delta, delta2, gamma1, gamma2, theta, vega];    
    fprintf('[%s]\t%d\t%0.0f\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\n', on, num,...
        bid, iv, delta, delta2,  gamma1, gamma2, theta, vega);
    
    % 加和
    ttl(2:end) = ttl(2:end) +  sss(i, 2:end) * num;
    ttl(1)  = ttl(1) + num;
end

% iv 求均值
ttl(3) = ttl(3) / ttl(1);
fprintf('[%s]\t%d\t%0.0f\t%0.1f%%\t %3.0f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\n', '  合 计 ',...
    ttl);



end

