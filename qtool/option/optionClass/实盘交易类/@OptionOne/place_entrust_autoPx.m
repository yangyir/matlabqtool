function  [e] = place_entrust_autoPx( obj, direc, volume, offset, pxType)
% 用常见的价格方式下单
% [e] = place_entrust_autoPx( obj, direc, volume, offset, pxType)
% pxType: 对价oppo（默认），限价持平atpar，last价，mid价
% 让1tick?
% 让百1?
%------------------------------------


%% pre
if ~exist('pxType', 'var')
    pxType = 'oppo';
end
    
% 取得当前价格
opt = obj.quote;
% 更新quoteOpt
% 用H5行情更新，需要init时启动H5行情
% 行情更新不太及时，好久取不到
while 1
    opt.fillQuote;
    if opt.askQ1>0
        break;
    else
        disp('期权行情未接到');
        pause(1);
    end
end


%% main
bid = opt.bidP1;
ask = opt.askP1;
last = opt.last;
mid = (ask+bid)/2;

switch direc
    case {'1', 1}  % 买
        switch pxType
            case{'oppo'}
                px = ask;
            case{'atpar'}
                px = bid;
            case{'last'} 
                px = last;
            case{'mid'}
                px = ceil(10000*(ask+bid)/2)/10000;
        end
        
    case {'2', -1}
         switch pxType
            case{'oppo'}
                px = bid;
            case{'atpar'}
                px = ask;
            case{'last'} 
                px = last;
            case{'mid'}
                px = floor(10000*(ask+bid)/2)/10000;
         end
        
end


e = obj.place_entrust_opt( direc, volume, offset, px );


end

