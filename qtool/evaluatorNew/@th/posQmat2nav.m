function [port] = posQmat2nav( posQmat, pmat )
% �ӳֲ���������posQmat�㾻ֵnav���粻�ṩ�۸���DHȡclose
% [port] = posQmat2nav( posQmat, pmat )
%   posQmat: �ֲ���������TsMatrix��
%   pmat���۸����TsMatrix�ࡣĬ��DHȡclose
%   port���ֲ���ֵ�������棬SingleAsset��
% --------------------
% �̸գ�20150520�����汾


%% Ԥ����

% �ж�����
if ~isa(posQmat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�posMat');
end

% Ĭ��pmat 
if ~exist('pmat', 'var')
    pmat = th.dhPriceMat(posQmat);
end

%% main
port        = SingleAsset;
port.des    = 'Ͷ�����';
port.des2   = '�ֲ���ֵ';
port.yProps = posQmat.yProps;


holdingM2M = nansum(posQmat.data .* pmat.data,2);
port.insertCol( holdingM2M, '�ֲ���ֵ')

end

