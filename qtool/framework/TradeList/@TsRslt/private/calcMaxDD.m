function [maxDD,MDDsIdx,MDDeIdx,longDDD,longDDeIdx] = calcMaxDD(nav)

% 潘其超， V.10, from backtest。
% 潘其超，20140710，V2.0

highLevel = nav;
for i = 2:length(nav)
    % 前面一个发生的概率比较大，放在if。
    if nav(i)<=highLevel(i-1)
        highLevel(i) = highLevel(i-1);
    else
        highLevel(i)=nav(i);   
    end
end
drawDown = (highLevel-nav)./highLevel;

% maxDDR为最大回撤，MDDe为最大回撤结束点。MDDs为最大回撤开始点
maxDD = max(drawDown);
MDDeIdx = find(drawDown==maxDD,1,'last');
% 修订，qp，20140710
MDDsIdx = find(drawDown(1:MDDeIdx)==0,1,'last');


% maxDDD为连续回撤的最大时间切片数，m_index3为最长连续回撤的结束点
highIndex = find(drawDown==0);
highIndex = [highIndex;length(nav)];
[longDDD,endIndex] = max(diff(highIndex));

% 修订，qp，20140710
% longDDD = longDDD-1;

longDDeIdx = highIndex(endIndex+1);

end
