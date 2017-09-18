function [ newPosPCTmat, log ] = reviseHoldingPCTmat(  posPCTmat, holdableMat )
% �����ֲ־��󣺲��ɳֲֵĹ�Ʊ�ֲ���Ϊ0������Ʊrebalance��ֻ�ܶ�pctmat���е����������޷���֤û�г����
% [ newPosPCTmat, log ] = reviseHoldingPCTmat(  posPCTmat, holdableMat )
%   posPCTmat��  �ֲ�ռ�Ⱦ���TsMatrix��
%   holdableMat���ɳֲ־���TsMatrix�࣬����ֱ�Ӽ򵥾���Ĭ��ȡIPO����ͣ��
% -------------------------
% �̸գ�20150622����ԭ�а汾���� [ newPosPCTmat, log ] = revisePosPCTmatBeforeIPO( posPCTmat )



%% Ԥ����
if ~isa(posPCTmat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�posPCTmat');
end


% Ĭ�ϵ�holdable�����¹��������������к�20��󣬶�holdable
if ~exist('holdableMat', 'var')
    holdableMat = th.dhXinguHoldable(  posPCTmat );
end


% hMatΪ�򵥾��������������
if isa(holdableMat, 'TsMatrix')
    hMat = holdableMat.data;
elseif isa(holdableMat, 'double')
    if size(holdableMat) == size(posPCTmat.data)
        hMat = holdableMat;
    else
        error('holdableMat����ӦΪTsMatrix');
    end
end

%
log = '';


%% main
d2 = posPCTmat.data;
d3 = d2;

% ���������ֲ־���
for i = 1:size(d2,1)
    % ȡ�����ճֲ֣�ԭ�����͵��չ�Ʊ�������
    pct1        = d2(i,:);
    holdable    = hMat(i,:);
    
    % ���ɳֲֵģ��ֲ�PCT���㣬�ص�ռ��
    ttl     = sum( pct1(holdable==1) );
    pct2    = pct1 / ttl;
    pct2    = pct2 .* holdable;
    
    d3(i,:) = pct2;
    
    % ����log
    dtStr = posPCTmat.yProps{i};
    log = sprintf('%s%s: �ɳֲ�%d/��%d\n', log, ...
            dtStr, sum(holdable), length(holdable));
    
    
    % ���������˵ĸ���
    for j = 1:length(pct1)
        if abs( pct1(j) - pct2(j) ) > 1e-8
            log = sprintf('%s  �¹�����%s��ԭ��%0.1f%%���ֲ�%0.1f%%\n', log, ...
                posPCTmat.xProps{j}, pct1(j)*100, pct2(j)*100);
        end
    end
end

newPosPCTmat       = posPCTmat.getCopy;
newPosPCTmat.data  = d3;
end

