function [] = logout(obj)
%cCounterRH

if obj.is_Counter_Login
    ret = rh_counter_logout(obj.counterId);
    if ret
        obj.is_Counter_Login = false;
        obj.counterId = 0;
    else
        disp('µÇ³öÊ§°Ü');
    end
end

end