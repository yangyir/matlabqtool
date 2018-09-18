function [ret] = withdrawEntrust(obj,e)
%cCounterRH
counter_id = obj.counterId;
entrust_id = e.entrustId;

ret = rh_counter_withdrawoptentrust(counter_id, entrust_id);

end