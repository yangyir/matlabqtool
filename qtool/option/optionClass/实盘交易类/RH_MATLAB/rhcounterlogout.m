function [result] = counterlogout(counter_id)
% [result] = counterlogout(counter_id)
% �ǳ�ָ����ŵĹ�̨�����سɹ����
%--------------------------------------
% �콭 2016.6.20 first draft
if not(libisloaded('RonHangSystem'))
    result = true;
    return;
end
result = rh_counter_logout(counter_id);
end