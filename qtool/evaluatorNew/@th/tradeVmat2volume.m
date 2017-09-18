function [ port ] = tradeVmat2volume( tradeVmat )
% �ӽ��׾�����㽻�׶ ����������ܽ��׶��
%[ port ] = tradeVmat2volume( tradeVmat )
% --------------------
% �̸գ�20150524�����汾

%% ǰ����
% �ж�����
if ~isa(tradeVmat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�tradeMat');
end

% ��DH


%% 
port = SingleAsset;
port.des  = 'Ͷ�����';
port.des2 = '����������ܽ��׶��';
port.yProps = tradeVmat.yProps;

d       = tradeVmat.data;
ttlBuy  = nansum( d .* (d>=0) , 2);
ttlSell = - nansum( d.* (d<0),    2);
ttlNet  = ttlBuy - ttlSell;
ttlTrade = ttlBuy + ttlSell;

port.insertCol( ttlBuy, '���');
port.insertCol( ttlSell, '����');
port.insertCol( ttlNet, '�����');
port.insertCol( ttlTrade, '�ܽ��׶�');






end

