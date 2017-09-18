%% 取基础数据——数据库数据
% 客户不要碰
% 程刚，140915


% 是否重新取数据（如未改变span和universe则不需重新取）
% 0 - 不重新load，也不重新fetch （最省时间）
% 1 - 重新load  ***.mat（隔夜工作储存，可以事先储存好几套环境）
% 2 - 重新dhfetch（有改变就要重来，极其慢）
switch fetchData1Flag
    
    case {0}
        % 0 - 不重新load，也不重新fetch （最省时间）
        % do nothing
    case {1}
        % 1 - 重新load  ***.mat（隔夜工作储存，可以事先储存好几套环境）
        load data1;
    case {2}
        % 2 - 重新dhfetch（有改变就要重来，极其慢）
%% 时间跨度
% sDay = '2014-01-01';
% eDay = '2014-08-30';
dateArr = DH_D_TR_MarketTradingday(1,sDay,eDay);
dateNumArr = datenum(dateArr);
NUMday = size(dateArr,1);

%% 股票universe，在外面取，因为有一定的变数
% universe = '000300.SH';
% stockArr = DH_E_S_IndexComps(universe,sDay,0);
% stockArr = DH_E_S_SELLTARGET(1,sDay,1);

NUMasset = size(stockArr,1);

%% 行业信息
% 申万行业
industry_sw1 = DH_S_INF_SW(stockArr,1,sDay);
industry_sw2 = DH_S_INF_SW(stockArr,2,sDay);
industry_zx1 = DH_S_INF_CITI(stockArr,1,sDay);
industry_zx2 = DH_S_INF_CITI(stockArr,2,sDay);
industry_zjh1 = DH_S_INF_CRSC(stockArr,1,sDay);
industry_zjh2 = DH_S_INF_CRSC(stockArr,2,sDay);

% 是否要取一个行业matrix？股票的行业属性是否经常变化？
% 耗时３０ｓ以上
% 从hs300来看，无一有变化
% tic
% for dt = 1:NUMday
%     tday = dateArr(dt,:);
%     industry_sw1 = DH_S_INF_SW(stockArr,1,tday);
%     for stk = 1:NUMasset
%         indCodeMat(dt,stk) = str2double( industry{stk,1} );
% %         tmp(stk,:) = industry{stk,1};        
%     end    
% %     indCodeMat(dt,:) = str2num(tmp)';
% end
% toc
%% 数据库取数据
% 1-不复权; 2-向后复权; 3-向前复权。缺省值为3。
fuquan = 3;

% Date *  Asset 
data1.closeMat    = DH_Q_DQ_Stock(stockArr,dateArr,'Close',fuquan)';
data1.openMat     = DH_Q_DQ_Stock(stockArr,dateArr,'Open',fuquan)';
data1.highMat     = DH_Q_DQ_Stock(stockArr,dateArr,'High',fuquan)';
data1.lowMat      = DH_Q_DQ_Stock(stockArr,dateArr,'Low',fuquan)';
data1.avgMat      = DH_Q_DQ_Stock(stockArr,dateArr,'AvgPrice',fuquan)';
data1.volumeMat   = DH_Q_DQ_Stock(stockArr,dateArr,'Volume',fuquan)';
data1.amountMat   = DH_Q_DQ_Stock(stockArr,dateArr,'Amount',fuquan)';
data1.changeMat   = DH_Q_DQ_Stock(stockArr,dateArr,'Change',fuquan)';
data1.retrnMat    = DH_Q_DQ_Stock(stockArr,dateArr,'PCTChange',fuquan)';
data1.tradableMat = double( DH_D_TR_IsTradingDay(stockArr,dateArr)' );%是int32类型


% 日内收益率，如果日初进，日末出，得到此收益
data1.dretrnMat = data1.closeMat./data1.openMat;
% 只在早晨换手的日收益率，用于回测计算，只好舍弃最后一日，全部置0
data1.retrn2Mat = data1.openMat(2:end,:)./data1.openMat(1:end-1,:) - 1; 
data1.retrn2Mat(end+1,:) = 0;
data1.retrn2Mat(isnan(data1.retrn2Mat)) = 0;


% 不复权的价格，供比较用（目标价 〉 实际价）
fuquan = 1;
data1.closeRTMat  = DH_Q_DQ_Stock(stockArr,dateArr,'Close',fuquan)';
data1.openRTMat   = DH_Q_DQ_Stock(stockArr,dateArr,'Open',fuquan)';
data1.highRTMat   = DH_Q_DQ_Stock(stockArr,dateArr,'High',fuquan)';
data1.lowRTMat    = DH_Q_DQ_Stock(stockArr,dateArr,'Low',fuquan)';
data1.avgRTMat    = DH_Q_DQ_Stock(stockArr,dateArr,'AvgPrice',fuquan)';


save('data1.mat', 'data1', '*Arr', 'industry*','NUM*');
end