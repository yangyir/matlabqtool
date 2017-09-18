function [ bs ] = dhFutureBars( futID, start_date, end_date, slice_seconds)
% 取期货Bars, 运用DataHouse，只适用于期货
% 如果出错，尝试重启DH，再重启matlab
% dhFutureBars( futID, start_date, end_date, slice_seconds)
% 程刚， 20131210
% 程刚，140712；改了bugs

try 
    checklogin;  
catch e
    DH;
end

if ~exist('slice_seconds', 'var') 
    slice_seconds = 60;
end

% Replay用
slicetype   = int32(slice_seconds*100000);


% 名称：商品期货任意频率分时行情
% 公式：DH_Q_HF_FutureIrregSlice(期货合约代码,起始日期,截止日期,切片频率)
% 描述：返回任意频率商品期货分时数据
%  输出13列,分别为1 时间,2 前收盘,3 开盘价,4 最高价,5 最低价,6 收盘价,7 成交量,
% 8 成交额,9 均价,10 持仓量,11 持仓量变化,12 累计最高价,13 累计最低价
% output = DH_Q_HF_FutureIrregSlice('Cu1206','2012-03-01','2012-03-10',600)
mat = DH_Q_HF_FutureIrregSlice(futID,start_date,end_date,slice_seconds);


if isempty(mat) 
    disp('错误：no data');
    return;
end

if sum(sum(isnan(mat))) == size(mat,1)*size(mat,2)
    disp('错误：no data');
    return;
end


bs           = Bars;
bs.code      = futID;
bs.type      = 'future';
bs.slicetype = slicetype;
bs.time      = mat(:,1);
bs.open      = mat(:,3);
bs.high      = mat(:,4);
bs.low       = mat(:,5);
bs.close     = mat(:,6);
bs.amount    = mat(:,8);    %元
bs.volume    = mat(:,7);    %股
bs.vwap      = mat(:,9);
bs.openInt   = mat(:,11);

end

