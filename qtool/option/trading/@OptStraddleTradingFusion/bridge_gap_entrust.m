function bridge_gap_entrust(std_stra, com_stra, prct, rate, opposite)
% 将两个StraddleTrading策略磨平一次性委托函数
% bridge_books_gap_entrust(obj, std_straddle_name, prct, proportion, pposite)
%Import
% std_stra:基准的Straddle策略
% com_stra:对比的Straddle策略
% prct:弥合的百分比
% rate：com相比于std的比率
% opposite 下单对手价格档位
% 吴云峰


if ~exist('prct', 'var')
    prct = 10;
end
if ~exist('rate', 'var')
    rate = 1;
end
if ~exist('opposite' , 'var')
    opposite = 1;
end

assert(prct > 0 && prct <= 100);
assert(rate > 0);
assert(ismember(opposite, 1:5))
prct = prct/100;

%% 一次性开火下单

book_std = std_stra.book;
book_com = com_stra.book;
% 进行磨平
diff_book = Book.calc_diff_of_books(book_std, book_com, rate);
% 进行开火一次性委托下单
diff_node = diff_book.positions.node;
len_node  = length(diff_node);

% 下单规则
% 1,volume > 0 开仓 volume < 0 平仓
% 2,longshortflag > 0 多头 longshortflag < 0 空头
for t = 1:len_node
    one_position  = diff_node(t);
    longShortFlag = one_position.longShortFlag;
    volume = one_position.volume;
    if volume == 0
        continue;
    end
    if volume > 0 && longShortFlag > 0 % 买开
        offset = '1';
        direc  = '1';
    elseif volume > 0 && longShortFlag < 0 % 卖开
        offset = '1';
        direc  = '2';
    elseif volume < 0 && longShortFlag > 0 % 卖平
        offset = '2';
        direc  = '2';
    elseif volume < 0 && longShortFlag < 0 % 买平
        offset = '2';
        direc  = '1';
    end
    opt = one_position.quote;
    com_stra.opt = opt;
    entrust_amount = round(abs(volume) * prct);
    % 委托下单
    opt.fillQuote;
    switch opposite
        case 1
            if direc == '1'
                px = opt.askP1;
            else
                px = opt.bidP1;
            end
        case 2
            if direc == '1'
                px = opt.askP2;
            else
                px = opt.bidP2;
            end
        case 3
            if direc == '1'
                px = opt.askP3;
            else
                px = opt.bidP3;
            end
        case 4
            if direc == '1'
                px = opt.askP4;
            else
                px = opt.bidP4;
            end
        case 5
            if direc == '1'
                px = opt.askP5;
            else
                px = opt.bidP5;
            end
    end
    % 如果价格出现了熔断情形
    if abs(px) < 1e-6
    else
        % 否则进行委托下单
        if entrust_amount
            com_stra.place_entrust_opt_apart(direc, entrust_amount, offset, px);
        end
    end
end









end