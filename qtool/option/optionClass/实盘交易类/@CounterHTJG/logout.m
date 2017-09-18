function [  ] = logout( self )
%LOGOUT 登出的函数
% --------------------------
% 朱江，20160621

if self.is_Counter_Login
    ret = jg_counterlogout(self.counterId);
    if ret
        self.is_Counter_Login = false;
        self.counterId = 0;
    else
        disp('登出失败');
    end
end

end

