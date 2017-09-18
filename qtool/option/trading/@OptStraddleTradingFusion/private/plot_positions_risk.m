function plot_positions_risk(positions, vs, description, S, S_low, S_high)
pa = positions;
L = pa.latest; 
if L == 0
    return;
end
L = length( pa.node );

%%
s = Structure;
% 用j来计数在有效期内的期权持仓。
j = 0;
for i = 1:L
    pos = pa.node(i);
    try
        if (isnan(pos.quote))
            continue;
        end
    catch e
    end
    quote = pos.quote;    
    j = j + 1;
    try
        pricer = quote.QuoteOpt_2_OptPricer('ask');
    catch e
        pricer = OptPricer;
    end
    num = pos.volume * pos.longShortFlag;
    s.optPricers(j) = pricer;
    s.num(j)    = num;
end

L = j;

%% 给structure一个volsurface
s.volsurf = vs;

%% 注入structrue的市场变量
s.S = S;
% s.r = 0.05;
s.r = quote.r;
s.inject_environment_params;


%% 现在，可以用structure进行定价和风险了
px2 = s.calcPx;

% S_values = 1.9:0.005:2.5;
S_values = S_low:0.005:S_high;

% figure;
hold off;
s.plot_optprice_S(S_values);
hold on;
plot( s.S, px2, 'ro');






end