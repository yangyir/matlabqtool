function [ tradeQmat ] = posQmat2tradeQmat( posQmat )
% �ӳֲ־���ת�������׾���ֻ��ʹ����������Qmat
% ����Ǽ�ֵ���󣬲��ܼ������tradeMat
% [ tradeQmat ] = posQmat2tradeQmat( posQmat )
% --------------------
% �̸գ����汾��20150521
% �̸գ�20150524�������߼�����ֻ����Qmat���м���


%% Ԥ����

% �ж�����
if ~isa(posQmat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�posMat');
end

%% 
tradeQmat        = posQmat.getCopy;
tradeQmat.des    = '���׾���';
tradeQmat.des2   = '�ʲ�����'; 
tradeQmat.datatype = '������ʵ����';

d1          = posQmat.data;
d2          = zeros( size(d1) );
d2(2:end,:) = d1(2:end, :) - d1(1:end-1, :);
d2(1, : )   = d1( 1, : ); 

tradeQmat.data = d2;

%% ȡ��
th.setIntQmat(tradeQmat, 'floor');



end

