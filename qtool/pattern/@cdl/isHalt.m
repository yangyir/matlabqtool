function [ indHalt ] = isHalt( ~,bars )
%% 
%
%%
indLine = bars.high==bars.low;
indLast = bars.close(1:end-1)==bars.close(2:end);
indLast = vertcat(0,indLast);

indHalt = indLast&indLine;


end

