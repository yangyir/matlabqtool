function [ bs ] = dhOptionBars( optID, start_date, end_date, slice_seconds)
% 取option bars, 需要利用DataHouse，且只能取option（不能取stock, 期货）
% [ bs ] = dhOptionBars( secID, start_date, end_date, slice_seconds, fuquan )
% 如果出错，尝试重启DH，再重启matlab
% 程刚， 20151219


%% pre
if ~exist('slice_seconds', 'var') 
    slice_seconds = 60;
end


try 
    checklogin;  
catch e
    DH;
end

%% main
bs = Bars;
slicetype   = int32(slice_seconds*100000);
bs.slicetype = slicetype;


% 名称：期权任意频率分时行情
% 公式：DH_Q_HF_OptionIrregSlice(证券代码,起始日期,截止日期,切片频率)
% 描述：返回任意频率期权分时数据 
%  输出13列,分别为1 时间,2 前收盘,3 开盘价,4 最高价,5 最低价,6 收盘价,7 成交量,
% 8 成交额,9 均价,10 持仓量变化,11 持仓量,12 累计最高价,13 累计最低价 
% output = DH_Q_HF_OptionIrregSlice('90000021.SH','2014-03-04','2014-03-10',600)
mat = DH_Q_HF_OptionIrregSlice(optID, start_date, end_date, slice_seconds);


if isempty(mat) 
    error('错误：no data');
%     return;
end


if sum(sum(isnan(mat))) == size(mat,1)*size(mat,2)
    disp('错误：no data');
    return;
end

bs.code     = optID;
bs.type     = 'option';
bs.time     = mat(:,1);
bs.open     = mat(:,3);
bs.high     = mat(:,4);
bs.low      = mat(:,5);
bs.close    = mat(:,6);
bs.volume   = mat(:,7);  %
bs.amount   = mat(:,8);
bs.vwap     = mat(:, 9);
bs.openInt  = mat(:, 11);




end

