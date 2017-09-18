%% 把holdinglist变成nav

DH

%% 时间
sdt = datenum(2015,1,1);
edt = datenum(2015,5,15);
dts = DH_D_TR_MarketTradingday(1, sdt, edt);
dtsCell = {};
for i = 1:length(dts)
    dtsCell{i,1} = dts(i,:);
end

%% assets
assetsCell{1} = 'cash';
tmpCell = dhIndexCompsAlltime('000300.SH', sdt, edt);
for i = 2:length(tmpCell)+1
    assetsCell{i} = tmpCell{i-1};
end
%% 输入 - holdingMat， 行情
% holdingMat是二维的，T*N，时间*股票，数据是：量
% 如果数据多一些，也可以记成三维的
% 



hmat =  TsMatrix;
hmat.des    = '持仓矩阵';
hmat.yProps = dtsCell;
hmat.xProps = assetsCell;
hmat.autoFill




%% 行情数据
pmat = hmat.getCopy;
pmat.des2 = '股票价格，不复权';
tmpdata = DH_Q_DQ_Stock(assetsCell(2:end), dtsCell,'Close',1);
tmpdata = tmpdata';
pmat.autoFill
pmat.data = ones(pmat.Ny, pmat.Nx);
pmat.data(:,2:end) = tmpdata;
v = pmat.getVecByPropName('601992.SH');
pmat.insertVec(v, 'newStock',1,300)

pmat.removeRow(86);
pmat.removeRowByPropName('2015-05-11');
pmat.removeCol(300);
i = pmat.removeColByPropName('601988.SH');
pmat.removeColByPropName('601988.SH');


pmat.toTxt;
% pmat.toExcel

%% 算nav
nav  = SingleAsset;
% nav  = pmat.getCopy
nav.AutoFill
nav.toExcel


% 算



%% 验证 th.pctmat2vmat() 和 th.vmat2pctmat() 互逆
figure(110); hold off
plot(sum(hm_pctmat.data,2))

holdingMat  = th.pctmat2vmat(hm_pctmat);
nav2        = nansum( holdingMat.data, 2);
hold off
plot(nav2)

% 验证结论：一致，只有小数点后N多位差舍入误差
mypctmat    = th.vmat2pctmat(holdingMat);
nansum(nansum(hm_pctmat.data == mypctmat.data))
nansum(nansum(hm_pctmat.data ~= mypctmat.data))
nansum(nansum(hm_pctmat.data - mypctmat.data))

nansum(nansum(isnan(hm_pctmat.data) ))
nansum(nansum( isnan( mypctmat.data ) ))
nansum(nansum(mypctmat.data~=0))
nansum(nansum(hm_pctmat.data ~= 0))

hm_pctmat.toExcel
mypctmat.toExcel

%% 验证：从holdingVmat到tradeVmat，必须借道Qmat
% 从holdingVmat到tradeVmat，必须借道Qmat
holdingQmat = th.vmat2qmat(holdingMat);
tradeQmat   = th.posQmat2tradeQmat(holdingQmat);
tradeVmat   = th.qmat2vmat(tradeQmat);

tradeVmat2  = th.posQmat2tradeQmat(holdingMat);
tradeVmat2  = '交易矩阵2';

nansum(nansum(tradeVmat.data == tradeVmat2.data))
nansum(nansum(tradeVmat.data ~= tradeVmat2.data))
nansum(nansum(tradeVmat.data ~= 0))

nansum(nansum( (tradeVmat.data ~= tradeVmat2.data)  & (tradeVmat.data ~= 0) ))

nansum(nansum( abs(tradeVmat.data - tradeVmat2.data)./ tradeVmat.data  ))

holdingMat.toExcel
holdingQmat.toExcel
tradeQmat.toExcel

tradeVmat.toExcel
tradeVmat2.toExcel

%% 验证：th.tradeQmat2posQmat(） 和  th.posQmat2tradeQmat(） 互逆
holdingQmat2 = th.tradeQmat2posQmat(tradeQmat)
holdingQmat2.des = [ holdingQmat2.des, '2'];
holdingQmat2.toExcel
holdingQmat.toExcel
nansum(nansum(abs( holdingQmat2.data - holdingQmat.data )))

