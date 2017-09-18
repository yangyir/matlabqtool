function [ infoRatio ] = infoRatio( port, benchmark, flag)
%% Calculate information ratio of portfolio
% 
%%
if nargin == 2
    flag = 'pct';
end

if strcmp( flag, 'val');
    port = log(port(2:end,:)./port(1:end-1,:));
    benchmark = log(benchmark(2:end,:)./benchmark(1:end-1,:));
end

alpha = port - benchmark;
avgAlpha = mean(alpha);
annualAlpha = avgAlpha*250;
stdAlpha = std(alpha);
annualStdAlpha = stdAlpha*sqrt(250);
infoRatio = annualAlpha/annualStdAlpha;

end

