clear ; 
addpath(genpath(pwd));

%% 加载数据
load('bars.mat');
load('nextbars.mat');
n = size( nextbars.close, 1 ) ; 

result{1,1} = '指标' ; 
result{1,2} = '计算结果对比' ; 
result{1,3} = '现耗时' ; 
result{1,4} = '原耗时' ; 
result{1,5} = '效率比' ; 




%% *************************** rsi ******************************
%% 初始化
rsi = CRsi( bars, 14 ); % 初始化指标的类，rsi已经是个类了


%% 后续增量测试
tic 
for i = 1:n
    
    rsi.bars.time( end + 1 )    = nextbars.time(i);
    rsi.bars.open( end + 1 )    = nextbars.open(i) ; 
    rsi.bars.close( end + 1 )   = nextbars.close(i) ; 
    rsi.bars.high( end + 1 )    = nextbars.high(i) ; 
    rsi.bars.low(  end + 1 )    = nextbars.low(i) ; 
    rsi.bars.volume(end + 1)    = nextbars.volume(i) ; 
    
    rsi.rsiNew() ; 

end; 
time1rsi = toc ; 

%% 结果比较


tic
[ rsiVal, rsVal] = ind.rsi( bars.close, 14) ; 
time2rsi = toc ; 

result{2,1} = 'rsi' ; 
if rsi.rsiVal(~isnan(rsi.rsiVal)) == rsiVal(~isnan(rsiVal)) & rsi.rsVal(~isnan(rsi.rsVal)) == rsVal(~isnan(rsVal)) 
    result{2,2} = '一致' ;    
    result{2,3} = time1rsi ; 
    result{2,4} = 270*time2rsi ; 
    result{2,5} = 270*time2rsi/time1rsi ; 
else 
    result{2,2} = 'wrong' ; 
end ;




%% *************************** rsiMC ******************************
load('bars.mat');
load('nextbars.mat');
n = size( nextbars.close, 1 ) ; 
%% 初始化
rsiMC = CRsiMC( bars, 14 ) ;   


%% 后续增量测试
tic 
for i = 1:n
    
    rsiMC.bars.time( end + 1 )    = nextbars.time(i);
    rsiMC.bars.open( end + 1 )    = nextbars.open(i) ; 
    rsiMC.bars.close( end + 1 )   = nextbars.close(i) ; 
    rsiMC.bars.high( end + 1 )    = nextbars.high(i) ; 
    rsiMC.bars.low(  end + 1 )    = nextbars.low(i) ; 
    rsiMC.bars.volume(end + 1)    = nextbars.volume(i) ; 
    
    rsiMC.rsiMCAdd() ; 

end; 
time1rsi = toc ; 

%% 结果比较


%% 结果比较


tic
[ rsiVal ] = ind.rsiMC( bars, 14) ; 
time2rsi = toc ; 

result{3,1} = 'rsiMC' ; 
if rsiMC.rsi(~isnan(rsiMC.rsi)) == rsiVal(~isnan(rsiVal)) 
    result{3,2} = '一致' ;    
    result{3,3} = time1rsi ; 
    result{3,4} = 270*time2rsi ; 
    result{3,5} = 270*time2rsi/time1rsi ; 
else 
    result{3,2} = 'wrong' ; 
end ;





%% *************************** ema ******************************
load('bars.mat');
load('nextbars.mat');
n = size( nextbars.close, 1 ) ; 
%% 初始化
ema = CMa( bars, bars.close, 14, 'e' ) ;  % 初始化指标的类，ma已经是个类了


%% 后续增量测试
tic 
for i = 1:n
    
    ema.bars.time( end + 1 )    = nextbars.time(i);
    ema.bars.open( end + 1 )    = nextbars.open(i) ; 
    ema.bars.close( end + 1 )   = nextbars.close(i) ; 
    ema.bars.high( end + 1 )    = nextbars.high(i) ; 
    ema.bars.low(  end + 1 )    = nextbars.low(i) ; 
    ema.bars.volume(end + 1)    = nextbars.volume(i) ; 
    
    ema.price = ema.bars.close ; % 使用时一定得使用更新后的数据，所以一定要注意，类化后使用了几个数据源，保证都更新
    ema.maAdd() ; 

