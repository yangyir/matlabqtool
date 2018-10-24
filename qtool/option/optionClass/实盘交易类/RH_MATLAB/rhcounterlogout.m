function [result] = counterlogout(counter_id)
% [result] = counterlogout(counter_id)
% 登出指定编号的柜台，返回成功与否
%--------------------------------------
% 朱江 2016.6.20 first draft
if not(libisloaded('RonHangSystem'))
    result = true;
    return;
end
result = rh_counter_logout(counter_id);
end