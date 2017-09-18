function [ ] = insertVec(obj, vector, nameStr, direction, idx)
% ��matrix2D�����л���
% [ ] = insertVec(obj, vector, nameStr, direction, idx)
%     vector: Ҫ�������/��������������Ϊ���ݣ�����Ҫ�Ǻϣ����ж���/��ֻȡ��һ��/��
%     nameStr: Ҫ����������������������ڣ�Ĭ��'newCol'��'newRow'
%     direction: 1-��������2-��������Ĭ�ϸ���vector�Զ��ж�
%     idx:  ָ������ص㣬0��ʾ�����룬Ĭ��0
% ----------------------
% �̸�,20150519,���汾


%% Ԥ����
% check nan
if isnan( vector )
    error('error: vectorΪ��!');
end

% �Զ��ж�direction
if ~exist('direction', 'var')
    [y1, x1] = size(vector);
    if y1>x1
        tmpStr = '������';
        direction = 1;
    else
        tmpStr = '������';
        direction = 2;
    end
    warning('δ֪���������Զ��ж�Ϊ%s', tmpStr   );
end

 
if ~exist('idx', 'var'),        
    idx     = 0;            
end

if ~exist('nameStr', 'var'),
    if direction ==1
        nameStr = 'newCol';
    elseif direction == 2
        nameStr = 'newRow';
    else
        nameStr = 'newVector';
    end
end



%% main
% �ֱ���ò������������������ĺ���ʵ��
if direction == 1 %������
    insertCol(obj, vector, nameStr, idx);
elseif direction == 2 %������
    insertRow(obj, vector, nameStr, idx);
end




end

