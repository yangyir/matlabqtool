function [ uniCodesAll, dtsCell ] = dhIndexCompsAlltime( indexCode, sdt, edt )
%返回一个指数在某个时间段里所有的成分股（包括曾经的），使用DH
% [ uniCodesAll, dtsCell ] = dhIndexCompsAlltime( indexCode, sdt, edt )
%     indexCode： 指数代码，默认'000300.SH'
%     sdt：初始日，matlab时间实数，默认为证券上市日
%     edt：结束日，matlab时间实数，默认today
%     uniCodesAll：所有成分股代码
%     dtsCell： 交易日，cell格式，没必要有这个输出量
% --------------
% 程刚，2015-5-15，初版

%% 预处理
if ~exist('indexCode', 'var')
    indexCode = '000300.SH'; %沪深300
    % indexCode = '000016.SH';  %上证50
end

if ~exist('sdt','var')
    sdt = datenum(2015,1,1);
    sdt = DH_D_OTH_ListedDay(indexCode)
end

if ~exist('edt','var')
    edt = today;
end



%% main
% 指数代码和文字
% indexName = DH_S_INF_Abbr(indexCode);

% 时间段
% dts = DH_D_TR_MarketTradingday(1,sdt, edt);
dts = DH_D_TR_SecurityTradingday(indexCode, sdt, edt, 0);
dts = dts(1:20:end, :);

dtsCell = cell(size(dts,1),1);
for i = 1:size(dts,1)
    dtsCell{i,1} = dts(i,:);
end

%% 所有股票代码的并集
codesAll = {};

for idt = 1:size(dts,1)
    dtStr = dts(idt,:);
    codes = DH_E_S_IndexComps(indexCode, dtStr,0);
    
    % 合并
    for ic = 1:length(codes)
        codesAll{end+1,1} = codes{ic};
    end  
end

% 取unique
uniCodesAll = unique(codesAll);

end

