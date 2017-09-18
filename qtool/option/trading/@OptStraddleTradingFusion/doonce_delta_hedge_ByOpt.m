function doonce_delta_hedge_ByOpt(self, monthsel, one_amount, call_putflag, threshold, opposite)
% 基于期权的对冲函数[一次性下单函数]
% 首先输出delta
%输入参数
% monthsel 选中的月份 当月[1] 下一个月[2] 下下个月[3] 最远月[4] 以此类推
% one_amount 单张期权的委托数量 可以选择大于10张
% call_putflag 使用Call对冲还是Put进行对冲
% threshold 期权Strike的阈值  (2.25 Call选择K小于等于2.25的期权平均下单 Put选择K大于等于2.25的期权平均下单)
% opposite 按照对手几档价格进行操作 1 | 2 | 3 | 4 | 5
%Demo
% stra.doonce_delta_hedge_ByOpt(2, 10, 'Put', 2.3, 1) % 针对远月的操作
% stra.doonce_delta_hedge_ByOpt(3, 10, 'Call', 2.25, 2)
%吴云峰 20161222 VERSION 0


%% 参数的预判

if ~exist('opposite', 'var')
    opposite = 1;
end

m2tkCallQuote = self.m2tkCallQuote;
m2tkPutQuote  = self.m2tkPutQuote;
yProps = m2tkPutQuote.yProps;
assert(ismember(monthsel, 1:length(yProps)))   % 月份的选择

assert(one_amount > 0)                         % 委托数量大于0
one_amount = round(one_amount);
assert(ismember(call_putflag, {'call','put','Call','Put'})) % 使用call或者是put进行对冲
assert(threshold > 0);           % 下单的Strike阈值
assert(ismember(opposite, 1:5)); % 按照对手价格进行下单


%% 获取需要下单的Strike

xProps = m2tkCallQuote.xProps;
if ismember(call_putflag, {'call', 'Call'})  % 针对Call进行对冲下单
    find_entrust_idx = xProps <= threshold;
else % 针对Put进行对冲下单
    find_entrust_idx = xProps >= threshold;
end

% 如果均是空的则返回
if any(find_entrust_idx)
else
    warning('阈值写入错误,无法进行下单')
    return;
end
find_entrust_idx = find(find_entrust_idx);


%% 进行委托下单操作

if ismember(call_putflag, {'call', 'Call'})
    % 针对选中的Call进行委托下单
    for opt_t = 1:length(find_entrust_idx)
        opt = m2tkCallQuote.data(monthsel, find_entrust_idx(opt_t));
        if opt.is_obj_valid
        else
            continue;
        end
        self.opt = opt;
        % 进行委托下单
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
            warning('[%s]期权委托价格为0,无法委托下单', opt.code)
            continue;
        end
        self.place_entrust_opt_apart(direc, one_amount, offset, entrust_price);
    end
else
    % 针对选中的Put进行委托下单
    for opt_t = 1:length(find_entrust_idx)
        opt = m2tkPutQuote.data(monthsel, find_entrust_idx(opt_t));
        if opt.is_obj_valid
        else
            continue;
        end
        self.opt = opt;
        % 进行委托下单
        % 进行委托下单
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
            warning('[%s]期权委托价格为0,无法委托下单', opt.code)
            continue;
        end
        self.place_entrust_opt_apart(direc, one_amount, offset, entrust_price);
    end
end












end