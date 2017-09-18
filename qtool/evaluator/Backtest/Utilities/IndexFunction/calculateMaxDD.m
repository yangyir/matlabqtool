%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������������������������س������س��Ⱥ����س���
% ��maximum drawdown maximum drawdownratio and maximum drawdown duration��
% �Ѿ��ﵽ���ǵ���ţ����Լ���ﵽʱ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [maxDrawDown,MDDs,MDDe,maxDDD,m_index3] = calculateMaxDD(account)
highLevel = account;
for i = 2:length(account)
    if account(i)>highLevel(i-1)
        highLevel(i)=account(i);
    else
        highLevel(i) = highLevel(i-1);
    end
end
drawDown = (highLevel-account)./highLevel;

% maxDDRΪ���س���MDDeΪ���س������㡣MDDsΪ���س���ʼ��
maxDrawDown = max(drawDown);
MDDe = find(drawDown==maxDrawDown,1,'last');
MDDs = find(drawDown(1:MDDe)==0,1,'last');


% maxDDDΪ�����س������ʱ����Ƭ����m_index3Ϊ������س��Ľ�����
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
% % maxDDRΪ���س���MDDeΪ���س������ա�MDDsΪ���س���ʼ��
% maxDDR= max(dd);
% 
% MDDe = find(dd==maxDDR,1,'last'); 
% MDDs = find(abs(cr(MDDe)/(1-maxDDR)- cr) < 0.0000001);     % ���س��Ŀ�ʼ��
% MDDs=MDDs(end,1);
% % maxDDDΪ�����س������������m_index3Ϊ�����س���������Ľ�����
% [maxDDD,m_index3] =max(drawdownduration);

end