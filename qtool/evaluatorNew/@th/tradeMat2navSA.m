function [ navSA ] = tradeMat2navSA( tradeMat )
%TRADEMAT2NAV Summary of this function goes here
% tradeMat: ��TsMatrix��
% navSA����SingleAsset��
% ֻ�������������
% -------------------
% �̸գ�21050520�����汾


%% Ԥ����

% �ж�����
if ~isa( tradeMat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�posMat');
end

%% 
nav = SingleAsset;
nav.des = '��Ͼ�ֵ';
nav.yProps = posMat.yProps;



%% �ܾ���
tmpdata = DH_Q_DQ_Stock(assetsCell(2:end), dtsCell,'Close',1);
tmpdata = DH_Q_DQ_Stock(assetsCell, dtsCell,'Close',1);
tmpdata = tmpdata';

% �����
buyValue = nansum( (d2>0) .* d2 .* tmpdata, 2);
sellValue = nansum( (d2<=0) .* d2 .* tmpdata, 2);
cashFlow = nansum( d2.*tmpdata, 2);


end

