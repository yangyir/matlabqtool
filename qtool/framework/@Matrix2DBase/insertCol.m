function [  ] = insertCol(obj, colVec, nameStr, idx)
%��Matrix2D�в���һ�У��ı�obj.data��obj.xProps
% [  ] = insertCol(obj, colVec, nameStr, idx)
% colVec: Ҫ�������������������Ϊ���ݣ�����Ҫ�Ǻϣ����ж���ֻȡ��һ��
% nameStr: xProps�в���������������������ڣ�Ĭ��'newCol'
% idx: �ƶ�����ص㣬0��ʾ�����룬Ĭ��0
% ----------------------
% �̸գ�20150519,���汾



%% Ԥ����
% check nan
if isnan( colVec )
    error('error: colVecΪ��!');
end


if ~exist('idx', 'var')
    idx = 0;
end

if ~exist('nameStr', 'var')
    nameStr = 'newCol';
end

% check type
% if strcmp( class(colVec), 'double' )

% check size
[y1, x1] = size(colVec);
if isempty(obj.data)
    [y2, ~] = size(obj.yProps);
    [~, x2] = size(obj.xProps);
else
    [y2, x2] = size(obj.data);
end

if y1~=y2
    error('colVec����%d, ӦΪ%d', y1, y2);
end

if x1 ~= 1
    colVec = colVec(:, 1);
    warning('rowVec��%d�У���ȡ��һ��', x1);
end



%% main

if idx == 0 || idx > x2 % ��������
    obj.xProps{end+1}  = nameStr;
    obj.data(:, end+1) = colVec;
elseif idx > 0  % �ڵ�idx�в���
    % ����һ��
    obj.xProps(idx+1:end+1)     = obj.xProps(idx:end);
    obj.data(:, idx+1:end+1)    = obj.data(:, idx:end);

    % �ڵ�idx��д������
    obj.xProps{ idx }   = nameStr;
    obj.data(:, idx)    = colVec;
end


end

