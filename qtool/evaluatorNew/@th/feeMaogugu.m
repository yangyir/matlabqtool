function [ port ] = feeMaogugu( tradeVmat, feeRatio )
% ʹ�ý��׶����TradeVmat���Թ��������ѣ�ֱ����ÿ��ģ��ۼӣ�û��recursive
% [ port ] = feeMaogugu( tradeVmat, feeRatio )
% --------------------
% �̸գ�20150524�����汾



%% ǰ����������������
% �ж�����
if ~isa(tradeVmat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�tradeVmat');
end

% ��ʱ
if ~exist('feeRatio', 'var')
    warning('ʹ��Ĭ����������');
end

% �����ѣ���ʵ���������TODO������дһ��������������DH��һ������
assetsCell = tradeVmat.xProps;
buyFeeRatio = zeros(size(assetsCell));
sellFeeRatio = zeros(size(assetsCell));

for i = 1: length(assetsCell)
    astStr = assetsCell{i};
    pre = astStr(1:2);
    if strcmp(pre, '60') || strcmp(pre, '00') % �����Ʊ
        buyFeeRatio(i)  = 0.0001; 
        sellFeeRatio(i) = 0.00106;

        % ��ָ�ڻ�
    elseif strcmp(pre, 'IF') || strcmp(pre,'IC') || strcmp(pre, 'IH') ...
            || strcmp(pre,'if') || strcmp(pre, 'ic') || strcmp(pre,'ih')
        buyFeeRatio(i)  = 0.000029;
        sellFeeRatio(i) = 0.000029;
    
        
    elseif strcmp(pre, '50' ) % ����
        buyFeeRatio(i)  = 0.001;
        sellFeeRatio(i) = 0.001;

        % ���кܶ����������ʲ�
        
        
    end
    
end

%% main
% �������Ѿ���
d       = tradeVmat.data;
vec1    = ones(size(tradeVmat.yProps));
feeBuy  = d .* (d>=0) .* ( vec1 * buyFeeRatio ); 
feeSell = - d .* (d<0) .* ( vec1 * sellFeeRatio );

% ��������
ttlFeeBuy   = nansum( feeBuy, 2);
ttlFeeSell  = nansum( feeSell, 2);
ttlFee      = ttlFeeBuy + ttlFeeSell;

%  ��¼���
port        = SingleAsset;
port.des    = 'Ͷ�����';
port.des2   = '����������';
port.yProps = tradeVmat.yProps;

port.insertCol( cumsum(ttlFee), '�ۼ���������');
port.insertCol( ttlFeeBuy, '���');
port.insertCol( ttlFeeSell, '����');
port.insertCol( ttlFee, '��������');



end

