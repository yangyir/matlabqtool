function [ diffBook, print_str ] = calc_diff_of_books(book_standard, book_compare, rate, printstyle)
% ��������Book�Ĳ�ֵ standard��׼���� compare�Ա����� rate:compare�����standard����,�������Book֮��
% �������: book_standard * rate - book_compare
%1,standard���е��ʲ�,compare��,����:standard * rate ���ͬstandard
%2,standard���е��ʲ�,compareӵ��,��շ�����ͬ,����֮�� ����:standard * rate - compare ���ͬstandard
%3,standard��ӵ�е��ʲ�,compareӵ��,����standard�ڴ�����compare��ͬ��ͷ�� ����:standard * rate ���ͬstandard
%4,standard��ӵ�е��ʲ�,compareӵ��,����compare������standard�ڲ�ͬ��ͷ�� ����:-compare ���ͬcompare
%5,compare���е��ʲ� ,standard�� , ����:-compare ���ͬcompare
%6,ĥƽBook֮��Ĳ�,��volume����,��volumeƽ��
% diffBook = calc_diff_of_books(obj, standard, compare, rate)
% DEMO
% [ diffBook, print_str ] = calc_diff_of_books(book_standard, book_compare, rate, printstyle);
% ���Ʒ� 20170322


if ~exist('rate', 'var')
    rate = 1;
end
assert(rate > 0)
if ~exist('printstyle', 'var')
    printstyle = 'no';
end
assert(ismember(printstyle, {'all','diff','no'}))


% ����һ����Book
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
    stock_standard{t}     = node_standard(t).instrumentCode; % ����
    direction_standard(t) = node_standard(t).longShortFlag;  % ��շ���
end
for t = 1:len_node_compare
    stock_compare{t}     = node_compare(t).instrumentCode; % ����
    direction_compare(t) = node_compare(t).longShortFlag;  % ��շ���
end

%% ��������Book֮��

% 1,����standardӵ�е��ʲ������compare���бȽ�
% ����,ԭʼ�ı���
stock_standard_copy = stock_standard;
% ���ս�������
print_str = sprintf('�ʲ�����\t�ʲ�����\t���\tbook_std*%.2f\tbook_cmp\tdiff', rate);
while true
    if isempty(stock_standard_copy),break;end; % ��ֹ����
    std_stockcode = stock_standard_copy{1};
    % compare�˻��Ƿ��и��ʲ����
    cmp_idx = find(strcmp(std_stockcode, stock_compare));
    % standard�˻��Ƿ����ظ��ʲ����
    std_idx = find(strcmp(std_stockcode, stock_standard));
    
    if isempty(cmp_idx)
        % ����1:standard���е��ʲ�,compare��,����:standard * rate ���ͬstandard
        for t = 1:length(std_idx)
            %--- ����
            std_node = node_standard(std_idx(t));
            diff_node = std_node.getCopy();
            diff_node.volume = round(diff_node.volume * rate);
            diffBook.positions.node(end + 1) = diff_node;
            %--- ���
            export_code_ = diff_node.instrumentCode;
            export_name_ = diff_node.instrumentName;
            if diff_node.longShortFlag > 0,export_ls_ = '��';
            else export_ls_ = '��'; end;
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
        
        % ����2��standard���е��ʲ�,compareӵ��,��շ�����ͬ,����֮�� ����:standard * rate - compare ���ͬstandard
        for t = 1:length(mutual_direction)
            %--- ����
            std_node     = std_nodes(mutual_direction(t) == std_direction);
            compare_node = cmp_nodes(mutual_direction(t) == cmp_direction);
            diff_node = std_node.getCopy();
            diff_node.volume = round(std_node.volume * rate) - compare_node.volume;
            diffBook.positions.node(end + 1) = diff_node;
            %--- ���
            export_code_ = diff_node.instrumentCode;
            export_name_ = diff_node.instrumentName;
            if diff_node.longShortFlag > 0,export_ls_ = '��';
            else export_ls_ = '��'; end;
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
        
        % ����3:standard��ӵ�е��ʲ�,compareӵ��,����standard�ڴ�����compare��ͬ��ͷ�� ����:standard * rate ���ͬstandard
        diff_std_direction = setdiff(std_direction, cmp_direction);
        if isempty(diff_std_direction)
        else
            %--- ����
            std_node  = std_nodes(diff_std_direction == std_direction);
            diff_node = std_node.getCopy();
            diff_node.volume = round(diff_node.volume * rate);
            diffBook.positions.node(end + 1) = diff_node;
            %--- ���
            export_code_ = diff_node.instrumentCode;
            export_name_ = diff_node.instrumentName;
            if diff_node.longShortFlag > 0,export_ls_ = '��';
            else export_ls_ = '��'; end;
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
        
        % ����4:standard��ӵ�е��ʲ�,compareӵ��,����compare������standard�ڲ�ͬ��ͷ�� ����:-compare ���ͬcompare
        diff_cmp_direction = setdiff(cmp_direction, std_direction);
        if isempty(diff_cmp_direction)
        else
            %--- ����
            compare_node = cmp_nodes(diff_cmp_direction == cmp_direction);
            diff_node    = compare_node.getCopy();
            diff_node.volume = -diff_node.volume;
            diffBook.positions.node(end + 1) = diff_node;
            %--- ���
            export_code_ = diff_node.instrumentCode;
            export_name_ = diff_node.instrumentName;
            if diff_node.longShortFlag > 0,export_ls_ = '��';
            else export_ls_ = '��'; end;
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
    
    % ����ǰ���ʲ�ɾ��
    stock_standard_copy(strcmp(std_stockcode, stock_standard_copy)) = [];
end


% ����5��compare���е��ʲ� ,standard�� , ����:-compare ���ͬcompare
stockCodes = setdiff(stock_compare, stock_standard);
if isempty(stockCodes)
else
    for t = 1:length(stockCodes)
        instrumentCode = stockCodes{t};
        idx = find(strcmp(instrumentCode, stock_compare));
        for n = 1:length(idx)
            %--- ����
            diff_node = node_compare(idx(n)).getCopy();
            diff_node.volume = -diff_node.volume;
            diffBook.positions.node(end + 1) = diff_node;
            %--- ���
            export_code_ = diff_node.instrumentCode;
            export_name_ = diff_node.instrumentName;
            if diff_node.longShortFlag > 0,export_ls_ = '��';
            else export_ls_ = '��'; end;
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