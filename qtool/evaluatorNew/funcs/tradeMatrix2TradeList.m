% load('F:\qtool\evaluatorNew\hm_pctmat.mat')
load('V:\root\qtool\evaluatorNew\hm_pctmat.mat')

hm_pctmat

%% 清洗
%清洗一：未上市和退市不可持仓
% posPCTmat   = th.revisePosPCTmatBeforeIPO( hm_pctmat);
% posVmat     = th.pctmat2vmat(posPCTmat, 100000000);
% posQ            = hm_pctmat.getCopy;
% posQ.des        = '随机持仓';
% posQ.des2       = '数量';
% posQ.datatype   = '整数';
% posQ.data       = floor( rand(size(posQ.data))*100000 );
tradeQ = th.posQmat2tradeQmat(posQ);
tradeQ.autoFill;


%% 从tradeQ填入TradeList（一维）
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

