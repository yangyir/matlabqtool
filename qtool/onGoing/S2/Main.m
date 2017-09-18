%% main 过程实现以下事件：

% 输入量：
%     s()函数
%     参数，如span、universe
%     后处理参数
% 
% 做什么：
%     1，读入数据矩阵
%     2，计算s()值
%     3，进行后处理：中性化、平滑化、归一化等
%     4，得到pos矩阵，trade矩阵
%     5，展示回测结果
% 
% 输出量：
%     回测结果
%     回测指标
%     回测作图
%
% ------------------------------
% 程刚，140915
% 程刚，140920，关于data1和data2的小更新
% 程刚，140923，加入了对不可交易股票的处理——保持数量仓位不变
% 程刚，141009，加入

%%
% clear;

tic
%% 输入参数
% 时间跨度
sDay = '2012-01-01';
eDay = '2013-12-31';

% 股票universe，未必给一个指数就能搞定
universe = '000300.SH';
% stockArr = DH_E_S_IndexComps(universe,sDay,0);
% universe = '融资融券标的';
% stockArr = DH_E_S_SELLTARGET(1,sDay,1);


% 中性化
% neutralizeMethod = '';
neutralizeMethod = '全市场';
% neutralizeMethod = '申万一级';
% neutralizeMethod = '申万二级';
% neutralizeMethod = '中信一级';
% neutralizeMethod = '中信二级';
% neutralizeMethod = '证监会一级';
% neutralizeMethod = '证监会二级';



% 指数平滑的alpha，如果为１，则相当于不用指数平滑方法
expSmoothAlpha = 0.6;

% 指数衰减的days，如果为０，则相当于不衰减
expDecayDays  = 10;

% 截尾百分比，[0,0.5]，两头截断，取最高和最低的truncatePct
truncatePct = 0.5;

% 最高仓位不超过，防止计算错误，或仓位过于集中,[0,1] 
maxPosition = 0.1;


% 换仓时间，'早盘换仓'或'尾盘换仓'，回测时使用不同价格
tradeTime = '早盘换仓';  % t日决策 -〉t+1日早盘  
% tradeTime = '尾盘换仓';  % t日决策 -〉t日尾盘 （此时其实还没有close）

% 是否重新取数据（如未改变span和universe则不需重新取）
% 0 - 不重新load，也不重新fetch （最省时间）
% 1 - 重新load  ***.mat（隔夜工作储存，可以事先储存好几套环境）
% 2 - 重新dhfetch（有改变就要重来，极其慢）
fetchData1Flag = 0; % basicData
fetchData2Flag = 0; % customerData


%% 取基础数据
Main15_basicData;

%% 取附加数据——用户定制数据
Main20_customerData;

%% 计算部分
% 计算s值, 今天的s值将影响明天的配置

sMat  = nan(NUMday, NUMasset);

for col = 1:NUMasset   
    
    code = stockArr(col);
    
    
    %% 基础数据加载
    flds = fields(data1);
    for i = 1:length(flds)
        fld = flds{i};
        varname = fld(1:end-3);
        eval( [varname '=data1.(fld)(:,col);'] );
    end
    
    %% 定制数据加载
    
    if exist('data2','var')
        flds = fields(data2);
        for i = 1:length(flds)
            fld = flds{i};
            varname = fld(1:end-3);
            eval( [varname '=data2.(fld)(:,col);'] );
        end
    end

        
    %% 真正写公式的地方
    % 写成过程也可以，一定要记得最后返回 s = ****;
    % 写成函数也可以，但是麻烦，要带参数   
    s_entry;     
    
    
       
    %% 放入score
    sMat(:,col)  = s;
end



