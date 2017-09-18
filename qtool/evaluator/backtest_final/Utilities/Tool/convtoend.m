% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����������������ڽ����ڰ�Ƶ����Ƭ��fre�ɹ�ѡ����1�գ�2�ܣ�3�£�4���ȣ�5���ꣻ6�ꡣsty
% �ɹ�ѡ��1��Ȼ�գ�2�����ա����������Ƿ�������Ƭ�������ֹ���ڵ��߼����顣
% ��������� Day��vector||date������������
%           fre��int�����������ɹ�ѡ�1-�գ�2-�ܣ�3-�£�4-����5-���ꣻ6-�ꡣ
% ��������� output����ʼ�պͽ�ֹ��ʼ�հ����ķ��������Ƿ�������Ƭ�������ֹ���ڵ��߼�����
%           output2����ʼ�պͽ�ֹ��δ��ʼ�հ����ķ��������Ƿ�������Ƭ�������ֹ���ڵ��߼�����
% ���� [output,output2] = convtoend((datenum��today-100��:datenum(today))',2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


function  [output,output2] = convtoend(Day,fre)

if ~isa(Day,'numeric')
    Day =datenum(Day);
end

if size(Day,1) ==1
    error('Not enough data');
else
    switch fre
        case 1
            output = true(length(Day),1);
        case 2
             %  ���۽����ջ�����Ȼ�գ�ÿ�����һ�������塣
            output = logical([diff(week_num(Day,7));1]);
        case 3
            output = logical([diff(month(Day));1]);
        case 4
            output = logical([filter1(Day);1]);
        case 5
            output = logical([filter2(Day);1]);
        case 6
            output = logical([diff(year(Day));1]);
        otherwise
            output = true(length(Day),1);
    end
    %  ��ʼ�պͽ�ֹ�հ�������Ƭ�����У���ߺ��������ԡ�
    output2 =  output;
    output(1,1) = true;
    output(end,1) = true;
end
% ���ڲ���ÿ���������һ��
    function  output1 = filter1(data)
    output1 = (month(data(1:end-1,:)) == 3 & month(data(2:end,:)) == 4) | (month(data(1:end-1,:)) == 6 &month(data(2:end,:)) == 7) ...
        | (month(data(1:end-1,:)) == 9 &month(data(2:end,:)) == 10) | (month(data(1:end-1,:)) == 12 &month(data(2:end,:)) == 1) ;
    end
 % ���ڲ���ÿ���������һ��   
    function  output2 = filter2(data)
    output2 = (month(data(1:end-1,:)) == 6 & month(data(2:end,:)) == 7) | (month(data(1:end-1,:)) == 12 &month(data(2:end,:)) == 1);
    end
    
end