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

[positionArray, ret] = ctpcounter_getpositions(self.counterId, code);

if ~ret
    disp('��ѯ�ֲ�ʧ��');
end
    
end