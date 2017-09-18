function [pMat ] = dhPriceMat( tsMat, datatype, fuquan )
%��DHȡ��Ʊ���飬���ո���tsMat�ĸ�ʽ�����ںʹ��룩�����ΪTsMatrix��
%[pMat ] = dhPriceMat( tsMat, datatype, fuquan )
%   pMat��TsMatrix���ͣ����ֵ
%   tsMat: TsMatrix���ͣ���yProps�����ڣ���xProps�����룩
%   datatype��PreClose, Open, High, Low, Close,AvgPrice, Amount, Volume, Turn, Change, PCTChange
%   fuquan: 1-����Ȩ��2-��Ȩ��Ĭ�ϣ���3-ǰ��Ȩ
% ------------
% �̸գ�20150521�����汾

%% Ԥ����

% �ж�����
if ~isa( tsMat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�posMat');
end

if ~exist('datatype', 'var')
    datatype = 'Close';
end

if ~exist('fuquan', 'var')
    fuquan = 2;
end

validStr = {'PreClose', '0pen', 'High', 'Low', 'Close', ...
    'AvgPrice', 'Amount', 'Volume', 'Turn', 'Change', 'PCTChange'};
if ~strcmp(datatype, validStr)
    error('datatype=''%s''����ȷ����ʾ������ĸ��д', datatype);
end

% ��DH


%% 
pMat        = tsMat.getCopy;
pMat.des    = datatype;
pMat.des2   = sprintf('��Ȩ%d',fuquan);
pMat.datatype = '%0.2f';

assetsCell  = pMat.xProps;
dtsCell     = pMat.yProps;
tmpdata     = DH_Q_DQ_Stock(assetsCell, dtsCell, datatype, fuquan);
tmpdata     = tmpdata';
pMat.data   = tmpdata;


end