end; 
time1rsi = toc ; 

%% 结果比较


tic
[maVal] = ind.ma(bars.close,14,'e') ; 
time2rsi = toc ; 

result{4,1} = 'ema' ; 
if ema.maVal(~isnan(ema.maVal)) == maVal(~isnan(maVal)) 
    result{4,2} = '一致' ;    
    result{4,3} = time1rsi ; 
    result{4,4} = 270*time2rsi ; 
    result{4,5} = 270*time2rsi/time1rsi ; 
else 
    result{4,2} = 'wrong' ; 
end ;




%% *************************** sma ******************************
load('bars.mat');
load('nextbars.mat');
n = size( nextbars.close, 1 ) ; 
%% 初始化
sma = CMa( bars, bars.close, 14, 0 ) ;  % 初始化指标的类，ma已经是个类了


%% 后续增量测试
tic 
for i = 1:n
    
    sma.bars.time( end + 1 )    = nextbars.time(i);
    sma.bars.open( end + 1 )    = nextbars.open(i) ; 
    sma.bars.close( end + 1 )   = nextbars.close(i) ; 
    sma.bars.high( end + 1 )    = nextbars.high(i) ; 
    sma.bars.low(  end + 1 )    = nextbars.low(i) ; 
    sma.bars.volume(end + 1)    = nextbars.volume(i) ; 
    
    sma.price = sma.bars.close ; 
    sma.maAdd() ; 

end; 
time1rsi = toc ; 

%% 结果比较


tic
[maVal] = ind.ma(bars.close,14,0) ; 
time2rsi = toc ; 

result{5,1} = 'sma' ; 
if max( abs(sma.maVal(~isnan(sma.maVal)) - maVal(~isnan(maVal)) )) < 10^-5
    result{5,2} = '一致' ;    
    result{5,3} = time1rsi ; 
    result{5,4} = 270*time2rsi ; 
    result{5,5} = 270*time2rsi/time1rsi ; 
else 
    result{5,2} = 'wrong' ; 
end ;





%% *************************** macd ******************************
load('bars.mat');
load('nextbars.mat');
n = size( nextbars.close, 1 ) ; 
%% 初始化
cmacd = CMacd( bars, bars.close, 12, 26, 9 ) ;  % 初始化指标的类，cmacd已经是个类了


%% 后续增量测试
tic 
for i = 1:n
    
    cmacd.bars.time( end + 1 )    = nextbars.time(i);
    cmacd.bars.open( end + 1 )    = nextbars.open(i) ; 
    cmacd.bars.close( end + 1 )   = nextbars.close(i) ; 
    cmacd.bars.high( end + 1 )    = nextbars.high(i) ; 
    cmacd.bars.low(  end + 1 )    = nextbars.low(i) ; 
    cmacd.bars.volume(end + 1)    = nextbars.volume(i) ; 
    
    cmacd.price = cmacd.bars.close ; 
    cmacd.macdAdd() ; 

end; 
time1rsi = toc ; 

%% 结果比较


tic
[difVal, deaVal, barVal] = ind.macd(bars.close, 12, 26 ,9) ; 
time2rsi = toc ; 

result{6,1} = 'macd' ; 
if cmacd.dif(~isnan(cmacd.dif)) == difVal(~isnan(difVal)) & cmacd.dea(~isnan(cmacd.dea)) == deaVal(~isnan(deaVal)) ...
        & cmacd.macd(~isnan(cmacd.macd)) == barVal(~isnan(barVal)) 
    result{6,2} = '一致' ;    
    result{6,3} = time1rsi ; 
    result{6,4} = 270*time2rsi ; 
    result{6,5} = 270*time2rsi/time1rsi ; 
else 
    result{6,2} = 'wrong' ; 
end ;






%% *************************** kdj ******************************
load('bars.mat');
load('nextbars.mat');
n = size( nextbars.close, 1 ) ; 
%% 初始化
ckdj = CKdj( bars, 14, 4, 3 ) ;  % 初始化指标的类 


