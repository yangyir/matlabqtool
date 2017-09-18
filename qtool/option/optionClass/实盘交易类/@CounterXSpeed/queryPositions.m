function [positionArray, ret] = queryPositions(self, code)
% ��ѯ�ֲ�
% [positionArray, ret] = queryPositions(code)
% ��codeΪ��ʱ,��ѯ���гֲ֡�
% ��codeΪĳ��Լ����ʱ����ѯ�ú�Լ�ϵĳֲ֡�
% --------------------------
% �콭��20160712

if ~exist('code', 'var')
    code = '';
end
xspeed_query_fund_and_position(self.counterId);
pause(1);
switch self.counterType
    case 'ETF'
        [positionArray, ret] = xspeed_getstkposition(self.counterId, code);
    case 'Option'
        [positionArray, ret] = xspeed_getoptposition(self.counterId, code);
end


if ~ret
    disp('��ѯ�ֲ�ʧ��');
end
    
end