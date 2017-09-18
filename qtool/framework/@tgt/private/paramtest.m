
function sta=paramtest(data)
para=0.005:0.005:0.2;
timespan=length(data);
dsize=length(para);
sta=zeros(dsize,2);
for i=1:dsize
    mu1=para(i);
    mu2=mu1;
    [textrema]=trendextrema(data,mu1,mu2);
    sta(i,1)=mu1;
    sta(i,2)=length(textrema);
    sta(i,3)=timespan/sta(i,2);
end