function [ posQmat ] = tradeQmat2posQmat( tradeQmat )
% ����posMat������tradeMat�ۼӵó�posMat��ֻ�ܶ�Qmat��
% �����tradeMat�Ŀ�ʵ����
% [ posQmat ] = tradeQmat2posQmat( tradeQmat )
% ---------------
% �̸գ�20150521�����汾
% �̸գ�20150524�������߼�����ֻ����Qmat���м���


%% Ԥ����

% �ж�����
if ~isa(tradeQmat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�tradeMat');
end

% ��ʼ��λ 0


%%
posQmat      = tradeQmat.getCopy;
posQmat.des  = '�ֲ־���';
posQmat.des2 = '����';
posQmat.datatype = '����(ʵ��)';

% tradeMat �������ɣ������ʼ��λΪ0
d1 = tradeQmat.data;
d2 = zeros( size(d1) );
d2 = cumsum(d1, 1); 

posQmat.data = d2;


%% ȡ��
th.setIntQmat(posQmat, 'floor');

end

