function [accountinfo, ret] = queryAccount(obj)
%cCounterRH
rh_counter_qryaccount(obj.counterId);
pause(1);
[accountinfo,ret] = rh_counter_getaccountinfo(obj.counterId);

if ~ret
    disp('²é×Ê½ðÊ§°Ü');
    return;
end

end