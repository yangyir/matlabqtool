function [ret] = queryEntrust(counter, e)
% [ret] = queryEntrust(counter, e)
% ��ѯί��״̬
%---------------------------------
% �콭 20160621  first draft
counter_id = counter.counterId;
entrust_id = e.entrustId;

[dealinfo] = rh_counter_query_entrust(counter_id, entrust_id);

%         dealVolume@double = 0;     % �ɽ���Ŀ
%         dealAmount;     % �ɽ����
%         dealPrice;      % �ɽ�����
%         dealNum;        % �ɽ�����

e.dealVolume = dealinfo(1);
e.dealAmount = dealinfo(2);
e.dealPrice = dealinfo(3);
e.cancelVolume = dealinfo(4);

ret = true;

end