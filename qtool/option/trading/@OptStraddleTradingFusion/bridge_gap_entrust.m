function bridge_gap_entrust(std_stra, com_stra, prct, rate, opposite)
% ������StraddleTrading����ĥƽһ����ί�к���
% bridge_books_gap_entrust(obj, std_straddle_name, prct, proportion, pposite)
%Import
% std_stra:��׼��Straddle����
% com_stra:�Աȵ�Straddle����
% prct:�ֺϵİٷֱ�
% rate��com�����std�ı���
% opposite �µ����ּ۸�λ
% ���Ʒ�


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

%% һ���Կ����µ�

book_std = std_stra.book;
book_com = com_stra.book;
% ����ĥƽ
diff_book = Book.calc_diff_of_books(book_std, book_com, rate);
% ���п���һ����ί���µ�
diff_node = diff_book.positions.node;
len_node  = length(diff_node);

% �µ�����
% 1,volume > 0 ���� volume < 0 ƽ��
% 2,longshortflag > 0 ��ͷ longshortflag < 0 ��ͷ
for t = 1:len_node
    one_position  = diff_node(t);
    longShortFlag = one_position.longShortFlag;
    volume = one_position.volume;
    if volume == 0
        continue;
    end
    if volume > 0 && longShortFlag > 0 % ��
        offset = '1';
        direc  = '1';
    elseif volume > 0 && longShortFlag < 0 % ����
        offset = '1';
        direc  = '2';
    elseif volume < 0 && longShortFlag > 0 % ��ƽ
        offset = '2';
        direc  = '2';
    elseif volume < 0 && longShortFlag < 0 % ��ƽ
        offset = '2';
        direc  = '1';
    end
    opt = one_position.quote;
    com_stra.opt = opt;
    entrust_amount = round(abs(volume) * prct);
    % ί���µ�
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
    % ����۸�������۶�����
    if abs(px) < 1e-6
    else
        % �������ί���µ�
        if entrust_amount
            com_stra.place_entrust_opt_apart(direc, entrust_amount, offset, px);
        end
    end
end









end