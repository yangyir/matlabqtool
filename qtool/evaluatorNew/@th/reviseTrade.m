function [ newTradeQmat, log, log2 ] = reviseTrade( tradeQmat, tradableMat, pMat)
% �������׾��󣺲����ף�ͣ�ƣ��Ĺ�Ʊ������Ϊ0������Ʊrebalance
% [ newTradeQmat, log, log2 ] = reviseTrade( tradeQmat, tradableMat, pMat)
%   tradeQmat��ԭ������������TsMatrix��
%   tradableMat���ɽ���״������0/1��ֵ��TsMatrix�࣬Ĭ��DHȡͣ�����
%   pMat���۸����TsMatrix�࣬Ĭ��close
%   newTradeQmat������������������TsMatrix��
%   log����¼ÿһ������
%   log2����¼ÿһ�������
% ----------------
% �̸գ�20150524�����汾


%% Ԥ����
% �ж�����
if ~isa(tradeQmat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�tradeQmat');
end


if ~exist('tradableMat', 'var')
    tradableMat = th.dhTradableMat( tradeQmat );
elseif ~isa(tradableMat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�tradableMat');
end


if ~exist('pMat', 'var')
    pMat = th.dhPriceMat(tradeQmat);
elseif ~isa(pMat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�pMat');    
end

log = '';
log2 = '';


newTradeQmat = tradeQmat.getCopy;
newTradeQmat.des = [ newTradeQmat.des, '-��ϴ��'];

%% main
% �ʽ��Ϊ3�ࣺ��������

% q = tradeQmat.data;
% t = tradableMat.data;
% p = pMat.data;

% ��1������Դ�



% ��2�쵽���һ��
for i = 2:size(tradeQmat.data,1)
    
    q = tradeQmat.data(i,:);        q(isnan(q) ) = 0;
    t = tradableMat.data(i,:);
    p = pMat.data(i,:);
    
     % ��ֵ
    v = q .* t .* p;
    v( isnan(v) ) = 0;
    
    % ���������
    ttlBuy  = sum(v .* (v>0) );
    ttlSell = -sum(v .* (v<0) );
 
    % �ص� ��� = ���� = max(����������

    newBuy = max(ttlBuy, ttlSell);
%     newBuy = (ttlBuy + ttlSell) * 0.5;
    newSell = newBuy;
    
    % ��ĵ��У����¹�һ��������������
    % ���ĵ��У����¹�һ��������������
    % ���ɽ��׵ģ�����
    newV = v .* (v>0) / ttlBuy * newBuy + v.*(v<0) / ttlSell * newSell;
    newQ = newV ./ p;
    newQ( isnan(newQ) ) = 0;
    newTradeQmat.data(i,:) = newQ;

    
    
    % log
    idx = find( (q~=0) & ( t==0 | isnan(p) ) );
    for j = 1:length(idx)
        ii      = idx(j);
        dtStr   = tradeQmat.yProps{i};
        codeStr = tradeQmat.xProps{ii};
        if t(ii) == 0,         typeStr = 'ͣ��'; end
        
        log = sprintf( '%s%s, %s: [%s] ԭ����%d����������%d\n', log,...
           dtStr, codeStr, typeStr, q(ii), newQ(ii));
    end
    
    log2 = sprintf( '%s%s: ԭ��%0.0f, ԭ��%0.0f, ��������%0.0f����%0.0f\n', log2, ...
            tradeQmat.yProps{i}, ttlBuy, ttlSell, newBuy, newSell);
        
        
        
end





end

