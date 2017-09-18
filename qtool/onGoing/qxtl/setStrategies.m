%% 策略

% hist_bars* 成为历史，现在用hist_名字
global strategyName;


strategyName = containers.Map('KeyType','int32','ValueType','char');
strategyName(2) = 'Kp';
strategyName(3) = 'TsiMfi';
strategyName(4) = 'WillrMfi';
strategyName(10) = 'openGap';
strategyName(11) = 'MA';
strategyName(13) = 'PR';
strategyName(14) = 'RkdjMacd';
strategyName(88) = 'Manual';

%% ********************************************************
strategyName(821) = 'IFqxtl'; % IF期现套利，程刚，试验

% *****************************************************************


%%
strategyNum = length(strategyName);
strategyMap  = containers.Map('KeyType','char','ValueType','int32');

strategyNoArr = strategyName.keys;
strategyNameArr = strategyName.values;

for i = 1:strategyNum
    strategyMap(strategyNameArr{i}) = strategyNoArr{i};
end

clear strategyNoArr strategyNameArr
%% REGISTER YOUR STRATEGY HERE

global s_Kp;
s_Kp = QStrategyKp_V2(2,strategyName(2),1,{IFHotName},...
    IFHot_006000000, IFHotTickData, hist_IFHot_006000000, 1, 0.004, 0.0075, 0.006, 1 );
            
global s_TsiMfi;
s_TsiMfi = QStrategyTsiMfi_V3(3,strategyName(3),1,{IFHotName},...
    IFHot_018000000, IFHotTickData, hist_IFHot_018000000, 1,0930000,1445000,13,25,14,80,20,25,60,2,0.01,1 );
 
global s_WillrMfi;
s_WillrMfi = QStrategyWillrMfi_V2(4,strategyName(4),1,{IFHotName},...
    IFHot_018000000, IFHotTickData, hist_IFHot_018000000, 1,0930000,1445000,60,14,14,4,2,0.01,1 );

global s_openGap;
s_openGap = QStrategyGap_V2(10,strategyName(10),1,{IFHotName},...
    IFHot_006000000, IFHotTickData, hist_IFHot_006000000, 1,60,3,0.0075,11,3  );

global s_MA;
s_MA = QStrategyMA(11,strategyName(11),1,{IFHotName},...
    IFHot_006000000, IFHotTickData, hist_IFHot_006000000, 1,0930000,1445000,60,12,26,9,3,3.5,0.0075,0.006,1 );
 
global s_PR;
s_PR = QStrategyPR(13,strategyName(13),1,{IFHotName},...
    IFHot_006000000, IFHotTickData, hist_IFHot_006000000, 1,0948000,1445000,3000,4500,1500,3,4,0.0075,0.005,3, 1,2, 30  );

global s_RkdjMacd;
s_RkdjMacd = QStrategyRkdjMacd(14,strategyName(14),1,{IFHotName},...
    IFHot_006000000, IFHotTickData, hist_IFHot_006000000, 1,0930000,1445000,60,12,26,9,25,75,4,4,0.0075,0.005,2,1  );     

global s_Manual;
s_Manual = QManual(88,strategyName(88),1,{IFHotName}, IFHotTickData);

%% **************************************************************************
% 程刚，IF跨期套利，测试

% 当日成分股Ticks指针
workpath = 'V:\root\qtool\onGoing\qxtl\';
dt = datestr(today, 'yyyy-mm-dd');
% 读取arrCode和arrWt
load([workpath '\param\arrCode_' dt '.mat'] );
load([workpath '\param\arrWt_' dt '.mat'] );


for icd = 1:length(arrCode)
    code    = arrCode{icd};
    varname = [code(8:9), code(1:6), 'TickData'];
    eval([ 'a(icd) = ' varname] );
end   

% IF 和 沪深300 行情指针
IF0Ticks    = IF1409TickData;
csi300Ticks = SH000300TickData;


% StrategyNo      = 821;
% StrategyName    = 'IFqxtl';
InstrumentNum   = length(a) + 1;
for i = 1:length(a)
    InstrumentName{i} = a(i).code;
end
InstrumentName{end+1} = IF0Ticks.code;


global s_IFqxtl_821;
s_IFqxtl_821 = QStrategy_IFqxtl(821,strategyName(821),InstrumentNum,InstrumentName, ...
    dt, IF0Ticks, a, csi300Ticks, arrCode, arrWt);


% ************************************************************************************

%% 配置策略开关
activatedSName ={'Kp','TsiMfi','WillrMfi','openGap','MA','PR','RkdjMacd','Manual', 'IFqxtl'};

activeSList = zeros(strategyNum,1);
for i = 1:length(activatedSName)
    activeSList(i) = strategyMap(activatedSName{i});
end
activeSNum = i;

if activeSNum<strategyNum
    activeSList(activeSNum+1:end) = [];
end