%% 中性化 
switch neutralizeMethod
    case {'申万一级'}
        industry = industry_sw1;
    case {'申万二级'}
        industry = industry_sw2;
    case {'中信一级'}
        industry = industry_zx1;
    case {'中信一级'}
        industry = industry_zx2;
    case {'证监会一级'}
        industry = industry_zjh1;
    case {'证监会二级'}
        industry = industry_zjh2;
    case {'全市场'}
        industry = [];
        % 全市场中性化——相对于整体均值中性化
        sMat = sMat - nanmean(sMat,2)*ones(1,NUMasset);
    otherwise  % 不进行中性化
        industry = [];
end


% 相对于行业中性化，这个是很麻烦的事情，主要是：所属行业是否有变化？
% foreach 行业
%   求行业均值，减去行业均值
if ~isempty(industry)
for i = 1:NUMasset
    induCodes(i) = str2double( industry{i,1} );
end
[uniInduCodes, ia] = unique(induCodes);
uniInduCodes2 = industry(ia, 2);
for i = 1:length(uniInduCodes)
    % 行业信息
    thisInduCode = induCodes(i);
    uniInduCodes2(i)
    
    % 提取行业中股票对应index
    idx = find( induCodes == thisInduCode );
    
    
    % 行业内中性化—— 减去行业均值
    indAvg = nanmean( sMat(:,idx), 2 );
    sMat(:,idx) = sMat(:,idx) -  indAvg * ones(1, length(idx));
    % 之前nan的地方还是0
end
    
end

% 之前nan的地方还是0
sMat( isnan(sMat) ) = 0;
 
%% 平滑化
% 简单指数平滑
% for col = 1:NUMasset
%      s = sMat(:,col);
%      s1 = mv.expSmooth(s,expSmoothAlpha);
%      sMat(:,col) = s1;    
% end

% 指数衰减平滑，跟指数平滑基本是一个意思
for col = 1:NUMasset
    s = sMat(:,col);
    s1 = mv.expDecay(s, expDecayDays);
    sMat(:,col) = s1;
end


%% 截断
% 双向截断，只取最高和最低的truncatePct
for row = 1:NUMday
    srow = sMat(row,:);
    yLow = prctile(srow, truncatePct*100);
    yHi  = prctile(srow, 100-truncatePct*100);
    srow( srow < yHi & srow > yLow) = 0;
    sMat(row,:) = srow;
end



 
%% 归一化--long only
% % 这里不对，应该体现在ｔｒａｄｅ上
% sMat    = sMat.* tradableMat ;
% 
% % 抛弃
% ss      = sum(sMat, 2);
% pos_pct = sMat ./ ( ss*ones(1,NUMasset) );


%% 归一化——long short
[pos_pct, posL_pct, posS_pct]  = guiyihua(sMat);


%% 最高仓位控制，暂时只有warning
% [m, i] = max(pos_pct,[],2);
% if max(m) > maxPosition
%     fprintf('仓位超限：%0.2f > %0.2f\n', max(m), maxPosition);
% end
% 
% 
% 
% %% 校正——不可交易的股票不参与交易
% % 不可交易的股票数量不变，可交易的股票重分配可交易的金额
% 
% 
% % 
% % for dt = 3:NUMday
% %     
% %     
% %     
% % end
% 
% 
% 
% 
% %% 回测结果 - 粗，主要看个理论值
% % 换仓模式
% switch tradeTime
%     case '早盘换仓'
%         rMat = data1.retrn2Mat;
%     case '尾盘换仓'
%         rMat = data1.retrnMat;
%     otherwise
%         rMat = data1.retrn2Mat;
% end
% 
% 
% 
% pnlraw_ret  = zeros(NUMday,1);  
% pnlnet_ret  = zeros(NUMday,1);
% ts_fee      = zeros(NUMday,1);  % 当日手续费
% ts_turnover    = zeros(NUMday,1);
% ts_navRaw      = zeros(NUMday,1);  % 日末净值
% ts_navRaw(1)   = 1;
% for dt = 3:NUMday
%     dateArr(dt,:);
%     
%     d_pos_pct = pos_pct(dt-1,:) - pos_pct(dt-2,:);
%     fee   = sum(abs(d_pos_pct))/2 * 0.0015;
%     
%     pnlraw_ret(dt)  = rMat(dt,:) * pos_pct(dt-1,:)';
%     pnlnet_ret(dt)  = pnlraw_ret(dt) - fee;
%     ts_fee(dt)      = fee;
%     ts_turnover(dt)    = sum(abs(d_pos_pct))/2;
% end
% 
% pnlraw_ret( isnan(pnlraw_ret) ) = 0;