%% 后续增量测试
tic 
for i = 1:n
    
    ckdj.bars.time( end + 1 )    = nextbars.time(i);
    ckdj.bars.open( end + 1 )    = nextbars.open(i) ; 
    ckdj.bars.close( end + 1 )   = nextbars.close(i) ; 
    ckdj.bars.high( end + 1 )    = nextbars.high(i) ; 
    ckdj.bars.low(  end + 1 )    = nextbars.low(i) ; 
    ckdj.bars.volume(end + 1)    = nextbars.volume(i) ; 
    
    ckdj.kdjAdd() ; 

end; 
time1rsi = toc ; 

%% 结果比较


tic
[k,d,j] = ind.kdj(bars.close,bars.high,bars.low,14, 4, 3) ; 
time2rsi = toc ; 

result{7,1} = 'kdj' ; 
if max( abs(ckdj.k(~isnan(ckdj.k)) - k(~isnan(k))) ) < 10^-5 & max(abs(ckdj.d(~isnan(ckdj.d)) - d(~isnan(d)) ))< 10^-5  ...
        & max(abs(ckdj.j(~isnan(ckdj.j)) - j(~isnan(j)) ))< 10^-5 
    result{7,2} = '一致' ;    
    result{7,3} = time1rsi ; 
    result{7,4} = 270*time2rsi ; 
    result{7,5} = 270*time2rsi/time1rsi ; 
else 
    result{7,2} = 'wrong' ; 
end ;



%% *************************** kdjMC简单平滑 ******************************
load('bars.mat');
load('nextbars.mat');
n = size( nextbars.close, 1 ) ; 
%% 初始化
ckdjMC = CKdjMC( bars, 14, 4, 3, 1 ) ;  % 初始化指标的类 


%% 后续增量测试
tic 
for i = 1:n
    
    ckdjMC.bars.time( end + 1 )    = nextbars.time(i);
    ckdjMC.bars.open( end + 1 )    = nextbars.open(i) ; 
    ckdjMC.bars.close( end + 1 )   = nextbars.close(i) ; 
    ckdjMC.bars.high( end + 1 )    = nextbars.high(i) ; 
    ckdjMC.bars.low(  end + 1 )    = nextbars.low(i) ; 
    ckdjMC.bars.volume(end + 1)    = nextbars.volume(i) ; 
    
    ckdjMC.kdjAdd() ; 

end; 
time1rsi = toc ; 

%% 结果比较


tic
[k,d,j] = ind.kdjMC(bars.close,bars.high,bars.low,14, 4, 3, 1) ; 
time2rsi = toc ; 

result{8,1} = 'kdjMC简单平滑' ; 
if max( abs(ckdjMC.k(~isnan(ckdjMC.k)) - k(~isnan(k))) ) < 10^-3 & max(abs(ckdjMC.d(~isnan(ckdjMC.d)) - d(~isnan(d)) ))< 10^-3  ...
        & max(abs(ckdjMC.j(~isnan(ckdjMC.j)) - j(~isnan(j)) ))< 10^-3 
    result{8,2} = '一致' ;    
    result{8,3} = time1rsi ; 
    result{8,4} = 270*time2rsi ; 
    result{8,5} = 270*time2rsi/time1rsi ; 
else 
    result{8,2} = 'wrong' ; 
end ;






%% *************************** kdjMC指数平滑 ******************************
load('bars.mat');
load('nextbars.mat');
n = size( nextbars.close, 1 ) ; 
%% 初始化
ckdjMC = CKdjMC( bars, 14, 3, 3, 1 ) ;  % 初始化指标的类 


%% 后续增量测试
tic 
for i = 1:n
    
    ckdjMC.bars.time( end + 1 )    = nextbars.time(i);
    ckdjMC.bars.open( end + 1 )    = nextbars.open(i) ; 
    ckdjMC.bars.close( end + 1 )   = nextbars.close(i) ; 
    ckdjMC.bars.high( end + 1 )    = nextbars.high(i) ; 
    ckdjMC.bars.low(  end + 1 )    = nextbars.low(i) ; 
    ckdjMC.bars.volume(end + 1)    = nextbars.volume(i) ; 
    
    ckdjMC.kdjAdd() ; 

