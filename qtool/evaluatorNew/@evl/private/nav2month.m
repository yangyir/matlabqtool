function [nav, Date] = nav2month(nav1 , Date1)
% ���κ����ڵ���������nav1ת��Ϊ����������
% ---------------------
% ��һ�Σ�20150730
Date = zeros(length(Date1),1)-1;
nav = zeros(length(nav1),1)-1;

i = Date1(1);
j = 1;
temp = findclose(Date1,i);   % ������ӽ�������
Date(j) = Date1(temp);
nav(j) = nav1(temp);
while(true)
    j = j + 1;
    i = i +30;
    if(findclose(Date1,i)==temp)
        break;
    else
        temp = findclose(Date1,i);   % ������ӽ�������
        Date(j) = Date1(temp);
        nav(j) = nav1(temp);
    end
    
end

Date = Date(Date>-1);
nav = nav(nav>-1);
end