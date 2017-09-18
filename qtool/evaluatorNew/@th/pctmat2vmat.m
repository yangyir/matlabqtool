function [ vmat ] = pctmat2vmat( pctmat, initValue )
% ��ռ�Ⱦ������ֵ���󣬱ȽϷ�����������
%  [ vmat ] = pctmat2vmat( pctmat, initValue )
% -------------
% �̸գ����汾��20150521

%% Ԥ����

% Ĭ�ϳ�ʼ��ֵ1��Ԫ
if ~exist('initValue', 'var')
    initValue = 100000000;
end


% �ж�����
if ~isa(pctmat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�pctmat');
end

% �ж���ֵ����
dtype = pctmat.datatype;
warning('vmat.datatype = %s����ȷ��Ϊ�ٷֱ�С��', dtype);

% ����������nan
if isnan( pctmat.data )
    warning(' vmat.data �к���nan�����ܻ�����鷳!');
end


%% main, �����һ������
% �Ƿ�Ҫ����nan���⣿


% �����ֵ
vmat            = pctmat.getCopy;
vmat.datatype   = '��ֵ';
vmat.des2       = '�ֲּ�ֵ';
vmat.data       = zeros(size(vmat.data));
vmat.autoFill;

% ȡ�۸�仯
pmat = th.dhPriceMat(vmat, 'PCTChange',2);
% �ѱ仯��nan����Ϊ0
pmat.data( isnan( pmat.data ) ) = 0;

%
%% ������vmat
ttlValue        = zeros( size(vmat.yProps) );

% ��1��
ttlValue(1)     = initValue;  % ����240pm�ļ�ֵ
vmat.data(1,:)  = ttlValue(1) * pctmat.data(1,:);

% ��2�쵽���һ��
for idt = 2:vmat.Ny
    % �㵱�콻��ǰ��ֵ == ���׺��ֵ    
    ttlValue(idt)   =  nansum( vmat.data(idt-1, :) .* (1 + pmat.data(idt,:)) ) ;    
    
    % ������ĩ�ļ�ֵ��λ
    vmat.data(idt,:) = ttlValue(idt) * pctmat.data(idt,:);
    
end

% plot(ttlValue)
