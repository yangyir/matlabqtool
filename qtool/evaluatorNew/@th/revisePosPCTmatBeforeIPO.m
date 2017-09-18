function     [ newPosPCTmat, log ] = revisePosPCTmatBeforeIPO( posPCTmat )
% �����ֲ־�������ǰ�Ĺ�Ʊ���ֲ֣ܳ�
% ֻ�ܶ�pctmat���е����������޷���֤û�г����
% [ newPosMat ] = revisePosPCTmatBeforeIPO( posPCTmat )
% -------------------------
% �̸գ�20150524�����汾
% TODO�����еĹ�Ʊ��ô���ǣ�
% TODO��IPOed�Ƿ���ȷ��
% TODO��IPO�󣬴���ͣǰ��Ӧ��Ҳ������ȥ



%% Ԥ����
if ~isa(posPCTmat, 'TsMatrix')
    error('������ֻ����TsMatrix���͵�posPCTmat');
end


% ֱ�Ӵ�DHȡ�۸�ȡ��nan������û���л�������
pMat = th.dhPriceMat(posPCTmat);


% 
d               = pMat.data;
IPOed           = ones(size(d));
IPOed(isnan(d)) = 0;


log = '';


%% main
d2 = posPCTmat.data;
d3 = d2;

% ���������ֲ־���
for i = 1:size(d2,1)
    % ȡ�����ճֲ֣�ԭ�����͵��չ�Ʊ�������
    pct1 = d2(i,:);
    ipo  = IPOed(i,:);
    
    % Ϊ���еģ��ֲ�PCT���㣬�ص�ռ��
    ttl     = sum( pct1(ipo==1) );
    pct2    = pct1 / ttl;
    pct2    = pct2 .* ipo;
    
    d3(i,:) = pct2;
    
    % ����log
    dtStr = posPCTmat.yProps{i};
    log = sprintf('%s%s: δ����%d, ������%d /��%d\n', log, ...
        dtStr, length(ipo) - sum(ipo), 0, length(ipo));
    
    
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

