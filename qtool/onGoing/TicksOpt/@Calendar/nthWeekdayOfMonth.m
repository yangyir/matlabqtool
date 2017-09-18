function [ aimDate ] = nthWeekdayOfMonth( n, wkday, mm, yyyy )
%NTHWEEKDAYOFMONTH yyyymm�µĵ�n������k
% �ر�ע�⣬weekdayʹ�� 1-Sun ... 7-Sat ( LOCALE == en )
% �̸�;140616

%% Ԥ����
if ~exist('yyyy', 'var'),   yyyy = year(now); end
if ~exist('mm', 'var'),     mm = month(now); end

if isa(yyyy, 'char')
    yyyy = str2double(yyyy);
    if yyyy < 100
        yyyy = 2000+yyyy;
    end
end

if isa(mm, 'char')
    mm = str2double(mm);
    if mm<0 || mm>12
        disp('����mmӦΪ 1 - 12 ');
        return;
    end
end


if isa(wkday, 'double')
    k = floor(wkday); %ֱ�Ӿ���������
    if k>7 || k<=0
        disp('����: weekday ӦΪ 1 - 7');
        return;
    end
end

if isa(wkday, 'char')
    switch wkday
        case{'Sun', 'sun', 'Sunday', 'sunday'}
            k = 1;
        case{ 'Mon', 'mon'}
            k = 2;
        case{'Tue', 'tue'}
            k = 3;
        case{'Wed', 'wed'}
            k = 4;
        case{'Thu', 'thu'}
            k = 5;
        case{'Fri', 'fri'}
            k = 6;
        case{'Sat', 'sat'}
            k = 7;
        otherwise
            fprintf('����weekday = %s ����ʶ��', wkday);
            return;            
    end
end
               
if n>5
    disp('����n > 5 ');
    return;
end



%% main
firstDay = datenum(yyyy,mm,1);

[d,w] = weekday(firstDay);

% ��û����һ��k��
aimDate = firstDay + (n-1)*7 + (k-d);

% ���ܵ�k���ѹ������µ�һ��k��Ҫ������
if k < d
    aimDate = aimDate + 7;
end

% Ӧ�û�Ҫcheckһ���Ƿ���������ڣ��������
if mm < month(aimDate)
    disp('���棺����ѳ�������');
end




end

