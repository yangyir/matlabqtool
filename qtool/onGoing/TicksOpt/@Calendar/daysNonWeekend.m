function [ n ] = daysNonWeekend( date1, date2 )
%DAYSNONWEEKEND ��������ʱ��֮��ļ��
% date1, date2 ��double����
% �̸գ�140617

%% Ԥ����

% �����ַ�������������
if isa(date1, 'char') || isa(date2, 'char')
    disp('����date1, date2������double��');
    return;
end


% date2 �� date1 С
if date2 < date1
    tmp = date1;
    date1 = date2;
    date2 = tmp;
end



%% main
% 1-Sun, 7-Sat
w1 = weekday(date1, 'en_US');
w2 = weekday(date2, 'en_US');


% �ж�������
n_weeks = floor((date2 - date1)/7);


% ���������У��ж��ٹ�����
if w1 == w2
    rem_days = 0;
elseif w1 < w2
    rem_days = nnz(w1+1:w2 > 1 & w1+1:w2 < 7);
elseif w1 > w2
    rem_days = max((6-w1),0)  + (w2-1);
end

% ����
n = n_weeks * 5 + rem_days;

end

