function monitor_book_risk_fig( obj, S_low, S_high, h_parent )
% monitor_book_risk_fig( obj, S_low, S_high )  
% 显示book的整体greeks
% 将monitor_book_risk进行拆分为fig

%%
if ~exist('S_low', 'var')
    S_low = 2.0;
end

if ~exist('S_high', 'var')
    S_high = 2.4;
end



%%

% 实盘时使用：
b = obj.book;
q = obj.quote;
vs = obj.volsurf;
QMS.set_quoteopt_ptr_in_position_array(b.positions, q)

%% obj 更新S
% [p, mat] = getCurrentPrice('510050', '1');
% S = p(1);
obj.quoteS.fillQuote;
S = obj.quoteS.last;
obj.S = S;

%% 把positions转成给structure，
% position 转成 pricer和num，加入structure
pa = b.positions;

p_near = PositionArray;
p_other = PositionArray;

pa_len = length(pa.node);

% 修复近月到期时的计算错误
cur_month = month(today);
cur_year = year(today);
cal = Calendar_Test.GetInstance;
near_T = cal.expirationETFopt(cur_month, cur_year);

%近月条件：过期日前，用当月合约，过期日后，用次月合约。
if today > near_T
    t = addtodate(today, 1, 'month');
    near = month(t);
else
    near = cur_month;
end

for i = 1:pa_len
    pos = pa.node(i);
    t = pos.parseTFromName;
    if near == month(t)
        p_near.push(pos);
    else
        p_other.push(pos);
    end
end


%% 图形输出
if ~exist('h_parent', 'var')
    h_parent = figure(532);
end
subplot(3,1,1, 'Parent', h_parent);
plot_positions_risk(p_near, vs, '近月持仓', S, S_low, S_high);
hold off;
subplot(3,1,2, 'Parent', h_parent);
plot_positions_risk(p_other, vs, '远月持仓', S, S_low, S_high);
hold off;
subplot(3,1,3, 'Parent', h_parent);
plot_positions_risk(pa, vs, '全部持仓', S,  S_low, S_high);
hold off;








end