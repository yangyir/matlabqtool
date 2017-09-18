clear;
clc;
%%
addpath(genpath('C:\Users\Administrator\Desktop\qp\HMH\8.0_20140623\M_Pool\qtool\framework'));

load('V:\1.≈À∆‰≥¨\Pan.mat');

dayNo = 6;

dayTick1 = arrTicks(dayNo);
dayEL1 = arrEL(dayNo);
dayT1 = arrDate(dayNo);
dayEL1.strategyNo(1:dayEL1.latest) = 1;
dayEL1.strategyNo(1:4) = 3;
dayEL1.time(1:dayEL1.latest) = dayEL1.time(1:dayEL1.latest)+dayT1;

TL1 = TradeList(200);
TL1.instrumentNo = dayEL1.instrumentNo;
TL1.time = dayEL1.time;
TL1.volume = dayEL1.volume;
TL1.direction = dayEL1.direction;
TL1.offSetFlag = dayEL1.offSetFlag;
TL1.latest = dayEL1.latest;
TL1.time = dayEL1.time;
TL1.price = dayEL1.price;
TL1.strategyNo = dayEL1.strategyNo;
TL1.roundNo = dayEL1.roundNo;



dayNo = 7;
dayTick2 = arrTicks(dayNo);
dayEL2 = arrEL(dayNo);
dayT2 = arrDate(dayNo);
dayEL2.strategyNo(1:dayEL2.latest) = 1;
dayEL2.time(1:dayEL2.latest) = dayEL2.time(1:dayEL2.latest)+dayT2;

TL2 = TradeList(200);
TL2.instrumentNo = dayEL2.instrumentNo;
TL2.time = dayEL2.time;
TL2.volume = dayEL2.volume;
TL2.direction = dayEL2.direction;
TL2.offSetFlag = dayEL2.offSetFlag;
TL2.latest = dayEL2.latest;
TL2.time = dayEL2.time;
TL2.price = dayEL2.price;
TL2.strategyNo = dayEL2.strategyNo;
TL2.roundNo = dayEL2.roundNo;


dayEL3 = dayEL1;
dayEL3.instrumentNo(dayEL3.latest+1:dayEL3.latest+dayEL2.latest) = dayEL2.instrumentNo(1:dayEL2.latest)+1;
dayEL3.time(dayEL3.latest+1:dayEL3.latest+dayEL2.latest) = dayEL2.time(1:dayEL2.latest);
dayEL3.volume(dayEL3.latest+1:dayEL3.latest+dayEL2.latest) = dayEL2.volume(1:dayEL2.latest);
dayEL3.direction(dayEL3.latest+1:dayEL3.latest+dayEL2.latest) = dayEL2.direction(1:dayEL2.latest);
dayEL3.offSetFlag(dayEL3.latest+1:dayEL3.latest+dayEL2.latest) = dayEL2.offSetFlag(1:dayEL2.latest);
dayEL3.price(dayEL3.latest+1:dayEL3.latest+dayEL2.latest) = dayEL2.price(1:dayEL2.latest);
dayEL3.strategyNo(dayEL3.latest+1:dayEL3.latest+dayEL2.latest) = dayEL2.strategyNo(1:dayEL2.latest);
dayEL3.roundNo(dayEL3.latest+1:dayEL3.latest+dayEL2.latest) = dayEL2.roundNo(1:dayEL2.latest);
dayEL3.latest = dayEL3.latest+dayEL2.latest;


TL3 = TradeList(200);
TL3.instrumentNo = dayEL3.instrumentNo;
TL3.time = dayEL3.time;
TL3.volume = dayEL3.volume;
TL3.direction = dayEL3.direction;
TL3.offSetFlag = dayEL3.offSetFlag;
TL3.latest = dayEL3.latest;
TL3.price = dayEL3.price;
TL3.strategyNo = dayEL3.strategyNo;
TL3.roundNo = dayEL3.roundNo;


clearvars -except TL* day*

save testPack.mat

% plotTradeMap2(dayTick,dayEL,dayT);