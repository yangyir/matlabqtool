%% *************************** isodata ****************************
% version1.0, luhuaibao
% 2014.5.30
% �����ֱ࣬�������Ļ������





%% ����r
% x = 20000 ; 
% t = ticks.time(x); 
% limitprice = ticks.bidP(x,1) ; 
% direction = 1 ; 
% [waiting, w_tk] = AnaTicks.r( ticks ,t,limitprice,direction )
% [waiting, w_tk] = AnaTicks.r( ticks ,t,limitprice,direction, 1 )




%% ����tao
% taovalue = AnaTicks.tao( ticks   );
% AnaTicks.plotTao(taovalue)



%% 
% [ bid_ask_spread ] = AnaTicks.bas( ticks );



%% ����atr
% vatr = AnaTicks.ATR(ticks,30 ) ; 


%% ������仯
%  [ r, idx ]  = AnaTicks.movingMax( ticks,30,'last' )
%  [ r, idx ]  = AnaTicks.movingMax( ticks,30,'bid' )
%   [ r, idx ]  = AnaTicks.movingMax( ticks,30,'ask' )
  
%  [ r, idx ]  = AnaTicks.movingMin( ticks,30,'last' )
%  [ r, idx ]  = AnaTicks.movingMin( ticks,30,'bid' )
%   [ r, idx ]  = AnaTicks.movingMin( ticks,30,'ask' )
%     
% vchg = AnaTicks.pctChg( ticks,5,'bid' )
% vchg = AnaTicks.chg( ticks,5,'bid' )




%% ���Բ���
% AnaTicks.vol(ticks )
% vol = AnaTicks.movingVol( ticks,30,'last' )




%% ����bas 
% [ bid_ask_spread ] = AnaTicks.bas( ticks, 1, 1 ) ; 




%% test plot
% AnaTicks.histBas(ticks,1,1)
% AnaTicks.plotBas(ticks)
% AnaTicks.plot_lastVolume(ticks)
% iplot.ts1_ts2_spread(ticks.askP(:,1),ticks.bidP(:,1))
% AnaTicks.histDiff(ticks)

cur = 101;
win = 30 ; 
AnaTicks.plot_orderDepth( ticks ,cur, win  )




%% ����bid/ask/last�ߵ͹�ϵ
% AnaTicks.highLowRelation(ticks)






%% test delta
% deltavalue = AnaTicks.delta(ticks,ticks )





%% test maxSince, minSince, percentile, maxof, minof 
% currentTk = 15 ; 
% type = 'bid';
% [t, tk] = AnaTicks.maxSince( ticks, currentTk, type)
% plot(ticks.bidP(1:currentTk,1))
%  
% [t, tk] = AnaTicks.minSince( ticks, currentTk, type)
% plot(ticks.bidP(1:currentTk,1))
% 
% 
% [prct] = AnaTicks.percentile( ticks, currentTk, type)
% 
% len = 30 ; 
% [mx,tk,t] = AnaTicks.maxof( ticks, currentTk, len, type)
% plot(ticks.bidP(1:currentTk+len,1))
% hold on
% plot(currentTk+1:currentTk+tk,ticks.bidP(currentTk+1:currentTk+tk,1),'ro')
% hold off
% % ��movingMax�������Ƚ�
% [ r, idx ]  = AnaTicks.movingMax( ticks,-len,type ) ;
% r(currentTk) - mx
% 
% 
% [mx,tk,t] = AnaTicks.minof( ticks, currentTk, len, type)
% plot(ticks.bidP(1:currentTk+len,1))
% hold on
% plot(currentTk+1:currentTk+tk,ticks.bidP(currentTk+1:currentTk+tk,1),'ro')
% hold off
% % ��movingMax�������Ƚ�
% [ r, idx ]  = AnaTicks.movingMin( ticks,-len,type ) ;
% r(currentTk) - mx