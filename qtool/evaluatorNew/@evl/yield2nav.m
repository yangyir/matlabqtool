function  [ nav ]  = yield2nav(yield, flag )
% ��һ������������yieldת���ɾ�ֵ����nav
% [ nav ] = Yield2Nav(yield, flag )
% yield: ����������
% flag: ����'simple', ����'compand'��Ĭ��'simple'
% nav:  ��ֵ���У���һ��Ԫ��Ϊ1
% ע�⣺nav �� yield ���������������Ȼ��һ��
% ------------------
% ��һ�Σ�20150510


%% Ԥ����
if ~exist('flag', 'var') 
    flag = 'simple';
end

% ���ά��


%% Main
N   = length(yield);
nav = ones(N+1,1);

if strcmp( flag, 'simple')
    nav(2:end) = cumsum(yield) + 1;
elseif strcmp( flag, 'compound')
    nav(2:end) = cumprod(1+yield);
else
    error('flag�����д�');
end
    


end

