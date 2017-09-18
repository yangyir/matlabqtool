clear all; rehash;

a = 1:1:9;
b = [num2str(a(:))];

fq = QuoteFuture;
fq.code = 'IH1603';
fq.futureName = 'IH1603';

mp = containers.Map('KeyType', 'char', 'ValueType', 'any');
mp(fq.code) = fq;


