function [ ratio ] = last_bid_ask_relation( ticks, displayFlag )
%LAST_BID_ASK_RELATION 很简单的功能：统计last 与ask，bid的大小关系
% 程刚，20140723

%% 
if ~exist('displayFlag', 'var'), displayFlag = 1 ; end
%%

l = ticks.last;
b = ticks.bidP(:,1);
a = ticks.askP(:,1);
len = length(l);

%%
ratio(1) = sum(l>a)/len;
ratio(2) = sum(l == a) /len;
ratio(3) = sum(l<a & l>b) /len;
ratio(4) = sum(l == b) /len;
ratio(5) = sum(l<b) / len;

%% 
if displayFlag > 0
    fprintf(' last  >  ask1   : %4.1f%% \n',  ratio(1)*100 );
    fprintf(' last  ==  ask1  : %4.1f%% \n',  ratio(2)*100 );
    fprintf(' ask1>last>bid1  : %4.1f%% \n',  ratio(3)*100 );
    fprintf(' last  ==  bid1  : %4.1f%% \n',  ratio(4)*100 );
    fprintf(' bid1  >  last   : %4.1f%% \n',  ratio(5)*100 );
end

