function [entrustinfoArray, ret] = loadEntrusts(self)
% function [entrustArray, ret] = queryEntrusts(self)
% query counter entrusts, reset counter available id to
% size(entrustsarray)+1

[entrustinfoArray, ret] = ctp_counter_loadentrusts(self.counterId);
if ret
    L = length(entrustinfoArray);
    self.SetAvailableEntrustId(L+1);
end
end