function [ idx ] =  removeRowByPropName(obj, propNameStr)
% ɾȥ���ƶ�Ӧ��һ��
% [ idx ] = removeRowByPropName(obj, propNameStr)
%     propNameStr: ɾȥ���е�����
%     idx: ɾȥ�е�ԭ�к�
% --------------------
% �̸գ�20150519�����汾

idx = find(   strcmp(propNameStr, obj.yProps)   );

if isempty(idx)
    error('����û���ҵ���������(yProps):\''%s\''', propNameStr);
else %~isempty(idx)
    % ɾһ��
    obj.removeRow(idx);
end


end

