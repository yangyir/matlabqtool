function [port] = posVmat2nav( posVmat )
% �ӳֲּ�ֵ����posVmat�㾻ֵnav
% [port] = posVmat2nav( posVmat )
%     posVmat: �ֲּ�ֵ����TsMatrix��
%     port���ֲ���ֵ�������棬SingleAsset��
% --------------------
% �̸գ�20150520�����汾


%% Ԥ����
% �ж�����
if ~isa(posVmat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�posMat');
end


%% main
port        = SingleAsset;
port.des    = 'Ͷ�����';
port.des2   = '�ֲ���ֵ';
port.yProps = posVmat.yProps;

holdingM2M  = nansum(posVmat.data,2);
port.insertCol( holdingM2M, '�ֲ���ֵ');

end

