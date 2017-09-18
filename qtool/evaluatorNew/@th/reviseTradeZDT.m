function  [ newTradeQmat, log, log2] = reviseTradeZDT( tradeQmat, ztMat, dtMat, pMat)
% �����������������ǵ�ͣ��������
% [newTradeQmat, log, log2] = reviseTradeZDT( tradeQmat, ztMat, dtMat, pMat)
%   tradeQmat��ԭ������Qmat��TsMatrix��
%   ztMat����ͣ״̬������ֵ0/1,TsMatrix�࣬Ĭ����DHȡ
%   dtMat����ͣ״̬������ֵ0/1,TsMatrix�࣬Ĭ����DHȡ
%   pMat���۸����TsMatrix�࣬Ĭ����DHȡ
%   newTradeQmat���������
%   log��ÿһ������
%   log2��ÿһ�������
% ����ؽ���ztMat��dtMatҲ������Ϊ����ͽ����������ã���������ԭ����ɵĽ���ͽ������������
% ----------------
% �̸գ�20150524�����汾


%% Ԥ����
% �ж�����
if ~isa(tradeQmat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�tradeQmat');
end

% Ĭ���ǵ�ͣ����
if ~exist('ztMat', 'var') & ~exist('dtMat', 'var')
    [ztMat, dtMat] = th.dhZhangDieTingMat(tradeQmat,2);
    warning('ʹ��Ĭ�ϣ��ǵ�ͣ���ͣ���ĩ');
elseif ~exist('ztMat', 'var')
    [ztMat, ~] = th.dhZhangDieTingMat(tradeQmat,2);
elseif ~exist('dtMat', 'var')    
    [ ~, dtMat] = th.dhZhangDieTingMat(tradeQmat,2);
end

% �ǵ�ͣ���������ж�
if ~isa(ztMat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�ztMat');
end

if ~isa(dtMat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�dtMat');
end

% �۸����
if ~exist('pMat', 'var')
    pMat = th.dhPriceMat(tradeQmat);
elseif ~isa(pMat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�pMat');    
end


log = '';
log2 = '';


newTradeQmat        = tradeQmat.getCopy;
newTradeQmat.des    = [ newTradeQmat.des, '-��ϴ��'];

%% main
% ��1������Դ�



% ��2�쵽���һ��
for i = 2:size(tradeQmat.data,1)
    
    q = tradeQmat.data(i,:);        q(isnan(q) ) = 0;
    zt = ztMat.data(i,:);
    dt = dtMat.data(i,:);
    p = pMat.data(i,:);
    
     % ��ֵ
     vBuy = q .* (q>0) .* (zt==0) .* p;
     vBuy( isnan(vBuy) ) = 0;
     
     vSell = q .* (q<0) .* (dt==0) .* p;
     vSell( isnan(vSell) ) = 0;
     
     
    % ���������
    ttlBuy  = sum(vBuy );
    ttlSell = -sum(vSell);
 
    % �ص� ��� = ���� = max(����������
    newBuy = max(ttlBuy, ttlSell);
%     newBuy = (ttlBuy + ttlSell) * 0.5;
    newSell = newBuy;
    
    % ��ĵ��У����¹�һ��������������
    % ���ĵ��У����¹�һ��������������
    % ���ɽ��׵ģ�����
    newV = vBuy / ttlBuy * newBuy + vSell / ttlSell * newSell;
    newQ = newV ./ p;
    newQ( isnan(newQ) ) = 0;
    newTradeQmat.data(i,:) = newQ;

    
    
    %% log
    idx = find( (q>0  & zt==1 )  | ( q<0 & dt==1)   );
    for j = 1:length(idx)
        ii      = idx(j);
        dtStr   = tradeQmat.yProps{i};
        codeStr = tradeQmat.xProps{ii};
%         if t(ii) == 0,         typeStr = 'ͣ��'; end
        if zt(ii) == 1,         typeStr = '��ͣ'; end
        if dt(ii) == 1,         typeStr = '��ͣ'; end
        
        log = sprintf( '%s%s, %s[%s]: ԭ����%d����������%d\n', log,...
           dtStr, codeStr, typeStr, q(ii), newQ(ii));
    end
    
    log2 = sprintf( '%s%s: ԭ��%0.0f, ԭ��%0.0f, ��������%0.0f����%0.0f\n', log2, ...
            tradeQmat.yProps{i}, ttlBuy, ttlSell, newBuy, newSell);
        
        
        
end
end

