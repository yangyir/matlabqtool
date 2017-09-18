function [] = plot_position_bars(book)
% function [] = plot_position_bars()
% 画持仓的柱状图，标注持仓重心位置。

pa = book.positions;

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


figure(1251);
subplot(311);
plot_bar_positions(p_near);
subplot(312);
plot_bar_positions(p_other);
subplot(313);
[minY, maxY] = plot_bar_positions(pa);

% minY = min(-2000, minY);
% maxY = max(2000, maxY);

subplot(311);
ylim([minY maxY]);
hold off;
subplot(312);
ylim([minY maxY]);
hold off;
subplot(313);
ylim([minY maxY]);
hold off;
end

function [minY, maxY] = plot_bar_positions(pos)
x = 2.8:0.05:3.6;

y_call_short = zeros(size(x));
y_put_short = zeros(size(x));
y_call_long = zeros(size(x));
y_put_long = zeros(size(x));

L = pos.latest;

calls_short = 1;
puts_short = 1;
calls_long = 1;
puts_long = 1;

k_call_short = 0;
k_call_long = 0;
k_put_short = 0;
k_put_long = 0;
vol_call_short = 0;
vol_call_long = 0;
vol_put_short = 0;
vol_put_long = 0;

for i = 1:L
    node = pos.node(i);
    k = node.parseKFromName;
    [call, put] = node.paserOptionTypeFromName;
    if call
        if node.longShortFlag == -1
            v = node.longShortFlag * node.volume;
            v_call = y_call_short(abs(x - k) < 0.0001);
            v_call = v_call + v;
            y_call_short(abs(x - k) < 0.0001) = v_call;
            k_call_short(calls_short) = k;
            vol_call_short(calls_short) = v;
            calls_short = calls_short + 1;
        else
            v = node.longShortFlag * node.volume;
            v_call = y_call_long(abs(x - k) < 0.0001);
            v_call = v_call + v;
            y_call_long(abs(x - k) < 0.0001) = v_call;
            k_call_long(calls_long) = k;
            vol_call_long(calls_long) = v;
            calls_long = calls_long + 1;
        end
    elseif put
        if node.longShortFlag == -1
            v_put = y_put_short(abs(x - k) < 0.0001);
            v = node.longShortFlag * node.volume;
            v_put = v_put + v;
            y_put_short(abs(x - k) < 0.0001) = v_put;
            k_put_short(puts_short) = k;
            vol_put_short(puts_short) = v;
            puts_short = puts_short + 1;
        else
            v_put = y_put_short(abs(x - k) < 0.0001);
            v = node.longShortFlag * node.volume;
            v_put = v_put + v;
            y_put_long(abs(x - k) < 0.0001) = v_put;
            k_put_long(puts_long) = k;
            vol_put_long(puts_long) = v;
            puts_long = puts_long + 1;
        end
    end
end

positions = [y_call_short(:), y_put_short(:), y_call_long(:), y_put_long(:)];

y_lim = [min(y_call_short), min((y_put_short)), max(y_call_long), max(y_put_long)];
minY = min(y_lim);
maxY = max(y_lim);

hb = bar(x, positions, 'grouped');
set(hb(1), 'FaceColor', 'r');
set(hb(2), 'FaceColor', 'b');
set(hb(3), 'FaceColor', 'r');
set(hb(4), 'FaceColor', 'b');

cg_call_short = sum(k_call_short .* vol_call_short) / sum(vol_call_short);
cg_put_short = sum(k_put_short .* vol_put_short) / sum(vol_put_short);
cg_call_long = sum(k_call_long .* vol_call_long) / sum(vol_call_long);
cg_put_long = sum(k_put_long .* vol_put_long) / sum(vol_put_long);

hold on;
plot(cg_call_short, mean(vol_call_short), 'ro');
plot(cg_put_short, mean(vol_put_short), 'bo');
plot(cg_call_long, mean(vol_call_long), 'ro');
plot(cg_put_long, mean(vol_put_long), 'bo');


end