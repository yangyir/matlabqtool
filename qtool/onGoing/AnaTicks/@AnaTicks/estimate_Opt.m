function  estimate_Opt( dataPath )
%ESTIMATE_OPT      期权参数估计
% 加载数据，计算基本统计量
% dataPath例子：'V:\1.陆怀宝\option\交易机会及参数评估\data\20140530.mat'
% version 1.0, luhuaibao, 2014.5.24

%% 加载数据
load(dataPath);

%%
% QQ = {'SO510050Opt','SO510180Opt','SO600095Opt','SO600104Opt','SO601318Opt'} ; 
QQ = {'SO510050Opt','SO510180Opt','SO600104Opt','SO601318Opt'} ; 
TS = [0.0001,0.0001,0.001,0.001,0.001];
for k  = 1:4
qqName = QQ{k} ; 
tickSize = TS(k) ; 
eval(['qq = ',qqName,';']);
%% 
qqMap = qq.optionTicksMap ; 
optvalues = values(qqMap);

nc = length(optvalues) ; 

% 合约名称
cName = cell(nc,1);
% tick数
nTicks = nan(nc,1) ; 
% 交易量
volume = nan(nc,1);
% 持仓量
openInt = nan(nc,1) ; 
% 价差百分位
% 
nVolumeChg = nan(nc,1) ; 
abSpread = nan(nc,9);
prc = [ 10 20 30 40 50 60 70 80 90 ];

for i = 1:nc
    nTicks(i) = optvalues{i}.latest ; 
    if nTicks(i) > 0 
        cName{i} = optvalues{i}.code ;
        volume(i) = optvalues{i}.volume(nTicks(i));
        openInt(i) = optvalues{i}.openInt(nTicks(i));
        ab = optvalues{i}.askP(:,1) - optvalues{i}.bidP(:,1);
        ab = ab(1:nTicks(i));
        abSpread(i,:) = prctile(ab,prc);
        nVolumeChg(i,1) = sum(diff(optvalues{i}.volume)>0);
    end ; 
end ; 


%% 
output = cell(nc+1,14);
output(1,:) = [{'合约名称'},{'tick数'},{'交易量'},{'持仓量'},{'ab10分位数'},...
    {'ab20分位数'},{'ab30分位数'},{'ab40分位数'},{'ab50分位数'},...
    {'ab60分位数'},{'ab70分位数'},{'ab80分位数'},{'ab90分位数'},...
    {'交易次数'}];
output(2:end,1) = cName ; 
output(2:end,2) = num2cell(nTicks);
output(2:end,3) = num2cell(volume);
output(2:end,4) = num2cell(openInt);
output(2:end,5:13) = num2cell(abSpread/tickSize);
output(2:end,14) = num2cell(nVolumeChg);


%% write to excel 
xlswrite(['V:\1.陆怀宝\option\交易机会及参数评估\output.xlsx'],output,qqName);



end

