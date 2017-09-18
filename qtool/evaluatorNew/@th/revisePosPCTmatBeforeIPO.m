function     [ newPosPCTmat, log ] = revisePosPCTmatBeforeIPO( posPCTmat )
% 修正持仓矩阵；上市前的股票不能持仓，
% 只能对pctmat进行调整，否则无法保证没有出入金
% [ newPosMat ] = revisePosPCTmatBeforeIPO( posPCTmat )
% -------------------------
% 程刚，20150524，初版本
% TODO：退市的股票怎么考虑？
% TODO：IPOed是否正确？
% TODO：IPO后，打开涨停前，应该也抢不进去



%% 预处理
if ~isa(posPCTmat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的posPCTmat');
end


% 直接从DH取价格，取出nan，就是没上市或已退市
pMat = th.dhPriceMat(posPCTmat);


% 
d               = pMat.data;
IPOed           = ones(size(d));
IPOed(isnan(d)) = 0;


log = '';


%% main
d2 = posPCTmat.data;
d3 = d2;

% 逐日修正持仓矩阵
for i = 1:size(d2,1)
    % 取出当日持仓（原），和当日股票上市情况
    pct1 = d2(i,:);
    ipo  = IPOed(i,:);
    
    % 为上市的，持仓PCT置零，重调占比
    ttl     = sum( pct1(ipo==1) );
    pct2    = pct1 / ttl;
    pct2    = pct2 .* ipo;
    
    d3(i,:) = pct2;
    
    % 计入log
    dtStr = posPCTmat.yProps{i};
    log = sprintf('%s%s: 未上市%d, 已退市%d /总%d\n', log, ...
        dtStr, length(ipo) - sum(ipo), 0, length(ipo));
    
    
    % 计入修正了的个股
    for j = 1:length(pct1)
        if abs( pct1(j) - pct2(j) ) > 1e-8
            log = sprintf('%s  新股修正%s：原仓%0.1f%%，现仓%0.1f%%\n', log, ...
                posPCTmat.xProps{j}, pct1(j)*100, pct2(j)*100);
        end
    end
end

newPosPCTmat       = posPCTmat.getCopy;
newPosPCTmat.data  = d3;




end

