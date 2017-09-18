
function self = fillQuoteWind( self , w )
% 取 单只期权 的实时行情数据， 填入到该期权的prof中
% --------------------------------
% 吴云峰，基于Wind获取期权的试试行情的数据，20160218
% 吴云峰，增加了一个变量，preClose为了计算保证金的比例

% 首先判断是否为wind的matlab的接口
if ~isobject( w )
    return;
end

% 首先获取期权的标的Last价格
underCode = self.underCode;
if isfloat( underCode )
    underCode = num2str( underCode );
end
if isempty( strfind( underCode , '.SH' ) )
    underCode = sprintf( '%s.SH' , underCode );
end

code = self.code;
if isfloat( code )
    code = num2str( code );
end

if isempty( strfind( code , '.SH' ) )
    code = sprintf( '%s.SH' , code );
end

% 获取当时的行情( last和收盘价 )
[ S,~,~,~,w_wsq_errorid ] = w.wsq( underCode,'rt_last,rt_pre_close');

if w_wsq_errorid == 0
    self.S = S(1);
    self.etfpreClose = S(2);
end

[ w_data,~,~,~,w_wsq_errorid ] = w.wsq( code ,...
    'rt_bid1,rt_ask1,rt_vol,rt_last,rt_asize1,rt_bsize1,rt_pre_settle,rt_settle');

if ~any( w_wsq_errorid )  

    bid  = w_data(1);
    ask  = w_data(2);
    vol  = w_data(3);
    last = w_data(4);
    askQ = w_data(5);
    bidQ = w_data(6);
    preSettle = w_data(7);
    settle = w_data(8);

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
    % settle
    self.settle = settle;

end




end