%% 作图
pnlraw_ret_cmpd = cumprod( pnlraw_ret+1)-1;
pnlraw_ret_smpl = cumsum(pnlraw_ret);
pnlnet_ret_cmpd = cumprod( pnlnet_ret+1)-1;
pnlnet_ret_smpl = cumsum(pnlnet_ret);

hfig202 = figure(202); hold off;
plot(pnlraw_ret_cmpd, 'b');
hold on;
% plot(pnlraw_ret_smpl, 'b-');
plot(pnlnet_ret_cmpd, 'r');
% plot(pnlnet_ret_smpl, 'r-');
% legend('raw pnl: compound', 'raw pnl: simple', 'net pnl: compound', 'net pnl:simple');
legend('rawPNL','netPNL');
title('粗估：累积PNL %');
grid on;



hfig210 = figure(210);hold off;
bar(ts_turnover);
title(sprintf('粗估：日换手率，均值%0.0f%%',mean(ts_turnover)*100));


%% 回测结果：精细，不可交易的股票deltaPos == 0
% pos_pct  = guiyihua(sMat, 'long short', data1.tradableMat);
pos_pct  = guiyihua(sMat);

% 统一按照早盘换仓计算
% 换仓模式
switch tradeTime
    case '早盘换仓'
        rMat = data1.retrn2Mat;
        price = data1.openMat;
    case '尾盘换仓'
        rMat = data1.retrnMat;
    otherwise
        rMat = data1.retrn2Mat;
end


pnlraw_ret  = zeros(NUMday,1);  
pnlnet_ret  = zeros(NUMday,1);
ts_fee      = zeros(NUMday,1);  % 当日手续费
ts_turnover = zeros(NUMday,1);
ts_pnl      = zeros(NUMday,1);
ts_navRaw   = zeros(NUMday,1);  % 日末净值
ts_navRaw(1:2)   = 1;
ts_navNet   = zeros(NUMday,1);  % 日末净值
ts_navNet(1:2)   = 1;


pos_Money   = zeros(NUMday, NUMasset); % 资金仓位
pos         = zeros(NUMday, NUMasset); % 数量仓位（精确)
dPos        = zeros(NUMday, NUMasset); % 交易：数量仓位变化
pos_lot     = zeros(NUMday, NUMasset); % 数量仓位（手）
dPos_lot    = zeros(NUMday, NUMasset); % 

% 一天一天走
for dt = 3:NUMday-1
    % 此时站在dt-1日收盘后（或dt-1日收盘前），也即dt日开盘前
    % 决定dt日持仓（以dt开盘价或dt-1收盘价），和换仓
    % 输出日期
%     dateArr(dt,:);
    open        = data1.openMat(dt,:);
