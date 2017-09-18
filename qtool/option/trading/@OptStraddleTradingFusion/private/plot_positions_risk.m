function plot_positions_risk(positions, vs, description, S, S_low, S_high)
pa = positions;
L = pa.latest; 
if L == 0
    return;
end
L = length( pa.node );

%%
s = Structure;
% ��j����������Ч���ڵ���Ȩ�ֲ֡�
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

%% ��structureһ��volsurface
s.volsurf = vs;

%% ע��structrue���г�����
s.S = S;
% s.r = 0.05;
s.r = quote.r;
s.inject_environment_params;


%% ���ڣ�������structure���ж��ۺͷ�����
px2 = s.calcPx;

% S_values = 1.9:0.005:2.5;
S_values = S_low:0.005:S_high;

% figure;
hold off;
s.plot_optprice_S(S_values);
hold on;
plot( s.S, px2, 'ro');






end