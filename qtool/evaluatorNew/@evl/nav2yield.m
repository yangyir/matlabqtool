function [ yield ] = nav2yield(nav,  flag)
% ��һ���վ�ֵ����navת��������������yield
%  [ yield ] = nav2yield(nav,  flag)
% yield: ����������
% nav:  ��ֵ���У���һ��Ԫ��Ϊ1
% flag: ����'simple', ����'compand'��Ĭ��'compound'
% ע�⣺nav �� yield ���������������Ȼ��һ��
% ------------------
% ��һ�Σ�20150510

%% Ԥ����
if ~exist('flag', 'var') 
    flag = 'compound';
end

% ���ά��

%% Main
N       = length(nav);
yield   = ones(N-1,1);

if strcmp( flag, 'simple')
    yield = nav(2:end)-nav(1:end-1);
elseif strcmp( flag, 'compound')
    yield = nav(2:end)./nav(1:end-1)-1;
else
    error('flag�����д�');
end
    




end

