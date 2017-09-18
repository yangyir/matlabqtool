% load('F:\qtool\evaluatorNew\hm_pctmat.mat')
load('V:\root\qtool\evaluatorNew\hm_pctmat.mat')

hm_pctmat

%% ��ϴ
%��ϴһ��δ���к����в��ɳֲ�
% posPCTmat   = th.revisePosPCTmatBeforeIPO( hm_pctmat);
% posVmat     = th.pctmat2vmat(posPCTmat, 100000000);
% posQ            = hm_pctmat.getCopy;
% posQ.des        = '����ֲ�';
% posQ.des2       = '����';
% posQ.datatype   = '����';
% posQ.data       = floor( rand(size(posQ.data))*100000 );
tradeQ = th.posQmat2tradeQmat(posQ);
tradeQ.autoFill;


%% ��tradeQ����TradeList��һά��
tl = TradeList;
dttmArr = datenum(tradeQ.yProps);
for i = 1:tradeQ.Nx
    assetStr = tradeQ.xProps{i};
    codeArr(i) = str2double(assetStr(1:6));
end

for  i = 1:tradeQ.Ny
%     dateStr = tradeQ.yProps{i};
    for j = 1:tradeQ.Nx
%         assetStr = tradeQ.xProps{j};       
        
        q = tradeQ.data(i,j);
        if q ~= 0
            newT.date       = dttmArr(i);
            newT.direction  = sign(q);
            newT.strategyNo = 1;
            newT.volume     = abs(q);
            newT.instrumentNo  = codeArr(j);
            tl.addNewItem( newT );
        end
    end
end

