function [ tradableMat ] = dhTradableMat( tsMat )
% ��DH��ȡͣ����Ϣ����ͣ��Ϊ0���ɽ���Ϊ1��TsMatrix��
% ------------
% �̸գ�20150521�����汾



%% Ԥ����
% �ж�����
if ~isa(tsMat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�posMat');
end

% ��DH


%% ���ͣ�ƹ�Ʊ
dtsCell = tsMat.yProps;
assetsCell = tsMat.xProps;



% �ɽ���1�� ͣ��0
tM = DH_D_TR_IsTradingDay(assetsCell, dtsCell);
tM = tM';
tM = double(tM);

% ����TsMatrix
tradableMat = tsMat.getCopy;
tradableMat.des = '�ɽ���';
tradableMat.des2 = '0/1';
tradableMat.datatype = '0/1';
tradableMat.data = tM;


end

