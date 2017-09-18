load('Y:\qdata\IF\intraday_bars_30s_daily\IF0Y00_20130117.mat');
load('Y:\qdata\IF\intraday_bars_30s_daily\IF0Y00_20130108.mat');
load('Y:\qdata\IF\intraday_bars_30s_daily\IF0Y00_20130128.mat');

a = IF0Y00_20130117;
b = IF0Y00_20130108;
c = IF0Y00_20130128;


seq1 = a.close;
seq2 = b.open;
seq3 = c.close;
seq4 = a.open(2:end);
seq5 = b.high(3:end-1);
seq6 = c.vwap;


tmp = [seq1; seq2; seq3; seq4;seq5; seq6];
plot(tmp)

%% main

tic
resultseq = seq1;
resultseq = link2Seq(resultseq,seq2);
resultseq = link2Seq(resultseq,seq3);
resultseq = link2Seq(resultseq,seq4);
resultseq = link2Seq(resultseq,seq5);
resultseq = link2Seq(resultseq,seq6);

toc

figure
plot(resultseq);

%% main2
tic
seq_array = {seq1, seq2,seq3,seq4,seq5,seq6};
resultseq = linkSeqs( seq_array );
resultseq2 = linkSeqs( seq_array, 1 );
toc


figure
plot(resultseq);


%% plot
figure
plot(resultseq - resultseq2);