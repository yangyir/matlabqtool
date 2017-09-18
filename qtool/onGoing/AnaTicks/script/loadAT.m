%% *************************** 加载数据 ****************************
% 2014.5.30：
% 加载数据，并处理数据，供后面程序使用。

% version 1.0, luhuaibao, 2014.5.30




%% 股指期货数据
code = 'IFHot' ;
sd = '20130624' ;
ed = '20130624' ;

 
% 取基础数据
try
    load( [code,'_',sd,'_',ed, '.mat'] ) ;
catch e
    ticks = Fetch.dmTicks(code,sd,ed);
    save( [savePathData,code,'_',sd,'_',ed,'.mat'], 'ticks' ) ;
end ;




% 数据信息
nt      = size(ticks.time,1);
nday    = size(unique ( floor(ticks.time) ),1) ;


%% 股指和股票数据
load( [savePathData, '\tick_data.mat'])

