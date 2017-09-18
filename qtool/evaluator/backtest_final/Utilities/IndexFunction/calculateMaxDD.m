%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 这个函数用来计算收益率最大回撤、最大回撤比和最大回撤期
% （maximum drawdown maximum drawdownratio and maximum drawdown duration）
% 已经达到它们的序号，用以计算达到时间
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [maxDrawDown,MDDs,MDDe,maxDDD,m_index3] = ...
    calculateMaxDD(account,bars,configure)

lowLevel = account;
for i = 1:(length(account)-1)
    if account(end-i)<lowLevel(end-i+1)
        lowLevel(end-i)=account(end-i);
    else
        lowLevel(end-i) = lowLevel(end-i+1);
    end
end
drawDown = (account-lowLevel)./(configure.multiplier * bars.open);

% maxDDR为最大回撤，MDDe为最大回撤结束点。MDDs为最大回撤开始点
maxDrawDown = max(drawDown);
time_tmp = find(drawDown==maxDrawDown,1,'first');
MDDs = datestr(bars.time(time_tmp));
MDDe = datestr(bars.time(find(lowLevel==...
    lowLevel(time_tmp),1,'last')));



% maxDDD为连续回撤的最大时间切片数，m_index3为最长连续回撤的结束点
highIndex = find(drawDown==0);
highIndex = [highIndex;length(account)];
[maxDDD,endIndex] = max(diff(highIndex));
maxDDD = maxDDD-1;

m_index3 = highIndex(endIndex+1);

% drawdownduration = zeros(size(account));
% cr = account/account(1);
% dd = zeros(size(account));
% for t = 1:length(cr)
%     high = max(cr(1:t));
%     dd(t) = (high-cr(t))./high;
% 
%     if dd(t)==0
%         drawdownduration (t)=0;
%     else 
%         drawdownduration (t)=drawdownduration(t-1)+1;
%     end
% end
% 
% % maxDDR为最大回撤，MDDe为最大回撤结束日。MDDs为最大回撤开始日
% maxDDR= max(dd);
% 
% MDDe = find(dd==maxDDR,1,'last'); 
% MDDs = find(abs(cr(MDDe)/(1-maxDDR)- cr) < 0.0000001);     % 最大回撤的开始日
% MDDs=MDDs(end,1);
% % maxDDD为连续回撤的最大天数，m_index3为连续回撤最大天数的结束日
% [maxDDD,m_index3] =max(drawdownduration);

end