function [ idx ] = removeColByPropName(obj, propNameStr)
% ɾȥ���ƶ�Ӧ��һ��
% [ idx ] = removeColByPropName(obj, propNameStr)
%     propNameStr: ɾȥ�е�����
%     idx: ɾȥ�е�ԭ�к� 
% --------------------
% �̸գ�20150519�����汾

idx = find(   strcmp(propNameStr, obj.xProps)   );

if isempty(idx)
    error('����û���ҵ���������(xProps):\''%s\''', propNameStr);
else %~isempty(ix)
    % ɾһ��
    removeCol(obj, idx);
end


end

