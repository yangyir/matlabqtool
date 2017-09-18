function [ pctmat ] = Untitled( vmat )
% �Ӽ�ֵ��������һ����ռ�Ⱦ���
% -------------
% �̸գ����汾��20150521

%% Ԥ����

% �ж�����
if ~isa(vmat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�vmat');
end

% �ж���ֵ����
dtype = vmat.datatype;
warning('vmat.datatype = %s����ȷ��Ϊ���', dtype)

% ����������nan
if isnan( vmat.data )
    warning(' vmat.data �к���nan�����ܻ�����鷳!');
end


%% main, �����һ������
% �Ƿ�Ҫ����nan���⣿

% ����Ӻͣ���ɾ���
total       = nansum( vmat.data, 2) ;
totalMat    = total * ones( size(vmat.xProps) );

% ����ٷֱ�
pctmat          = vmat.getCopy;
pctmat.datatype = '�ٷֱ�';
pctmat.des2     = '�����һ��ռ��';
pctmat.data     = vmat.data ./ totalMat;



end