end; 
time1rsi = toc ; 

%% 结果比较


tic
[k,d,j] = ind.kdjMC(bars.close,bars.high,bars.low,14, 3, 3, 1) ; 
time2rsi = toc ; 

result{9,1} = 'kdjMC指数平滑' ; 
if max( abs(ckdjMC.k(~isnan(ckdjMC.k)) - k(~isnan(k))) ) < 10^-3 & max(abs(ckdjMC.d(~isnan(ckdjMC.d)) - d(~isnan(d)) ))< 10^-3  ...
        & max(abs(ckdjMC.j(~isnan(ckdjMC.j)) - j(~isnan(j)) ))< 10^-3 
    result{9,2} = '一致' ;    
    result{9,3} = time1rsi ; 
    result{9,4} = 270*time2rsi ; 
    result{9,5} = 270*time2rsi/time1rsi ; 
else 
    result{9,2} = 'wrong' ; 
end ;






%% *************************** mtm ******************************
load('bars.mat');
load('nextbars.mat');
n = size( nextbars.close, 1 ) ; 
%% 初始化
cmtm = CMtm( bars, bars.close, 10 ) ;  % 初始化指标的类 


%% 后续增量测试
tic 
for i = 1:n
    
    cmtm.bars.time( end + 1 )    = nextbars.time(i);
    cmtm.bars.open( end + 1 )    = nextbars.open(i) ; 
    cmtm.bars.close( end + 1 )   = nextbars.close(i) ; 
    cmtm.bars.high( end + 1 )    = nextbars.high(i) ; 
    cmtm.bars.low(  end + 1 )    = nextbars.low(i) ; 
    cmtm.bars.volume(end + 1)    = nextbars.volume(i) ; 
    
    cmtm.price = bars.close ; 
    cmtm.mtmAdd() ; 

end; 
time1rsi = toc ; 

%% 结果比较


tic
vmtm = ind.mtm(bars.close,10) ; 
time2rsi = toc ; 

result{10,1} = 'mtm' ; 
if max( abs(cmtm.mtm(~isnan(cmtm.mtm)) - vmtm(~isnan(vmtm))) ) < 10^-5  
    result{10,2} = '一致' ;    
    result{10,3} = time1rsi ; 
    result{10,4} = 270*time2rsi ; 
    result{10,5} = 270*time2rsi/time1rsi ; 
else 
    result{10,2} = 'wrong' ; 
end ;









%% *************************** tsi ******************************
load('bars.mat');
load('nextbars.mat');
n = size( nextbars.close, 1 ) ; 
%% 初始化
ctsi = CTsi( bars, bars.close, 13, 25 ) ;  % 初始化指标的类 


%% 后续增量测试
tic 
for i = 1:n
    
    ctsi.bars.time( end + 1 )    = nextbars.time(i);
    ctsi.bars.open( end + 1 )    = nextbars.open(i) ; 
    ctsi.bars.close( end + 1 )   = nextbars.close(i) ; 
    ctsi.bars.high( end + 1 )    = nextbars.high(i) ; 
    ctsi.bars.low(  end + 1 )    = nextbars.low(i) ; 
    ctsi.bars.volume(end + 1)    = nextbars.volume(i) ; 
    
	ctsi.price = bars.close ; 
    ctsi.tsiAdd() ; 

end; 
time1rsi = toc ; 

%% 结果比较


tic
vtsi = ind.tsi ( bars.close, 13, 25 );
time2rsi = toc ; 

result{11,1} = 'tsi' ; 
if max( abs(ctsi.tsi(~isnan(ctsi.tsi)) - vtsi(~isnan(vtsi))) ) < 10^-5  
    result{11,2} = '一致' ;    
    result{11,3} = time1rsi ; 
    result{11,4} = 270*time2rsi ; 
    result{11,5} = 270*time2rsi/time1rsi ; 
else 
    result{11,2} = 'wrong' ; 
end ;









%% 显示结果
disp(result)