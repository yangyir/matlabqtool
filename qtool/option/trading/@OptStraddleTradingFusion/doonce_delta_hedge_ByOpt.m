function doonce_delta_hedge_ByOpt(self, monthsel, one_amount, call_putflag, threshold, opposite)
% ������Ȩ�ĶԳ庯��[һ�����µ�����]
% �������delta
%�������
% monthsel ѡ�е��·� ����[1] ��һ����[2] ���¸���[3] ��Զ��[4] �Դ�����
% one_amount ������Ȩ��ί������ ����ѡ�����10��
% call_putflag ʹ��Call�Գ廹��Put���жԳ�
% threshold ��ȨStrike����ֵ  (2.25 Callѡ��KС�ڵ���2.25����Ȩƽ���µ� Putѡ��K���ڵ���2.25����Ȩƽ���µ�)
% opposite ���ն��ּ����۸���в��� 1 | 2 | 3 | 4 | 5
%Demo
% stra.doonce_delta_hedge_ByOpt(2, 10, 'Put', 2.3, 1) % ���Զ�µĲ���
% stra.doonce_delta_hedge_ByOpt(3, 10, 'Call', 2.25, 2)
%���Ʒ� 20161222 VERSION 0


%% ������Ԥ��

if ~exist('opposite', 'var')
    opposite = 1;
end

m2tkCallQuote = self.m2tkCallQuote;
m2tkPutQuote  = self.m2tkPutQuote;
yProps = m2tkPutQuote.yProps;
assert(ismember(monthsel, 1:length(yProps)))   % �·ݵ�ѡ��

assert(one_amount > 0)                         % ί����������0
one_amount = round(one_amount);
assert(ismember(call_putflag, {'call','put','Call','Put'})) % ʹ��call������put���жԳ�
assert(threshold > 0);           % �µ���Strike��ֵ
assert(ismember(opposite, 1:5)); % ���ն��ּ۸�����µ�


%% ��ȡ��Ҫ�µ���Strike

xProps = m2tkCallQuote.xProps;
if ismember(call_putflag, {'call', 'Call'})  % ���Call���жԳ��µ�
    find_entrust_idx = xProps <= threshold;
else % ���Put���жԳ��µ�
    find_entrust_idx = xProps >= threshold;
end

% ������ǿյ��򷵻�
if any(find_entrust_idx)
else
    warning('��ֵд�����,�޷������µ�')
    return;
end
find_entrust_idx = find(find_entrust_idx);


%% ����ί���µ�����

if ismember(call_putflag, {'call', 'Call'})
    % ���ѡ�е�Call����ί���µ�
    for opt_t = 1:length(find_entrust_idx)
        opt = m2tkCallQuote.data(monthsel, find_entrust_idx(opt_t));
        if opt.is_obj_valid
        else
            continue;
        end
        self.opt = opt;
        % ����ί���µ�
        direc  = '1';
        offset = '1';
        opt.fillQuote;
        switch opposite
            case 1
                entrust_price = opt.askP1;
            case 2
                entrust_price = opt.askP2;
            case 3
                entrust_price = opt.askP3;
            case 4
                entrust_price = opt.askP4;
            case 5
                entrust_price = opt.askP5;
        end
        if abs(entrust_price) < 1e-6
            warning('[%s]��Ȩί�м۸�Ϊ0,�޷�ί���µ�', opt.code)
            continue;
        end
        self.place_entrust_opt_apart(direc, one_amount, offset, entrust_price);
    end
else
    % ���ѡ�е�Put����ί���µ�
    for opt_t = 1:length(find_entrust_idx)
        opt = m2tkPutQuote.data(monthsel, find_entrust_idx(opt_t));
        if opt.is_obj_valid
        else
            continue;
        end
        self.opt = opt;
        % ����ί���µ�
        % ����ί���µ�
        direc  = '1';
        offset = '1';
        opt.fillQuote;
        switch opposite
            case 1
                entrust_price = opt.askP1;
            case 2
                entrust_price = opt.askP2;
            case 3
                entrust_price = opt.askP3;
            case 4
                entrust_price = opt.askP4;
            case 5
                entrust_price = opt.askP5;
        end
        if abs(entrust_price) < 1e-6
            warning('[%s]��Ȩί�м۸�Ϊ0,�޷�ί���µ�', opt.code)
            continue;
        end
        self.place_entrust_opt_apart(direc, one_amount, offset, entrust_price);
    end
end












end