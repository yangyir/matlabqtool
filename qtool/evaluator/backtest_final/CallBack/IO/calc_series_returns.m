%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڼ��������������С�
% ��ҹ���ռ�������һ�졣����
% ��һ�������Ϊ��
% ����һ�����-��һ�쿪ʼ��/��һ�쿪ʼ
% �ڶ����Ժ��������Ϊ��
% �����ս���-���ս�����/���ս���
% �������֮��������գ�������ն�������һ�տ�ͷ��
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function returns = calc_series_returns(account,times)
startDay = floor(times(1));
endDay = floor(times(end));
if startDay == endDay
    returns = [startDay,account(end)/account(1)-1];
else
    days = floor(times);   
    dDays = diff(days);
    dayMark = find(dDays);
    dayMark = [1;dayMark;length(times)];
    dayYield = account(dayMark(2:end))./account(dayMark(1:end-1))-1;
    returns = [days(dayMark(2:end)),dayYield];
    
end

end