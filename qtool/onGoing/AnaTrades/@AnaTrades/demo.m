clear;
clc;
%%
load('V:\1.���䳬\Pan.mat');

dayNo = 6;

dayTick = arrTicks(dayNo);
dayEL = arrEL(dayNo);
dayT = arrDate(dayNo);

plotTradeMap2(dayTick,dayEL,dayT);