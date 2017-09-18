function [minBook, maxBook] = calc_minmax_book(bookleft, bookright, ratioleft, ratioright)
% 计算两本的仓位最大值和最小值
%输入
% bookleft左Book
% bookright右Book
% ratioleft左比率 默认为1
% ratioright右比率 默认为1
%计算规则
% minBook = min(bookleft * ratioleft, bookright * ratioright)
% maxBook = max(bookleft * ratioleft, bookright * ratioright)
% [minBook, maxBook] = Book.calc_minmax_book(bookleft, bookright, ratioleft, ratioright)
% wuyunfeng 20170406 version 1.0
% wuyunfeng 20170522 version 1.1


if ~exist('ratioleft', 'var')
    ratioleft = 1;
end
if ~exist('ratioright', 'var')
    ratioright = 1;
end


% 基于比例构造两本新Book
bookleft_copy_  = Book;
bookright_copy_ = Book;
bookleft_copy_.positions.node(1, length(bookleft.positions.node))   = Position;
bookright_copy_.positions.node(1, length(bookright.positions.node)) = Position;
for t = 1:length(bookleft.positions.node)
    bookleft_copy_.positions.node(t) = bookleft.positions.node(t).getCopy();
    v = bookleft_copy_.positions.node(t).volume;
    bookleft_copy_.positions.node(t).volume = round(v * ratioleft);
end
for t = 1:length(bookright.positions.node)
    bookright_copy_.positions.node(t) = bookright.positions.node(t).getCopy();
    v = bookright_copy_.positions.node(t).volume;
    bookright_copy_.positions.node(t).volume = round(v * ratioright);
end


maxBook = Book;
minBook = Book;
maxBook.positions.node(1) = [];
minBook.positions.node(1) = [];

% 比较分析:left
nodes     = bookleft_copy_.positions.node;
len_left  = length(nodes);
len_right = length(bookright_copy_.positions.node);
stock_code     = cell(len_left, 1);
longshort_flag = nan(len_left, 1);
min_amount     = nan(len_left, 1);
max_amount     = nan(len_left, 1);
stock_code_right     = cell(len_right, 1);
longshort_flag_right = nan(len_right, 1);
% right代码和longShortFlag
for t = 1:len_right
    stock_code_right{t}     = bookright_copy_.positions.node(t).instrumentCode;
    longshort_flag_right(t) = bookright_copy_.positions.node(t).longShortFlag;
end
for t = 1:len_left
    instrumentCode = nodes(t).instrumentCode;
    longShortFlag  = nodes(t).longShortFlag;
    volume         = nodes(t).volume;
    % 最大和最小Book
    maxBook.positions.node(end+1) = nodes(t).getCopy();
    minBook.positions.node(end+1) = nodes(t).getCopy();
    % 设置最大值
    stock_code{t}     = instrumentCode;
    longshort_flag(t) = longShortFlag;
    max_amount(t)     = volume;
    maxBook.positions.node(end).volume = volume;
    % 设置最小值
    left_cmp_right    = strcmp(instrumentCode, stock_code_right);
    if any(left_cmp_right)
        right_lsflag = longshort_flag_right(left_cmp_right);
        if ismember(longShortFlag, right_lsflag)
            min_amount(t) = volume;
            minBook.positions.node(end).volume = volume;
        else
            min_amount(t) = 0;
            minBook.positions.node(end).volume = 0;
        end
    else
        min_amount(t) = 0;
        minBook.positions.node(end).volume = 0;
    end
end


% 比较分析:right
% 1,left,right有共同资产,多空相同,使用max和min计算
% 2,left有,right无,max = left,min  = 0;
% 3,left无,right有,max = right,min = 0;
nodes = bookright_copy_.positions.node;
for t = 1:len_right
    instrumentCode = nodes(t).instrumentCode;
    longShortFlag  = nodes(t).longShortFlag;
    volume         = nodes(t).volume;
    
    % 判断当前的代码是否存在
    idx_stock_code      = strcmp(instrumentCode, stock_code);
    stock_code_notexist = ~any(idx_stock_code);
    if stock_code_notexist
        stock_code     = [stock_code     ; instrumentCode];
        longshort_flag = [longshort_flag ; longShortFlag];
        max_amount     = [max_amount ; volume];
        min_amount     = [min_amount ; 0];
        % 最大和最小Book
        maxBook.positions.node(end+1) = nodes(t).getCopy();
        minBook.positions.node(end+1) = nodes(t).getCopy();
        maxBook.positions.node(end).volume = volume;
        minBook.positions.node(end).volume = 0;
    else
        % 寻找是否具有相同的多空仓位
        idx_stock_code = find(idx_stock_code);
        curr_lsflag    = longshort_flag(idx_stock_code);
        find_idx       = find(longShortFlag == curr_lsflag);
        if isempty(find_idx)
            stock_code     = [stock_code     ; instrumentCode];
            longshort_flag = [longshort_flag ; longShortFlag];
            max_amount     = [max_amount ; volume];
            min_amount     = [min_amount ; 0];
            maxBook.positions.node(end+1) = nodes(t).getCopy();
            minBook.positions.node(end+1) = nodes(t).getCopy();
            maxBook.positions.node(end).volume = volume;
            minBook.positions.node(end).volume = 0;
        else
            % 寻找对应资产的所在位置
            asset_pos = idx_stock_code(find_idx);
            max_amount(asset_pos) = max([max_amount(asset_pos), volume]);
            min_amount(asset_pos) = min([min_amount(asset_pos), volume]);
            maxBook.positions.node(asset_pos).volume = max_amount(asset_pos);
            minBook.positions.node(asset_pos).volume = min_amount(asset_pos);
        end
    end

end








end