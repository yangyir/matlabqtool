function [ ] = label_pattern( bars,ind,varargin )
%%
%
%%
index = find(ind);
high = bars.high(index);
plot(index,high,'*r','MarkerSize',10);

if nargin == 3
    patternName = varargin{1};
    legend(patternName);
end

hold on
candle(bars.high,bars.low,bars.close,bars.open);
ylabel('adjusted price');
xlabel('time series');



end