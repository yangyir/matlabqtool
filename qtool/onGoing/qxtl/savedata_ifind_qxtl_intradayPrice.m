%% 取出前一天的沪深300成分股和权重，放入spreadsheet中
% 专门针对ifind_qxtl_intradayPrice.xlsx
% 存入'ifind_qxtl_DH_weight.xlsx'， sheet wt_1
% 每天早上运行一次


clear all
rehash


DH
% workingpath = 'V:\root\qtool\onGoing\qxtl';
workingpath = 'D:\tfwork\root\qtool\onGoing\qxtl\';
filename    = 'ifind_qxtl_DH_weight.xlsx';
indexCode   =  '000300.SH';


%%
% 如超过 15：30，dt=明天，否则dt=今天
dt = datestr(today, 'yyyy-mm-dd')

% 成分股
arrCode  = DH_E_S_IndexComps('000300.SH',dt,0);
arrCode2 = DH_S_INF_Abbr(arrCode);

% 当日权重根据前收盘价计算
arrWt   = DH_I_WT_ComponentWeight('000300.SH',arrCode,dt,1);

% dt2     = datestr(today+1, 'yyyy-mm-dd');
% arrWt2  = DH_I_WT_ComponentWeight('000300.SH',arrCode,dt,2);

% 当日是否tradable，实时取出来都是0，只有历史有值
% stkTradable = DH_D_TR_IsTradingDay(arrCode,dt);

% % 从最当初就把不可交易的东西去掉
% arrCode = arrCode(stkTradable==1);
% arrWt   = arrWt(stkTradable == 1);
% arrWt   = arrWt/ sum(arrWt);  % 重新归一化
 

% DH_S_VAL_AdjustTradable(arrCode,'2014-12-15',2)
% DH_S_VAL_MarkertVal(arrCode,'2014-12-15',2)


%% 记录到excel中，专门的一页
xlswrite([workingpath, filename], {dt}, 'wt', 'A1');
xlswrite([workingpath, filename], arrCode, 'wt', 'B1');
xlswrite([workingpath, filename], arrCode2, 'wt', 'C1');
xlswrite([workingpath, filename], arrWt, 'wt', 'D1');
% xlswrite([workingpath, filename], stkTradable, 'wt_1', 'E1');

    
%% 记录成.mat,放在param
% 当日是否tradable，实时取出来都是0，只有历史有值
% stkTradable = DH_D_TR_IsTradingDay(arrCode,datestr( datenum(dt)-1 , 'yyyy-mm-dd'));

% 从最当初就把不可交易的东西去掉
% arrCode = arrCode(stkTradable==1);
% arrWt   = arrWt(stkTradable == 1);

save([workingpath '\param\arrCode_' dt '.mat'], 'arrCode');
save([workingpath '\param\arrWt_' dt '.mat'], 'arrWt');

