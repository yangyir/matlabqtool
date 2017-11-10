function [ diffBook, print_str ] = calc_diff_of_books(book_standard, book_compare, rate, printstyle)
% 计算两本Book的差值 standard基准名称 compare对比名称 rate:compare相对于standard比率,输出两本Book之差
% 计算规则: book_standard * rate - book_compare
%1,standard内有的资产,compare无,数量:standard * rate 多空同standard
%2,standard内有的资产,compare拥有,多空方向相同,计算之差 数量:standard * rate - compare 多空同standard
%3,standard内拥有的资产,compare拥有,但是standard内存在与compare不同的头寸 数量:standard * rate 多空同standard
%4,standard内拥有的资产,compare拥有,但是compare存在与standard内不同的头寸 数量:-compare 多空同compare
%5,compare内有的资产 ,standard无 , 数量:-compare 多空同compare
%6,磨平Book之间的差,正volume开仓,负volume平仓
% diffBook = calc_diff_of_books(obj, standard, compare, rate)
% DEMO
% [ diffBook, print_str ] = calc_diff_of_books(book_standard, book_compare, rate, printstyle);
% 吴云峰 20170322


if ~exist('rate', 'var')
    rate = 1;
end
assert(rate > 0)
if ~exist('printstyle', 'var')
    printstyle = 'no';
end
assert(ismember(printstyle, {'all','diff','no'}))


% 构建一本新Book
diffBook = Book;
diffBook.positions.node(1) = [];

% Position
node_standard = book_standard.positions.node;
node_compare  = book_compare.positions.node;

len_node_standard = length(node_standard);
len_node_compare  = length(node_compare);
% Stockcode
stock_standard = cell(1, len_node_standard);
stock_compare  = cell(1, len_node_compare);
% direction
direction_standard = nan(1, len_node_standard);
direction_compare  = nan(1, len_node_compare);

for t = 1:len_node_standard
    stock_standard{t}     = node_standard(t).instrumentCode; % 代码
    direction_standard(t) = node_standard(t).longShortFlag;  % 多空方向
end
for t = 1:len_node_compare
    stock_compare{t}     = node_compare(t).instrumentCode; % 代码
    direction_compare(t) = node_compare(t).longShortFlag;  % 多空方向
end

%% 计算两本Book之差

