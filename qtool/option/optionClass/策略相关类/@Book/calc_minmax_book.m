function [minBook, maxBook] = calc_minmax_book(bookleft, bookright, ratioleft, ratioright)
% ���������Ĳ�λ���ֵ����Сֵ
%����
% bookleft��Book
% bookright��Book
% ratioleft����� Ĭ��Ϊ1
% ratioright�ұ��� Ĭ��Ϊ1
%�������
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


% ���ڱ�������������Book
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

% �ȽϷ���:left
nodes     = bookleft_copy_.positions.node;
len_left  = length(nodes);
len_right = length(bookright_copy_.positions.node);
stock_code     = cell(len_left, 1);
longshort_flag = nan(len_left, 1);
min_amount     = nan(len_left, 1);
max_amount     = nan(len_left, 1);
stock_code_right     = cell(len_right, 1);
longshort_flag_right = nan(len_right, 1);
% right�����longShortFlag
for t = 1:len_right
    stock_code_right{t}     = bookright_copy_.positions.node(t).instrumentCode;
    longshort_flag_right(t) = bookright_copy_.positions.node(t).longShortFlag;
end
for t = 1:len_left
    instrumentCode = nodes(t).instrumentCode;
    longShortFlag  = nodes(t).longShortFlag;
    volume         = nodes(t).volume;
    % ������СBook
    maxBook.positions.node(end+1) = nodes(t).getCopy();
    minBook.positions.node(end+1) = nodes(t).getCopy();
    % �������ֵ
    stock_code{t}     = instrumentCode;
    longshort_flag(t) = longShortFlag;
    max_amount(t)     = volume;
    maxBook.positions.node(end).volume = volume;
    % ������Сֵ
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


% �ȽϷ���:right
% 1,left,right�й�ͬ�ʲ�,�����ͬ,ʹ��max��min����
% 2,left��,right��,max = left,min  = 0;
% 3,left��,right��,max = right,min = 0;
nodes = bookright_copy_.positions.node;
for t = 1:len_right
    instrumentCode = nodes(t).instrumentCode;
    longShortFlag  = nodes(t).longShortFlag;
    volume         = nodes(t).volume;
    
    % �жϵ�ǰ�Ĵ����Ƿ����
    idx_stock_code      = strcmp(instrumentCode, stock_code);
    stock_code_notexist = ~any(idx_stock_code);
    if stock_code_notexist
        stock_code     = [stock_code     ; instrumentCode];
        longshort_flag = [longshort_flag ; longShortFlag];
        max_amount     = [max_amount ; volume];
        min_amount     = [min_amount ; 0];
        % ������СBook
        maxBook.positions.node(end+1) = nodes(t).getCopy();
        minBook.positions.node(end+1) = nodes(t).getCopy();
        maxBook.positions.node(end).volume = volume;
        minBook.positions.node(end).volume = 0;
    else
        % Ѱ���Ƿ������ͬ�Ķ�ղ�λ
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
            % Ѱ�Ҷ�Ӧ�ʲ�������λ��
            asset_pos = idx_stock_code(find_idx);
            max_amount(asset_pos) = max([max_amount(asset_pos), volume]);
            min_amount(asset_pos) = min([min_amount(asset_pos), volume]);
            maxBook.positions.node(asset_pos).volume = max_amount(asset_pos);
            minBook.positions.node(asset_pos).volume = min_amount(asset_pos);
        end
    end

end








end