function [ vec, idx ]  = getVecByPropName( obj, target_prop, direction)
% ȡ��һ�л�һ�У�ʹ�ø���/�е���������ֵ
% �����ͬ�������ԣ�ֻ��ȡ��һ��
% [ vec, idx ]  = getVecByPropName( obj, target_prop, direction)
%     propNameStr: ������
%     direction: ȡ�������� 1��'��', 'x') ���� ��������2��'��', 'y')��Ĭ��1
%     vec��ȡ������/������
%     idx����data�ĵڼ���/��
% --------------
% �̸գ�20150517


%% Ԥ����
if ~exist('direction', 'var')
    direction = 1;
end

%%
switch direction
    case {1,'��','x'}
        if isa(obj.xProps, 'char')
            ix = find(   strcmp(target_prop, obj.xProps)   );
        else
            ix = find( target_prop == obj.xProps);
        end
        if isempty(ix)
            error('����getVecByPropNameû���ҵ���������(xProps):\''%s\''', target_prop);
        else %~isempty(ix)
            % ȡһ��
            vec = obj.data(:,ix);
            idx = ix;
        end
        
    case {2, '��', 'y'}
        if isa(obj.xProps, 'char')
        iy = find(   strcmp(target_prop, obj.yProps)  );
        else
            iy = find( target_prop == obj.yProps );
        end
        if isempty(iy)
            error('����getVecByPropNameû���ҵ���������(yProps):\''%s\''', target_prop);
        else %~isempty(iy)
            % ȡһ��
            vec = obj.data(iy,:);
            idx = iy;
        end
        
end

end