% 1,基于standard拥有的资产标的与compare进行比较
% 复制,原始的保留
stock_standard_copy = stock_standard;
% 最终结果的输出
print_str = sprintf('资产代码\t资产名称\t多空\tbook_std*%.2f\tbook_cmp\tdiff', rate);
while true
    if isempty(stock_standard_copy),break;end; % 终止条件
    std_stockcode = stock_standard_copy{1};
    % compare账户是否有该资产标的
    cmp_idx = find(strcmp(std_stockcode, stock_compare));
    % standard账户是否有重复资产标的
    std_idx = find(strcmp(std_stockcode, stock_standard));
    
    if isempty(cmp_idx)
        % 情形1:standard内有的资产,compare无,数量:standard * rate 多空同standard
        for t = 1:length(std_idx)
            %--- 计算
            std_node = node_standard(std_idx(t));
            diff_node = std_node.getCopy();
            diff_node.volume = round(diff_node.volume * rate);
            diffBook.positions.node(end + 1) = diff_node;
            %--- 输出
            export_code_ = diff_node.instrumentCode;
            export_name_ = diff_node.instrumentName;
            if diff_node.longShortFlag > 0,export_ls_ = '多';
            else export_ls_ = '空'; end;
            export_stdv_  = round(std_node.volume * rate);
            export_cmpv_  = 0;
            export_diffv_ = export_stdv_ - export_cmpv_;
            if strcmp(printstyle, 'all')
                print_str = sprintf('%s\n%s\t%s\t%s\t%d\t%d\t%d', print_str, ...
                    export_code_, export_name_, export_ls_, export_stdv_, export_cmpv_, export_diffv_);
            elseif strcmp(printstyle, 'diff')
                if export_diffv_~= 0
                    print_str = sprintf('%s\n%s\t%s\t%s\t%d\t%d\t%d', print_str, ...
                        export_code_, export_name_, export_ls_, export_stdv_, export_cmpv_, export_diffv_);
                end
            end
        end
    else
        std_direction = direction_standard(std_idx);
        cmp_direction = direction_compare(cmp_idx);
        std_nodes = node_standard(std_idx);
        cmp_nodes = node_compare(cmp_idx);
        mutual_direction = intersect(std_direction, cmp_direction);
        
        % 情形2：standard内有的资产,compare拥有,多空方向相同,计算之差 数量:standard * rate - compare 多空同standard
        for t = 1:length(mutual_direction)
            %--- 计算
            std_node     = std_nodes(mutual_direction(t) == std_direction);
            compare_node = cmp_nodes(mutual_direction(t) == cmp_direction);
            diff_node = std_node.getCopy();
            diff_node.volume = round(std_node.volume * rate) - compare_node.volume;
            diffBook.positions.node(end + 1) = diff_node;
            %--- 输出
            export_code_ = diff_node.instrumentCode;
            export_name_ = diff_node.instrumentName;
            if diff_node.longShortFlag > 0,export_ls_ = '多';
            else export_ls_ = '空'; end;
            export_stdv_  = round(std_node.volume * rate);
            export_cmpv_  = compare_node.volume;
            export_diffv_ = export_stdv_ - export_cmpv_;
            if strcmp(printstyle, 'all')
                print_str = sprintf('%s\n%s\t%s\t%s\t%d\t%d\t%d', print_str, ...
                    export_code_, export_name_, export_ls_, export_stdv_, export_cmpv_, export_diffv_);
            elseif strcmp(printstyle, 'diff')
                if export_diffv_~= 0
                    print_str = sprintf('%s\n%s\t%s\t%s\t%d\t%d\t%d', print_str, ...
                        export_code_, export_name_, export_ls_, export_stdv_, export_cmpv_, export_diffv_);
                end
            end
        end
        
        % 情形3:standard内拥有的资产,compare拥有,但是standard内存在与compare不同的头寸 数量:standard * rate 多空同standard
        diff_std_direction = setdiff(std_direction, cmp_direction);
        if isempty(diff_std_direction)
        else
            %--- 计算
            std_node  = std_nodes(diff_std_direction == std_direction);
            diff_node = std_node.getCopy();
            diff_node.volume = round(diff_node.volume * rate);
            diffBook.positions.node(end + 1) = diff_node;
            %--- 输出
            export_code_ = diff_node.instrumentCode;
            export_name_ = diff_node.instrumentName;
            if diff_node.longShortFlag > 0,export_ls_ = '多';
            else export_ls_ = '空'; end;
            export_stdv_  = round(std_node.volume * rate);
            export_cmpv_  = 0;
            export_diffv_ = export_stdv_ - export_cmpv_;
            if strcmp(printstyle, 'all')
                print_str = sprintf('%s\n%s\t%s\t%s\t%d\t%d\t%d', print_str, ...
                    export_code_, export_name_, export_ls_, export_stdv_, export_cmpv_, export_diffv_);
            elseif strcmp(printstyle, 'diff')
                if export_diffv_~= 0
                    print_str = sprintf('%s\n%s\t%s\t%s\t%d\t%d\t%d', print_str, ...
                        export_code_, export_name_, export_ls_, export_stdv_, export_cmpv_, export_diffv_);
                end
            end
        end
        
        % 情形4:standard内拥有的资产,compare拥有,但是compare存在与standard内不同的头寸 数量:-compare 多空同compare
        diff_cmp_direction = setdiff(cmp_direction, std_direction);
        if isempty(diff_cmp_direction)
        else
            %--- 计算
            compare_node = cmp_nodes(diff_cmp_direction == cmp_direction);
            diff_node    = compare_node.getCopy();
            diff_node.volume = -diff_node.volume;
            diffBook.positions.node(end + 1) = diff_node;
            %--- 输出
            export_code_ = diff_node.instrumentCode;
            export_name_ = diff_node.instrumentName;
            if diff_node.longShortFlag > 0,export_ls_ = '多';
            else export_ls_ = '空'; end;
            export_stdv_  = 0;
            export_cmpv_  = compare_node.volume;
            export_diffv_ = export_stdv_ - export_cmpv_;
            if strcmp(printstyle, 'all')
                print_str = sprintf('%s\n%s\t%s\t%s\t%d\t%d\t%d', print_str, ...
                    export_code_, export_name_, export_ls_, export_stdv_, export_cmpv_, export_diffv_);
            elseif strcmp(printstyle, 'diff')
                if export_diffv_~= 0
                    print_str = sprintf('%s\n%s\t%s\t%s\t%d\t%d\t%d', print_str, ...
                        export_code_, export_name_, export_ls_, export_stdv_, export_cmpv_, export_diffv_);
                end
            end
        end
    end
    
    % 将当前的资产删除
    stock_standard_copy(strcmp(std_stockcode, stock_standard_copy)) = [];
end


% 情形5：compare内有的资产 ,standard无 , 数量:-compare 多空同compare
stockCodes = setdiff(stock_compare, stock_standard);
if isempty(stockCodes)
else
    for t = 1:length(stockCodes)
        instrumentCode = stockCodes{t};
        idx = find(strcmp(instrumentCode, stock_compare));
        for n = 1:length(idx)
            %--- 计算
            diff_node = node_compare(idx(n)).getCopy();
            diff_node.volume = -diff_node.volume;
            diffBook.positions.node(end + 1) = diff_node;
            %--- 输出
            export_code_ = diff_node.instrumentCode;
            export_name_ = diff_node.instrumentName;
            if diff_node.longShortFlag > 0,export_ls_ = '多';
            else export_ls_ = '空'; end;
            export_stdv_  = 0;
            export_cmpv_  = node_compare(idx(n)).volume;
            export_diffv_ = export_stdv_ - export_cmpv_;
            if strcmp(printstyle, 'all')
                print_str = sprintf('%s\n%s\t%s\t%s\t%d\t%d\t%d', print_str, ...
                    export_code_, export_name_, export_ls_, export_stdv_, export_cmpv_, export_diffv_);
            elseif strcmp(printstyle, 'diff')
                if export_diffv_~= 0
                    print_str = sprintf('%s\n%s\t%s\t%s\t%d\t%d\t%d', print_str, ...
                        export_code_, export_name_, export_ls_, export_stdv_, export_cmpv_, export_diffv_);
                end
            end
        end
    end
end








end