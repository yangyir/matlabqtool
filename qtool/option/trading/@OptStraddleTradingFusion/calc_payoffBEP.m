function [left_, right_] = calc_payoffBEP(self)
% ���㵱ǰѡ��Straddle����PayOff��Break Even Point
%���
% ��BEP����BEP

left_  = nan;
right_ = nan;
call = self.call;
put  = self.put;
if isempty(call) || isempty(put)
else
    call_strike_ = call.K;
    put_strike_  = put.K;
    max_strike_  = max([call_strike_, put_strike_]);
    min_strike_  = min([call_strike_, put_strike_]);
    cost_ = call.last + put.last;
    left_  = min_strike_ - cost_;
    right_ = max_strike_ + cost_;
end




end