%     tradable    = data1.tradableMat(dt,:);
    tradable    = ones(1, NUMasset);
    
    % nav(dt) 用次日开盘价计算（或当日收盘价计算）
    % pos_pct(dt-1,:) 是dt日的仓位——百分比仓位，dt-1日计算出
    % pos_Money(dt,:), pos(dt,:) 是dt日的仓位，dt日才能算出

    % 停牌股票不进行交易，pos不变，重分配
    navLongRe   = ts_navLongRaw(dt-1) - sum(pos(dt-1,:) .* (1-tradable) .* open);
    navRebalance = ts_navRaw(dt-1) - sum( pos(dt-1,:) .* (1-tradable) .* open );
    pos_Money(dt, tradable==1) = navRebalance * pos_pct(dt-1, tradable==1);
    pos_Money(dt, tradable==0) = pos(dt-1, tradable==0) .* open(tradable==0);
    
    pos(dt,:)       = pos_Money(dt,:) ./ open;
    dPos(dt,:)      = pos(dt,:) - pos(dt-1,:);

    % 换仓不应改变navRaw
    nav1 = sum(open.*pos(dt-1,:));
    nav2 = sum(open.*pos(dt,:));
    fprintf('换仓前nav：%0.2f，换仓后nav：%0.2f\n', nav1, nav2);
    
    
    % 涨跌停股票不进行交易，pos不变，posMoney变
    
    
    % 或者按买入、卖出分别算fee
    ts_turnover(dt) = sum(abs(dPos(dt,:).* open))/2;
    ts_fee(dt)      = sum(abs(dPos(dt,:).* open))/2 * 0.0015;
    % pnl(dt) 用次日开盘价计算（或当日收盘价计算）
    ts_pnl(dt)      = sum(data1.openMat(dt+1,:) .* pos(dt,:)) - sum(open.*pos(dt,:));
    
    % nav
    ts_navRaw(dt)  = ts_navRaw(dt-1) + ts_pnl(dt);
    ts_navNet(dt)  = ts_navNet(dt-1) + ts_pnl(dt) - ts_fee(dt);
    
    % return
    d_pos_pct = pos_pct(dt-1,:) - pos_pct(dt-2,:);
    fee   = sum(abs(d_pos_pct))/2 * 0.0015;
    
    pnlraw_ret(dt)  = rMat(dt,:) * pos_pct(dt-1,:)';
    pnlnet_ret(dt)  = pnlraw_ret(dt) - fee;
%     ts_fee(dt)      = fee;
%     ts_turnover(dt)    = sum(abs(d_pos_pct))/2;
%     pnlraw_ret(dt)  = ts_navRaw(dt)/ts_navRaw(dt-1) - 1 ;
%     pnlnet_ret(dt)  = ts_navNet(dt)/ts_navNet(dt-1) - 1;
%     
    % 计算持股数量（原始值，不舍入，用复权价计算），日末计算，次日晨持仓

    fprintf('%s, 可交易nav%0.1f%%\n',    dateArr(dt,:), navRebalance/ts_navRaw(dt-1)*100);

end


pnlraw_ret( isnan(pnlraw_ret) ) = 0;



figure(2); hold off
plot(ts_navRaw-1,'b');
hold on;
plot(ts_navNet-1, 'r');
legend('rawPNL','netPNL');
title('细估：累积PNL %');
grid on;   
%% 计算指标：sharpe ratio，收益率，回撤水平等


%% 作图
pnlraw_ret_cmpd = cumprod( pnlraw_ret+1)-1;
pnlraw_ret_smpl = cumsum(pnlraw_ret);
pnlnet_ret_cmpd = cumprod( pnlnet_ret+1)-1;
pnlnet_ret_smpl = cumsum(pnlnet_ret);

hfig202 = figure(202); hold off;
plot(pnlraw_ret_cmpd, 'b');
hold on;
% plot(pnlraw_ret_smpl, 'b-');
plot(pnlnet_ret_cmpd, 'r');
% plot(pnlnet_ret_smpl, 'r-');
% legend('raw pnl: compound', 'raw pnl: simple', 'net pnl: compound', 'net pnl:simple');
legend('rawPNL','netPNL');
title('粗估：累积PNL %');
grid on;



hfig210 = figure(210);hold off;
bar(ts_turnover);
title(sprintf('粗估：日换手率，均值%0.0f%%',mean(ts_turnover)*100));


%% 输出成word文档，便于留存
% Main55_printWordl;


%% 模拟盘结果 - 细，考虑各种实际问题
% 比如，凑整，涨停买不进，跌停卖不出，金额过于巨大时滑点
