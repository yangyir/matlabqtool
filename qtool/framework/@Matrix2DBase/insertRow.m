function [  ] = insertRow(obj, rowVec, nameStr, idx)
%��Matrix2D�в���һ�У��ı�obj.data��obj.yProps
% [  ] = insertRow(obj, rowVec, nameStr, idx)
% rowVec: Ҫ�������������������Ϊ���ݣ�����Ҫ�Ǻϣ����ж���ֻȡ��һ��
% nameStr: yProps�в�������������������ڣ�Ĭ��'newRow'
% idx: �ƶ�����ص㣬0��ʾ�����룬Ĭ��0
% ----------------------
% �̸գ�20150519,���汾



%% Ԥ����
% check nan
if isnan( rowVec )
    error('error: rowVecΪ��!');
end

if ~exist('idx', 'var')
    idx = 0;
end

if ~exist('nameStr', 'var')
    nameStr = 'newRow';
end

% check type
% if strcmp( class(rowVec), 'double' )

    
% check size
[y1, x1] = size(rowVec);
if isempty(obj.data)
    [y2, ~] = size(obj.yProps);
    [~, x2] = size(obj.xProps);
else
    [y2, x2] = size(obj.data);
end

if x1~=x2
    error('rowVec����%d, ӦΪ%d', x1, x2);
end

if y1 ~= 1
    rowVec = rowVec(1,:);
    warning('rowVec��%d�У���ȡ��һ��', y1);
end



%% main

if idx == 0 || idx > y2 % ��������
    obj.yProps{end+1} = nameStr;
    obj.data(end+1,:) = rowVec;
elseif idx > 0  % �ڵ�idx�в���
    % ����һ��
    obj.yProps(idx+1:end+1)     = obj.yProps(idx:end);
    obj.data(idx+1:end+1, :)    = obj.data(idx:end, :);

    % �ڵ�idx��д������
    obj.yProps{idx}     = nameStr;
    obj.data(idx,:)     = rowVec;
end




end

