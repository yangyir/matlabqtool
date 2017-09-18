function trade_opt(obj, direc, volume, offset, px )
% 泛化的一个option下单函数，使用obj.opt指针，提供最宽泛的下单选项
% 其他花样下单函数可以调用这个函数
% ---------------------------------------------
% cg，20160320


%% 
if ~exist('direc', 'var'),    direc = '1';    end
if ~exist('volume','var'),  volume = 1; end
if ~exist('offset', 'var'),    offset = '1';    end

opt = obj.opt;

% 更新quoteOpt
% 用H5行情更新，需要init时启动H5行情
% 行情更新不太及时，好久取不到
while 1
    opt.fillQuoteH5;
    if opt.askQ1>0
        break;
    else
        disp('期权行情未接到');
        pause(1);
    end
end



%% 下单
ctr = obj.counter;
book = obj.book;

aimVolume   = volume;

while aimVolume > 0
    
    % 填充entrust, 1个
    e = Entrust;
    mktNo   = '1';
    stkCode = num2str(    opt.code );
    if ~exist('px', 'var')
        % 更新quoteOpt
        % 用H5行情更新，需要init时启动H5行情
        opt.fillQuoteH5;
        
        % 默认取对价
        if strcmp(direc, '1')
            px = opt.askP1;
        elseif strcmp(direc, '2')
            px = opt.bidP1;
        end
    end
    
    vo      = aimVolume;
    e.fillEntrust(mktNo, stkCode, direc, px, vo, offset);
    
    
    
    % TODO：验资验券
    
    % 下单
    % 下单后就立即把单子塞进book.pendingEntrusts
    ems.HSO32_place_optEntrust_and_fill_entrustNo(e, ctr);
    book.pendingEntrusts.push(e);

    
    % 查询3次，否则撤单 ( 两个单的情况复杂太多了）
    iter_wait = 1;
    while ~e.is_entrust_closed
        if iter_wait > 3
            ems.HSO32_cancel_optEntrust_and_fill_cancelNo(e, ctr);
            disp('e进行撤单');
        end
        pause(1);
        ems.HSO32_query_optEntrust_once_and_fill_dealInfo(e, ctr);
        iter_wait = iter_wait + 1;
    end
    
    % 如果到此，说明该entrust已close，需要记录
    book.sweep_pending_entrusts;
    
    % 同时，准备下一轮下单
    aimVolume = e.cancelVolume;
end


%% save
% 上面的while结束，算是一个order真正完成了，记录
% 不用再book里记录了，book对每一个entrust都做了记录
% 主要是要在策略逻辑里记录
if ~isempty( obj.bookfn )
    obj.book.toExcel(obj.bookfn);
else
    obj.book.toExcel();
end

end