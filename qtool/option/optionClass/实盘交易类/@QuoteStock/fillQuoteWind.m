
function self = fillQuoteWind( self , w )
% 取 单只股票 的实时行情数据， 填入到该期权的prof中
% --------------------------------
% 朱江，基于Wind获取股票的实时行情的数据，20160317

% 首先判断是否为wind的matlab的接口
if ~isobject( w )
    return;
end


code = self.code;
if isfloat( code )
    code = num2str( code );
end

if isempty( strfind( code , '.SH' ) )
    code = sprintf( '%s.SH' , code );
end

% 获取当时的行情
[ S ] = w.wsq( underCode,'rt_last');

self.S = S;

[ w_data ] = w.wsq( code ,'rt_bid1,rt_ask1,rt_vol,rt_last,rt_asize1,rt_bsize1,rt_pre_settle');
bid  = w_data(1);
ask  = w_data(2);
vol  = w_data(3);
last = w_data(4);
askQ = w_data(5);
bidQ = w_data(6);
preSettle = w_data(7);

% 期权最新价
self.last = last;
% 期权累计成交量增量
self.diffVolume = vol - self.volume;
% 期权累计成交量
self.volume = vol;
% 申买价1
self.bidP1  = bid;
% 申买量1
self.bidQ1  = bidQ;	
% 申卖价1	
self.askP1  = ask;
% 申卖量1	
self.askQ1  = askQ;
% pre_settle
self.preSettle = preSettle;

end




