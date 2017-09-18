clear;
clc;
%%
load('V:\1.≈À∆‰≥¨\Pan.mat');

dayNo = 6;

dayTick = arrTicks(dayNo);
dayEL = arrEL(dayNo);
dayT = arrDate(dayNo);

plotTradeMap2(dayTick,dayEL,dayT);