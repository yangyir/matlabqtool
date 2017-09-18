% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����������������ڽ����ڰ�Ƶ����Ƭ��fre�ɹ�ѡ����1�գ�2�ܣ�3�£�4���ȣ�5���ꣻ6�ꡣsty
% �ɹ�ѡ��1��Ȼ�գ�2�����ա����������Ƿ�������Ƭ��������ʼ���ڵ��߼����顣
% ��������� Day��vector||date������������
%           fre��int�����������ɹ�ѡ�1-�գ�2-�ܣ�3-�£�4-����5-���ꣻ6-�ꡣ
%           sty (int), �������ͣ��ɹ�ѡ���1-��Ȼ�գ�2-�����ա�
% ��������� output����ʼ�պͽ�ֹ��ʼ�հ����ķ��������Ƿ�������Ƭ��������ʼ���ڵ��߼�����
% ���� output = convtoend((datenum��today-100��:datenum(today))',2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  output = convtobegin(Day,fre,sty)

if ~isa(Day,'numeric')
    Day =datenum(Day);
end
switch fre
    case 1
        output = true(length(Day),1);
    case 2
        if sty ==1
            %   ��Ȼ�գ�һ��Ϊ���������壬��ÿ�ܵ�һ��Ϊ���������һ�������塣
            output = logical([diff(week_num(Day,1));1]);
        else
            %   �����գ�һ��Ϊ��һ�����壬��ÿ�ܵ�һ��Ϊ��һ�����һ�������塣
            output = logical([1;diff(week_num(Day,1))]);
        end
    case 3
        output = logical([1;diff(month(Day))]);
    case 4
        output = logical([1;filter1(Day)]);
    case 5
        output = logical([1;filter2(Day)]);
    case 6
        output = logical([1;diff(year(Day))]);
    otherwise
        output = true(length(Day),1);
end
%  ��ʼ�պͽ�ֹ�հ�������Ƭ�����У���ߺ��������ԡ�
output(1,1) = true;
output(end,1) = true;
% ���ڲ���ÿ���������һ��
    function  output1 = filter1(data)
        output1 = (month(data(1:end-1,:)) == 3 & month(data(2:end,:)) == 4) | (month(data(1:end-1,:)) == 6 &month(data(2:end,:)) == 7) ...
            | (month(data(1:end-1,:)) == 9 &month(data(2:end,:)) == 10) | (month(data(1:end-1,:)) == 12 &month(data(2:end,:)) == 1) ;
    end
% ���ڲ���ÿ��������һ��
    function  output2 = filter2(data)
        output2 = (month(data(1:end-1,:)) == 6 & month(data(2:end,:)) == 7) | (month(data(1:end-1,:)) == 12 &month(data(2:end,:)) == 1);
    end

end