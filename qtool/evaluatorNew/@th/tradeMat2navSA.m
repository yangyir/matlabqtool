function [ navSA ] = tradeMat2navSA( tradeMat )
%TRADEMAT2NAV Summary of this function goes here
% tradeMat: 是TsMatrix类
% navSA：是SingleAsset类
% 只算出买额、卖额、净买额
% -------------------
% 程刚，21050520，初版本


%% 预处理

% 判断类型
if ~isa( tradeMat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的posMat');
end

%% 
nav = SingleAsset;
nav.des = '组合净值';
nav.yProps = posMat.yProps;



%% 总净买
tmpdata = DH_Q_DQ_Stock(assetsCell(2:end), dtsCell,'Close',1);
tmpdata = DH_Q_DQ_Stock(assetsCell, dtsCell,'Close',1);
tmpdata = tmpdata';

% 出入金
buyValue = nansum( (d2>0) .* d2 .* tmpdata, 2);
sellValue = nansum( (d2<=0) .* d2 .* tmpdata, 2);
cashFlow = nansum( d2.*tmpdata, 2);


end

