function [  ] = logout( self )
%LOGOUT �ǳ��ĺ���
% --------------------------
% �콭��20160621

if self.is_Counter_Login
    ret = jg_counterlogout(self.counterId);
    if ret
        self.is_Counter_Login = false;
        self.counterId = 0;
    else
        disp('�ǳ�ʧ��');
    end
end

end

