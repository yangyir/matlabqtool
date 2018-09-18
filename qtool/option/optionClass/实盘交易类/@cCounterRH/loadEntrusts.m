function [entrustinfoArray, ret] = loadEntrusts(obj)
%cCounterRH
[entrustinfoArray, ret] = rh_counter_loadentrusts(obj.counterId);
if ret
    L = length(entrustinfoArray);
    obj.SetAvailableEntrustId(L+1);
end
end