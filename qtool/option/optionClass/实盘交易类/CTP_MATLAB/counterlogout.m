function [result] = counterlogout(counter_id)
% [result] = counterlogout(counter_id)
% �ǳ�ָ����ŵĹ�̨�����سɹ����
%--------------------------------------
% �콭 2016.6.20 first draft
if not(libisloaded('CTP_Counter'))
    result = true;
    return;
end
result = ctpcounterlogout(counter_id);
end