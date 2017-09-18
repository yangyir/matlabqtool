function [ obj ] = setRootPath( obj, rootPath )
% ����rootPath, �м��漰��һЩĬ��ֵ�������ȼ�

%% 
if ~exist('rootPath', 'var') 
    
    % ������ѡrootPath�������ȼ�����
    p = cell(1,1);
    p{1} = 'V:\root\';
    p{2} = 'D:\work\root\';
    p{3} = 'C:\work\root\';
    
    for i = 1:length(p)
        e(i) = exist(p{i}, 'dir');
    end
    
    idx = find( e > 0, 1, 'first' ) ;
    if isempty(idx), idx = 1; end;
        
    % Ĭ��Ϊ���ڵ����ȵı�ѡ
    rootPath = p{idx};       
        
end

obj.config.rootPath = rootPath;

end

