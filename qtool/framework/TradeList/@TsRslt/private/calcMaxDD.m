function [maxDD,MDDsIdx,MDDeIdx,longDDD,longDDeIdx] = calcMaxDD(nav)

% ���䳬�� V.10, from backtest��
% ���䳬��20140710��V2.0

highLevel = nav;
for i = 2:length(nav)
    % ǰ��һ�������ĸ��ʱȽϴ󣬷���if��
    if nav(i)<=highLevel(i-1)
        highLevel(i) = highLevel(i-1);
    else
        highLevel(i)=nav(i);   
    end
end
drawDown = (highLevel-nav)./highLevel;

% maxDDRΪ���س���MDDeΪ���س������㡣MDDsΪ���س���ʼ��
maxDD = max(drawDown);
MDDeIdx = find(drawDown==maxDD,1,'last');
% �޶���qp��20140710
MDDsIdx = find(drawDown(1:MDDeIdx)==0,1,'last');


% maxDDDΪ�����س������ʱ����Ƭ����m_index3Ϊ������س��Ľ�����
highIndex = find(drawDown==0);
highIndex = [highIndex;length(nav)];
[longDDD,endIndex] = max(diff(highIndex));

% �޶���qp��20140710
% longDDD = longDDD-1;

longDDeIdx = highIndex(endIndex+1);

end
